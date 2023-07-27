import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/services/db_services.dart';

import '../../../widgets/buttons.dart';

class CustomRequestCardForReceivedRequest extends StatelessWidget {
  final dynamic userSnap;
  final dynamic createdData;
  final dynamic data;
  const CustomRequestCardForReceivedRequest({Key? key, this.userSnap, this.createdData, this.data}) : super(key: key);

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
              Text(createdData),
              SizedBox(
                width: 130,
                child: Row(
                  children: [
                    SuggestionButton(
                      onPressed: () async {
                        DocumentSnapshot tokenSnap = await FirebaseFirestore.instance.collection("tokens").doc(data['senderId']).get();
                        DocumentSnapshot userSnap =
                            await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
                        await DatabaseServices.deleteRequest(docId: data, msg: "Successfully Deleted The Request");

                        await DatabaseServices.sendNotificationToSpecificUser(
                          token: tokenSnap['token'],
                          title: "Request Notification",
                          body: "${userSnap['name']} Cancel Your Friend Request",
                          userId: data['senderId'],
                        );
                      },
                      title: "Cancel",
                      borderColor: Colors.red,
                    ),
                    SuggestionButton(
                        onPressed: () async {
                          DocumentSnapshot tokenSnap = await FirebaseFirestore.instance.collection("tokens").doc(data['fromUserId']).get();
                          DocumentSnapshot userSnap =
                              await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
                          await DatabaseServices.acceptRequest(
                            docId: data.id,
                            myId: FirebaseAuth.instance.currentUser!.uid,
                            friendId: data['fromUserId'],
                          );

                          await DatabaseServices.sendNotificationToSpecificUser(
                            token: tokenSnap['token'],
                            title: "Request Notification",
                            body: "${userSnap['name']} Accept Your Friend Request",
                            userId: data['fromUserId'],
                          );
                          await DatabaseServices.notificationMessages(
                              senderName: userSnap['name'],
                              friendUid: data['fromUserId'],
                              msg: "Accept your Friend Request",
                              senderImage: userSnap['photo']);
                          await DatabaseServices.deleteRequest(docId: data.id, msg: "Request Accepted");
                          Navigator.pop(context!);
                        },
                        title: "Accept",
                        borderColor: Colors.green),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
