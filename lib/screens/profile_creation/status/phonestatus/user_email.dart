import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/profile_creation/select_gender.dart';
import 'package:join/widgets/custom_input.dart';
import 'package:join/widgets/snakbar.dart';

import '../../../../widgets/primary_button.dart';

class UserEmail extends StatefulWidget {
  const UserEmail({super.key});

  @override
  State<UserEmail> createState() => _UserEmailState();
}

class _UserEmailState extends State<UserEmail> {
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/splash.png",
              height: 150,
              width: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            CustomInput(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: "Enter Your Email",
              prefixIcon: Icons.email,
            ),
            SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    //todo
                    onTap: createProfile,
                    title: "Next",
                  ),
          ],
        ),
      ),
    );
  }

  void createProfile() async {
    if (emailController.text.isEmpty) {
      showSnakBar("Email are Required", context);
    } else {
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "email": emailController.text,
      });
      setState(() {
        _isLoading = false;
      });
      showSnakBar("Email is Added", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const SelectGender()));
    }
  }
}
