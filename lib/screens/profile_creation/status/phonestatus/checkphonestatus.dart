import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/profile_creation/status/phonestatus/user_phone_photo_email.dart';
import 'package:join/services/auth_service.dart';

import '../../../../utils/globals.dart';
import '../../../custom_navbar/custom_navbar.dart';

class CheckPhoneStatus extends StatefulWidget {
  const CheckPhoneStatus({super.key});

  @override
  State<CheckPhoneStatus> createState() => _CheckPhoneStatusState();
}

class _CheckPhoneStatusState extends State<CheckPhoneStatus> {
  @override
  void initState() {
    // TODO: implement initState
    checkresult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Loading Please wait"),
      ),
    );
  }

  void checkresult() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final bool doesDocExist = doc.exists;
    userID = FirebaseAuth.instance.currentUser!.uid;
    if (doesDocExist) {
      print("wrong which");
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => CustomNavBar()));
    } else {
      // AuthServices().phone().then((value) => {
      //       Navigator.push(context,
      //           MaterialPageRoute(builder: (builder) => UserPhonePhotoEmail()))
      //     });
    }
  }
}
