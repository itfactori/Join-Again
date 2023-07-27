import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:join/screens/profile_creation/status/phonestatus/user_email.dart';
import 'package:join/widgets/snakbar.dart';

import '../../../../widgets/primary_button.dart';

class UserPhoneDob extends StatefulWidget {
  const UserPhoneDob({super.key});

  @override
  State<UserPhoneDob> createState() => _UserPhoneDobState();
}

class _UserPhoneDobState extends State<UserPhoneDob> {
  TextEditingController nameController = TextEditingController();
  bool _isLoading = false;
  DateTime? _selectedDate;

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
            TextFormField(
              onTap: () {
                _selectDate(context);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.person_2,
                  color: Colors.grey,
                ),
                filled: true,
                contentPadding: const EdgeInsets.only(top: 10),
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
                disabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
                hintText: "Enter Date of Birth",
                helperStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              focusNode: FocusNode(),
              controller: nameController,
            ),
            const SizedBox(height: 20),
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

  _selectDate(BuildContext context) async {
    var newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      nameController
        ..text = DateFormat.yMMMd().format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(offset: nameController.text.length, affinity: TextAffinity.upstream));
    }
  }

  void createProfile() async {
    if (nameController.text.isEmpty) {
      showSnakBar("All Fields are Required", context);
    } else {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "dob": nameController.text,
      });
      setState(() {
        _isLoading = false;
      });
      showSnakBar("Date of Birth is Added", context);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const UserEmail()));
    }
  }
}
