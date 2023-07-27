import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/widgets/buttons.dart';

import '../../../services/db_services.dart';

class CustomRequestCard extends StatelessWidget {
  final dynamic userSnap;
  final dynamic date;
  final dynamic requestCollectionData;
  const CustomRequestCard({Key? key, this.userSnap, this.date, this.requestCollectionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 05),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            child: Text(userSnap['name'][0].toString().toUpperCase()),
          ),
          title: Text(userSnap['name']),
          subtitle: Text(userSnap['phone']),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date),
              const SizedBox(height: 3),
              SuggestionButton(
                onPressed: () async {
                  DocumentSnapshot token = await FirebaseFirestore.instance.collection("tokens").doc(userSnap['uid']).get();
                  DocumentSnapshot user =
                      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
                  await DatabaseServices.deleteRequest(
                    docId: requestCollectionData.id,
                    msg: "Request Successfully Cancel",
                  );
                  await DatabaseServices.sendNotificationToSpecificUser(
                    token: token['token'],
                    title: "Cancel Request Notification",
                    body: "${user['name']} Cancel Your Friend Request",
                    userId: userSnap['uid'],
                  );
                },
                title: "Cancel",
                borderColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
