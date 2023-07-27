import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:join/services/db_services.dart';
import 'package:join/widgets/primary_button.dart';

class DetailPageActivityFooter extends StatefulWidget {
  final dynamic data;
  const DetailPageActivityFooter({Key? key, this.data}) : super(key: key);

  @override
  State<DetailPageActivityFooter> createState() => _DetailPageActivityFooterState();
}

class _DetailPageActivityFooterState extends State<DetailPageActivityFooter> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(offset: Offset(0, 0), blurRadius: 1, color: Colors.grey)]),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").doc(widget.data['uid']).snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            var document = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Created By",
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const SizedBox(width: 7),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(document['photo']),
                      ),
                      const SizedBox(width: 7),
                      Text(
                        document['name'],
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // ===== When The User Create His Own Activity=============//
                  if (widget.data['uid'] == FirebaseAuth.instance.currentUser!.uid)
                    PrimaryButton(
                      title: "Edit",
                      onTap: () {},
                    )
                  //========== If Owner Accept It Request of Joining=============//
                  else if (widget.data['acceptedUser'].contains(FirebaseAuth.instance.currentUser!.uid))
                    PrimaryButton(
                        title: "Chat",
                        onTap: () async {
                          await DatabaseServices.joinActivityWhenPresentInListOrActivityPublic(
                            context: context,
                            toUserId: widget.data['uid'],
                            eventId: widget.data['eventId'],
                          );
                          print(widget.data['eventId']);
                        })
                  //======= if Request Send But Not Accept yet=========//
                  else if (widget.data['requestedUserIds'].contains(FirebaseAuth.instance.currentUser!.uid))
                    PrimaryButton(
                        title: "Joined Request Sent",
                        onTap: () {
                          EasyLoading.showSuccess("Your Request is Already Sent");
                        })
                  //====== If Activity is Private =========//
                  else if (widget.data['isActivityPrivate'] == true)
                    PrimaryButton(
                        title: "Join",
                        onTap: () async {
                          await DatabaseServices.sendingRequestForJoiningActivity(
                            context: context,
                            docId: widget.data['eventId'],
                            toUserId: widget.data['uid'],
                          );
                        })
                  //todo share Button whole Activity will share
                  //todo the button will turn to Chat And then the user will chat

                  else
                    PrimaryButton(
                      title: "Join",
                      onTap: () async {
                        await DatabaseServices.joinActivityWhenPresentInListOrActivityPublic(
                          context: context,
                          toUserId: widget.data['uid'],
                          eventId: widget.data['eventId'],
                        );
                      },
                    )
                ],
              ),
            );
          }),
    );
  }
}
