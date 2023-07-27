import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../widgets/image_uploading_widget.dart';

class UserPhotoWidgetProfileScreen extends StatefulWidget {
  const UserPhotoWidgetProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserPhotoWidgetProfileScreen> createState() => _UserPhotoWidgetProfileScreenState();
}

class _UserPhotoWidgetProfileScreenState extends State<UserPhotoWidgetProfileScreen> {
  Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [BoxShadow(offset: Offset(0, 0), color: Colors.grey, blurRadius: 2)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                var document = snapshot.data;
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: selectImage,
                    child: Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0x20FF7E87),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 3,
                                  color: const Color(0xFFFF7E87),
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(document['photo']),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 3,
                              right: 5,
                              child: Image.asset(
                                "assets/cmr.png",
                                height: 25,
                                width: 25,
                                fit: BoxFit.cover,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  var document = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document['name'] ?? "",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(color: Color(0xff160F29), fontWeight: FontWeight.w600, fontFamily: "ProximaNova", fontSize: 18),
                      ),
                      Text(
                        document['email'] ?? "",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400, fontFamily: "ProximaNova", fontSize: 12),
                      ),
                    ],
                  );
                }),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      _image = ui;
    });
  }
}
