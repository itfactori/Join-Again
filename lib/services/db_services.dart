import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:join/screens/custom_navbar/custom_navbar.dart';
import 'package:join/utils/globals.dart';
import 'package:uuid/uuid.dart';

import '../screens/chat/group_chat/group_chat_screen.dart';

class DatabaseServices {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  static sendRequestToUserForChat({BuildContext? context, String? receiverId}) async {
    var requestId = const Uuid().v1();
    try {
      EasyLoading.show(status: "Please Wait");
      await FirebaseFirestore.instance.collection("requests").doc(requestId).set({
        "senderId": FirebaseAuth.instance.currentUser!.uid,
        "receiverId": receiverId,
        "requestId": requestId,
        "createdAt": DateTime.now(),
        "status": "pending",
      });
      EasyLoading.dismiss();
      Navigator.pop(context!);
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());

      EasyLoading.dismiss();
    }
  }

  static deleteRequest({String? docId, String? msg}) async {
    try {
      EasyLoading.show(status: "Please Wait");
      await FirebaseFirestore.instance.collection("requests").doc(docId).delete();
      EasyLoading.dismiss();
      EasyLoading.showSuccess("$msg");
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  static acceptRequest({String? docId, String? myId, String? friendId}) async {
    try {
      EasyLoading.show(status: "Please Wait");
      await FirebaseFirestore.instance.collection("requests").doc(docId).update({
        "status": "accept",
      });
      await FirebaseFirestore.instance.collection("users").doc(myId).update({
        "friends": FieldValue.arrayUnion([friendId]),
      });
      await FirebaseFirestore.instance.collection("users").doc(friendId).update({
        "friends": FieldValue.arrayUnion([myId]),
      });
      EasyLoading.dismiss();
      print("==================$friendId");
      EasyLoading.showSuccess("Successfully Added to Your FriendList");
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  static oneToOneChat({String? docId, String? friendId, String? msg, String? file, String? location, String? image}) async {
    try {
      DocumentSnapshot chat = await FirebaseFirestore.instance.collection("chat").doc(docId).get();
      DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      if (chat.exists) {
        await FirebaseFirestore.instance.collection("chat").doc(docId).update({
          "msg": msg,
          "createdAt": DateTime.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection("chat").doc(docId).set({
          "msg": msg,
          "createdAt": DateTime.now(),
          "uids": [FirebaseAuth.instance.currentUser!.uid, friendId],
        });
      }
      await FirebaseFirestore.instance.collection("chat").doc(docId).collection("messages").add({
        "msg": msg,
        "file": file,
        "location": location,
        "image": image,
        "createdAt": DateTime.now(),
        "senderName": userSnap['name'],
        "senderId": userSnap['uid'],
        "senderImage": userSnap['photo'],
      });
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  static sendingFilesInChat({String? docId, String? friendId, String? file}) async {
    try {
      if (file!.isEmpty) {
        EasyLoading.showError("Enter Some Text");
      } else {
        DocumentSnapshot chat = await FirebaseFirestore.instance.collection("chat").doc(docId).get();
        DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
        if (chat.exists) {
          await FirebaseFirestore.instance.collection("chat").doc(docId).update({
            "msg": file,
            "createdAt": DateTime.now(),
          });
        } else {
          await FirebaseFirestore.instance.collection("chat").doc(docId).set({
            "msg": file,
            "createdAt": DateTime.now(),
            "uids": [FirebaseAuth.instance.currentUser!.uid, friendId],
          });
        }
        await FirebaseFirestore.instance.collection("chat").doc(docId).collection("messages").add({
          "msg": file,
          "createdAt": DateTime.now(),
          "senderName": userSnap['name'],
          "senderId": userSnap['uid'],
          "senderImage": userSnap['photo'],
        });
      }
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  static groupChat({String? docId, String? msg}) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    try {
      await FirebaseFirestore.instance.collection("groupChat").doc(docId).collection("messages").add({
        "msg": msg,
        "createdAt": DateTime.now(),
        "senderName": snap['name'],
        "senderId": snap['uid'],
        "senderImage": snap['photo'],
      });
    } on FirebaseException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  static cancelEventRequest({String? docId}) async {
    try {
      EasyLoading.show(status: "Please Wait");
      await FirebaseFirestore.instance.collection("joins").doc(docId).delete();
      EasyLoading.dismiss();
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  static acceptEventRequest({String? activityId, String? userId, String? groupId, String? docId}) async {
    try {
      EasyLoading.show(status: "Please Wait");
      await FirebaseFirestore.instance.collection("activity").doc(activityId).update({
        "acceptedUser": FieldValue.arrayUnion([userId]),
      });
      await FirebaseFirestore.instance.collection("groupChat").doc(groupId).update({
        "membersId": FieldValue.arrayUnion([userId]),
      });
      await FirebaseFirestore.instance.collection("joins").doc(docId).delete();
      EasyLoading.dismiss();
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());

      EasyLoading.dismiss();
    }
  }

  static sendNotificationToSpecificUser({
    String? token,
    String? title,
    String? body,
    String? userId,
  }) async {
    Map<String, String> notificationHeader = {
      "Content-Type": "application/json",
      "Authorization": messagingKey,
    };

    Map notificationBody = {
      "title": title,
      "body": body,
    };
    Map notificationData = {
      "status": "done",
      "userId": userId,
      "docId": "123",
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
    };
    Map notificationFormat = {
      "notification": notificationBody,
      "data": notificationData,
      "priority": "high",
      "to": token,
    };

    http
        .post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: notificationHeader,
      body: jsonEncode(notificationFormat),
    )
        .then((value) {
      print('Response status: ${value.statusCode}');
    }).catchError((e) {
      print("Error ");
    });
  }

  static notificationMessages({String? msg, dynamic friendUid, String? senderName, String? senderImage}) async {
    await FirebaseFirestore.instance.collection("notifications").add({
      "friendUid": friendUid,
      "title": msg,
      "senderId": FirebaseAuth.instance.currentUser!.uid,
      "senderName": senderName,
    });
  }

  static sendFriendRequestToUser({dynamic toUserId}) async {
    DocumentSnapshot token = await FirebaseFirestore.instance.collection("tokens").doc(toUserId).get();
    DocumentSnapshot user = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    try {
      EasyLoading.show(status: "Please Wait");
      QuerySnapshot requestQuery = await FirebaseFirestore.instance
          .collection("requests")
          .where("fromUserId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("toUserId", isEqualTo: toUserId)
          .get();

      if (requestQuery.docs.isNotEmpty) {
        EasyLoading.showError("Already Sent Request to This User");
        return;
      } else {
        await FirebaseFirestore.instance.collection("requests").add({
          "fromUserId": FirebaseAuth.instance.currentUser!.uid,
          "toUserId": toUserId,
          "status": "pending",
          "createdAt": DateTime.now(),
        });
        await sendNotificationToSpecificUser(
          title: "You have Received a Friend Request",
          body: "${user['name']} sent you a new friend Request",
          token: token['token'],
          userId: toUserId,
        );
        await FirebaseFirestore.instance.collection('notifications').add({
          "toUserId": toUserId,
          "fromUserId": FirebaseAuth.instance.currentUser!.uid,
          "msg": "${user['name']} send Friend Request",
          "createdAt": DateTime.now(),
        });
      }

      EasyLoading.showSuccess("Request Sent Successfully");
      EasyLoading.dismiss();
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  //===============Activity Joining ===============================//

  static joinActivityWhenPresentInListOrActivityPublic({BuildContext? context, String? toUserId, dynamic eventId}) async {
    try {
      DocumentSnapshot token = await FirebaseFirestore.instance.collection("tokens").doc(toUserId).get();
      DocumentSnapshot user = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      print("===============${token['token']}");
      await FirebaseFirestore.instance.collection("groupChat").doc(eventId).update({
        "membersId": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
      print("===============${token['token']}");

      await DatabaseServices.sendNotificationToSpecificUser(
        title: "Activity Joining Notification",
        body: "${user['name']} Start Joining Your Activity",
        token: token['token'],
        userId: toUserId,
      );
      print("===============${token['token']}");
      Navigator.of(context!).push(
        MaterialPageRoute(
          builder: (_) => GroupChatScreen(
            docId: eventId,
          ),
        ),
      );
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
    }
  }

  static sendingRequestForJoiningActivity({BuildContext? context, String? docId, String? toUserId}) async {
    try {
      DocumentSnapshot token = await FirebaseFirestore.instance.collection("tokens").doc(toUserId).get();
      DocumentSnapshot user = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      await FirebaseFirestore.instance.collection("activity").doc(docId).update({
        "requestedUserIds": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      });
      await sendNotificationToSpecificUser(
        token: token['token'],
        title: "Activity Joining Request",
        body: "${user['name']} Want to Join your Activity",
        userId: toUserId,
      );
      EasyLoading.showSuccess("Request Send Successfully");
      Navigator.of(context!).push(MaterialPageRoute(builder: (_) => CustomNavBar()));
    } on FirebaseException catch (e) {
      EasyLoading.showError(e.message.toString());
    }
  }
}
