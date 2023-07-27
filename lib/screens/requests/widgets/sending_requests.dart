import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'custom_request_card_for_send_request.dart';

class SendingRequest extends StatelessWidget {
  const SendingRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("requests")
          .where("fromUserId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("status", isEqualTo: "pending")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return   Column(
            children: [
              SizedBox(height: 300),
              Text("You are not Send Request"),
            ],
          );
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(snapshot.data!.docs[index]['toUserId']).snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var userSnap = snap.data!.data() as Map<String, dynamic>;
                  var data = snapshot.data!.docs[index];

                  return CustomRequestCard(
                    requestCollectionData: data,
                    userSnap: userSnap,
                    date: timeago.format(snapshot.data!.docs[index]['createdAt'].toDate()),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
