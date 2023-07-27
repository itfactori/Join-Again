import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/profile_creation/userphotoemail.dart';
import 'package:join/services/auth_service.dart';

import '../../custom_navbar/custom_navbar.dart';

class CheckStatus extends StatefulWidget {
  const CheckStatus({super.key});

  @override
  State<CheckStatus> createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> {
  @override
  void initState() {
    checkresult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading Please Wait"),
      ),
    );
  }

  void checkresult() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    final bool doesDocExist = doc.exists;

    if (doesDocExist) {
      Navigator.push(context!, MaterialPageRoute(builder: (builder) => CustomNavBar()));
    } else {
      AuthServices().emailGoogle().then((value) => {Navigator.push(context, MaterialPageRoute(builder: (builder) => UserPhotoEmail()))});
    }
  }
}
