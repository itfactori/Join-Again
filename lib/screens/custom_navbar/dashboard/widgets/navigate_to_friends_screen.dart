import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../friends/friends_screen.dart';

void navigateToFriendsScreen(BuildContext context) {
  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((snapshot) {
    if (snapshot.exists) {
      var userList = snapshot.data() as Map<String, dynamic>;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FriendsScreen(
            userList: userList['friends'],
          ),
        ),
      );
    }
  });
}
