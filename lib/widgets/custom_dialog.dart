import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:join/services/db_services.dart';

showCustomDialog(BuildContext context, dynamic data) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return CupertinoAlertDialog(
        title: const Text("Wait"),
        content: const Text("Are you Sure for Sending Request to This User"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context!);
            },
            child: const Text(
              "No",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              await DatabaseServices.sendRequestToUserForChat(context: context, receiverId: data['uid']);
              DocumentSnapshot userSnap =
                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
              DocumentSnapshot snap = await FirebaseFirestore.instance.collection("tokens").doc(data['uid']).get();
              DatabaseServices.sendNotificationToSpecificUser(
                token: snap['token'],
                title: "Hello",
                body: "You have receive a request from ${userSnap['name']}",
                userId: data['uid'],
              );
              await DatabaseServices.notificationMessages(
                friendUid: data['uid'],
                msg: "You Have Received A friend Request from",
                senderName: userSnap['name'],
              );
            },
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}
