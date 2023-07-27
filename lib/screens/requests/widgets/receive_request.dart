import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'custom_card_for_recieved_request.dart';

class ReceivedRequest extends StatelessWidget {
  const ReceivedRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("requests")
          .where("toUserId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return   Column(
            children: [
              SizedBox(height: 300),
              Text("No Request Found Yet!"),
            ],
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(snapshot.data!.docs[index]['fromUserId']).snapshots(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var userSnap = snap.data!.data() as Map<String, dynamic>;
                  return CustomRequestCardForReceivedRequest(
                    userSnap: userSnap,
                    createdData: timeago.format(snapshot.data!.docs[index]['createdAt'].toDate()),
                    data: snapshot.data!.docs[index],
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
