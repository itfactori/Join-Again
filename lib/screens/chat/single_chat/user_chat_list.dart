import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/chat/single_chat/chat_main_screen.dart';

import '../../../widgets/text_input.dart';

class UserChatList extends StatelessWidget {
  const UserChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              SearchTextInput(
                onChanged: (v) {},
                controller: TextEditingController(),
                hintText: 'search',
                prefixIcon: Icons.search,
              ),
              SizedBox(
                height: 400,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("chat")
                      .where("uids", arrayContains: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 200),
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            Image.asset("assets/msg.png", height: 42),
                            const SizedBox(height: 10),
                            const Text(
                              "No User Found!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              "No User For Chat were found. Please change the search parameter, or start a new chat over the map.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var snap = snapshot.data!.docs[index];
                        getUserById() {
                          if (snap['uids'][0] == FirebaseAuth.instance.currentUser!.uid) {
                            return snap['uids'][1];
                          } else {
                            return snap['uids'][0];
                          }
                        }

                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection("users").doc(getUserById()).snapshots(),
                          builder: (context, userSnap) {
                            if (!userSnap.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            var userData = userSnap.data!.data() as Map<String, dynamic>;
                            return Column(
                              children: [
                                Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ChatMainScreen(
                                              friendId: userData['uid'],
                                            ),
                                          ),
                                        );
                                      },
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(08),
                                          color: Colors.grey,
                                        ),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(08),
                                            child: Image.network(userData['photo'], fit: BoxFit.cover)),
                                      ),
                                      title: Text(userData['name']),
                                      subtitle: Text(snap['msg'], style: const TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
