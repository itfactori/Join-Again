import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../themes/app_colors.dart';

class GroupChatCard extends StatelessWidget {
  final dynamic data;
  const GroupChatCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: data['senderId'] == FirebaseAuth.instance.currentUser!.uid ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          data['senderId'] == FirebaseAuth.instance.currentUser!.uid
              ? CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(data['senderImage']),
                )
              : const SizedBox(),
          Align(
            alignment: data['senderId'] == FirebaseAuth.instance.currentUser!.uid ? Alignment.topLeft : Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 7, left: 10),
              decoration: BoxDecoration(
                color: data['senderId'] == FirebaseAuth.instance.currentUser!.uid ? Colors.white : AppColors.mainColor,
                borderRadius: data['senderId'] == FirebaseAuth.instance.currentUser!.uid
                    ? const BorderRadius.only(bottomRight: Radius.circular(10), topRight: Radius.circular(10), topLeft: Radius.circular(10))
                    : const BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        data['msg'],
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: data['senderId'] == FirebaseAuth.instance.currentUser!.uid ? Colors.black54 : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            data['senderName'] + ",",
                            style: TextStyle(
                              color: data['senderId'] == FirebaseAuth.instance.currentUser!.uid ? Colors.black54 : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            DateFormat('hh:mm a').format(data['createdAt'].toDate()),
                            style: TextStyle(
                              color: data['senderId'] == FirebaseAuth.instance.currentUser!.uid ? Colors.black54 : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data['senderId'] == FirebaseAuth.instance.currentUser!.uid
              ? const SizedBox()
              : CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(data['senderImage']),
                ),
        ],
      ),
    );
  }
}
