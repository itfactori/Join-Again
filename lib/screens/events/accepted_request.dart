import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/widgets/buttons.dart';

class ReceivedRequestForActivityJoininig extends StatefulWidget {
  const ReceivedRequestForActivityJoininig({super.key});

  @override
  State<ReceivedRequestForActivityJoininig> createState() => _ReceivedRequestForActivityJoininigState();
}

class _ReceivedRequestForActivityJoininigState extends State<ReceivedRequestForActivityJoininig> {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("activity").where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Text("No Request Found");
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, docIndex) {
              return Column(
                children: snapshot.data!.docs[docIndex]['requestedUserIds'].map<Widget>((userId) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users").doc(userId).snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var userSnap = snap.data!.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          leading: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              child: Image.network(userSnap['photo'], fit: BoxFit.cover),
                            ),
                          ),
                          title: Text(userSnap['name']),
                          subtitle: Row(
                            children: [
                              SuggestionButton(
                                onPressed: () async {
                                  try {
                                    await FirebaseFirestore.instance.collection("activity").doc(snapshot.data!.docs[docIndex].id).update({
                                      "acceptedUser": FieldValue.arrayUnion([userSnap['uid']]),
                                    });
                                    await FirebaseFirestore.instance.collection("activity").doc(snapshot.data!.docs[docIndex].id).update({
                                      "requestedUserIds": FieldValue.arrayRemove([userSnap['uid']]),
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                borderColor: Colors.green,
                                title: "Confirm",
                              ),
                              SuggestionButton(
                                onPressed: () async {
                                  try {
                                    await FirebaseFirestore.instance.collection("activity").doc(snapshot.data!.docs[docIndex].id).update({
                                      "requestedUserIds": FieldValue.arrayRemove([userSnap['uid']]),
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                borderColor: Colors.red,
                                title: "Cancel",
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
