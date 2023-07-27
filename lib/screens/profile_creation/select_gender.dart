import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/widgets/snakbar.dart';

import '../../widgets/primary_button.dart';
import '../custom_navbar/custom_navbar.dart';

class SelectGender extends StatefulWidget {
  const SelectGender({super.key});

  @override
  State<SelectGender> createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  List<String> dropdownItemList = [
    "Male",
    "Female",
    "Others",
  ];

  String art = "Male";
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
            DropdownButtonFormField<String>(
              focusColor: Colors.black,
              decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Colors.black),
                  fillColor: Colors.black,
                  labelStyle: const TextStyle(color: Colors.black),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.black),
                  )),
              borderRadius: BorderRadius.circular(6),
              value: art,
              isDense: true,
              isExpanded: true,
              icon: Image.asset(
                "assets/Chevon Left.png",
                height: 16,
                width: 16,
              ),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  art = value!;
                });
              },
              items: dropdownItemList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
    if (art.isEmpty) {
      showSnakBar("All Fields are Required", context);
    } else {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "gender": art,
      });
      setState(() {
        _isLoading = false;
      });
      showSnakBar("Gender is Added", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CustomNavBar()));
    }
  }
}
