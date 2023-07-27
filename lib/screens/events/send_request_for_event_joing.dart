import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendRequestForActivityJoining extends StatefulWidget {
  const SendRequestForActivityJoining({super.key});

  @override
  State<SendRequestForActivityJoining> createState() => _SendRequestForActivityJoiningState();
}

class _SendRequestForActivityJoiningState extends State<SendRequestForActivityJoining> {
  int accept = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("activity")
          .where("requestedUserIds", arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("You have Not Selected Any Activity"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var data = snapshot.data!.docs[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(data['photo']),
                      ),
                    ),
                    title: Text(
                      "Event Name: ${data['title']}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        /*   SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Row(
                            children: [
                              SuggestionButton(
                                onPressed: () {
                                  showCustomAlertDialog(
                                    context: context,
                                    content: "Do you want to cancel the request?",
                                    onPressed: () async {
                                      Navigator.pop(context!);
                                      await DatabaseServices.cancelEventRequest(
                                        docId: data.id,
                                      );
                                    },
                                  );
                                },
                                title: "Cancel",
                                borderColor: Colors.red,
                              ),
                            ],
                          ),
                        )*/
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

showCustomAlertDialog({BuildContext? context, String? content, Function()? onPressed}) {
  return showDialog(
      context: context!,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text("Wait"),
          content: Text(content!),
          actions: [
            CupertinoActionSheetAction(
              onPressed: onPressed ?? () {},
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      });
}
