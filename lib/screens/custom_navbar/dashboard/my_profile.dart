import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/custom_navbar/dashboard/widgets/user_custom_card.dart';
import 'package:join/screens/custom_navbar/dashboard/widgets/user_photo_widget_profile_screen.dart';

import '../../../services/storage_services.dart';
import '../../../widgets/text_input.dart';
import '../../settings/app_setting.dart';
import '../custom_navbar.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController searchController = TextEditingController();

  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontFamily: "ProximaNova",
            fontSize: 20,
            color: Color(0xff160F29),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const AppSetting()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(height: 40, width: 40, child: Image.asset("assets/set.png")),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xff368f8b),
                  Color(0xffff6e78),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            height: MediaQuery.of(context).size.height * 0.9,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffEbf1f3),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(140),
                topLeft: Radius.circular(140),
              ),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 180),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        child: SearchTextInput(
                            controller: searchController,
                            onChanged: (v) {
                              setState(() {});
                            },
                            hintText: "Search",
                            prefixIcon: Icons.search),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("users").snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text("No User Found"),
                              );
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];
                                if (searchController.text.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    child: Column(
                                      children: [
                                        UserCustomCard(data: data),
                                        const SizedBox(height: 10),
                                        const Divider(thickness: 1, height: 1, indent: 20, endIndent: 20),
                                      ],
                                    ),
                                  );
                                } else if (data['name'].toString().toLowerCase().contains(searchController.text.toLowerCase()) ||
                                    data['email'].toString().toLowerCase().contains(searchController.text.toLowerCase()) ||
                                    data['uid'].toString().toLowerCase().contains(searchController.text.toLowerCase())) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    child: Column(
                                      children: [
                                        UserCustomCard(data: data),
                                        const SizedBox(height: 10),
                                        const Divider(thickness: 1, height: 1, indent: 20, endIndent: 20),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: const UserPhotoWidgetProfileScreen(),
            ),
          ),
        ],
      ),
    );
  }

  void dialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Do you want to update your profile image'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                String photoURL = await StorageServices().uploadImageToStorage('ProfilePics', _image!, false);
                FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({"photo": photoURL});
                ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text("Image Updated Succesfully")));
                Navigator.push(context!, MaterialPageRoute(builder: (builder) => CustomNavBar()));
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
