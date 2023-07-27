import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:join/services/db_services.dart';
import 'package:join/themes/app_colors.dart';

import '../../../widgets/text_input.dart';
import 'chat_card.dart';

class ChatMainScreen extends StatefulWidget {
  final String? friendId;

  const ChatMainScreen({Key? key, this.friendId}) : super(key: key);

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  bool isAttachmentVisible = false;
  bool isFileSelected = false;

  TextEditingController chatController = TextEditingController();
  String docId = '';
  String username = '';
  String userImage = '';

  var myId = FirebaseAuth.instance.currentUser!.uid;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (myId.hashCode > widget.friendId.hashCode) {
      docId = myId + widget.friendId!;
    } else {
      docId = widget.friendId! + myId;
    }
    getUserData();
    super.initState();
  }

  getUserData() async {
    DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection("users").doc(widget.friendId).get();
    setState(() {
      username = userSnap['name'];
      userImage = userSnap['photo'];
    });
  }

  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String? filePath;
  String? fileName;

  FilePickerResult? selectedFile;
  void _openFile(PlatformFile file) {
    // OpenFile.open(file.path);
  }

  _pickFile() async {
    selectedFile = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (selectedFile == null) return null;

    final file = selectedFile!.files.first;

    filePath = file.path;
    fileName = file.name;

    setState(() {
      isFileSelected = true;
      isAttachmentVisible = false;
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Widget filePreviewWidget = SizedBox(); // Empty container by default
    if (filePath != null && fileName != null) {
      filePreviewWidget = ListTile(
        leading: const Icon(Icons.insert_drive_file),
        title: Text(fileName!),
        onTap: () {
          // Handle previewing the file
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.keyboard_arrow_left, size: 35),
        ),
        iconTheme: IconThemeData(
          color: AppColors.mainColor,
        ),
        centerTitle: true,
        title: Row(
          children: [
            SizedBox(
              height: 30,
              child: CircleAvatar(
                backgroundImage: NetworkImage(userImage),
              ),
            ),
            Text(
              username,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/msg_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                width: double.infinity,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chat")
                      .doc(docId)
                      .collection("messages")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return ChatCard(data: data);
                      },
                    );
                  },
                ),
              ),
            ),
            // if (isFileSelected)
            //   Column(
            //     children: [
            //       filePreviewWidget,
            //       ElevatedButton(
            //         onPressed: () async {
            //           if (filePath != null && fileName != null) {
            //             final root = firebaseStorage.ref();
            //             final fileFulRef = root.child("chat_files/$fileName");
            //             File file = File(filePath!);
            //             assert(fileName == fileFulRef.name);
            //             assert(filePath != fileFulRef.fullPath);
            //             await fileFulRef.putFile(file);
            //
            //             final downloadUrl = await fileFulRef.getDownloadURL();
            //
            //             await DatabaseServices.oneToOneChat(
            //               docId: docId,
            //               friendId: widget.friendId,
            //               msg: '',
            //               file: downloadUrl,
            //               location: '',
            //               image: '',
            //             );
            //
            //             setState(() {
            //               isFileSelected = false;
            //               filePath = null;
            //               fileName = null;
            //             });
            //           }
            //         },
            //         child: const Text('Send File'),
            //       ),
            //     ],
            //   ),
            // const SizedBox(height: 10),
            // if (isAttachmentVisible)
            //   AttachmentWidget(
            //     onFileClicked: _pickFile,
            //   ),
            ChatTextInput(
              onLinkClicked: () {
                setState(() {
                  // isAttachmentVisible = !isAttachmentVisible;
                });
              },
              chatController: chatController,
              onPressed: () async {
                setState(() {});

                DocumentSnapshot snap = await FirebaseFirestore.instance.collection("tokens").doc(widget.friendId).get();
                DocumentSnapshot userSnap =
                    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
                await DatabaseServices.oneToOneChat(
                  docId: docId,
                  friendId: widget.friendId,
                  msg: chatController.text,
                );

                await DatabaseServices.sendNotificationToSpecificUser(
                  title: "A New Chat Message from ${userSnap['name']}",
                  body: chatController.text,
                  token: snap['token'],
                  userId: widget.friendId,
                );

                setState(() {
                  FocusScope.of(context).unfocus();
                  chatController.clear();
                });
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
