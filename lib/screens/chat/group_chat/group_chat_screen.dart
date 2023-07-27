import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../services/db_services.dart';
import '../../../themes/app_colors.dart';
import '../../../widgets/text_input.dart';
import 'group_chat_card.dart';

class GroupChatScreen extends StatefulWidget {
  final String? docId;
  const GroupChatScreen({Key? key, this.docId}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController chatController = TextEditingController();

  String groupName = '';
  getGroupInformation() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("groupChat").doc(widget.docId).get();
    setState(() {
      groupName = snap['groupName'];
    });
  }

  @override
  void initState() {
    getGroupInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          groupName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/msg_bg.png"),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: double.infinity,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("groupChat")
                        .doc(widget.docId)
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
                          return GroupChatCard(data: data);
                        },
                      );
                    },
                  )),
            ),
            ChatTextInput(
              chatController: chatController,
              onPressed: () async {
                await DatabaseServices.groupChat(
                  docId: widget.docId,
                  msg: chatController.text,
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
