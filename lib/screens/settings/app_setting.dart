import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/settings/edit_profile.dart';
import 'package:join/screens/settings/widgets/custom_list_tile.dart';
import 'package:join/screens/settings/widgets/social_connection_card.dart';
import 'package:join/services/auth_service.dart';

import '../../widgets/secondry_button.dart';
import '../events/event_tab.dart';

class AppSetting extends StatefulWidget {
  const AppSetting({super.key});

  @override
  State<AppSetting> createState() => _AppSettingState();
}

class _AppSettingState extends State<AppSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffedf3f4),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(fontFamily: "ProximaNova", fontSize: 20, color: Color(0xff160F29), fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  var document = snapshot.data;
                  return SizedBox(
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/Group 1000001549.png",
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Card(
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          color: Colors.white,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Language",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: "ProximaNova", fontSize: 16, color: Color(0xff736F7F), fontWeight: FontWeight.w400),
                                ),
                                const SocialConnectionCard(
                                  isCircularShapeReq: true,
                                  title: "Language",
                                  image: "assets/eng.png",
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Link Accounts",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: "ProximaNova", fontSize: 16, color: Color(0xff736F7F), fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 5),
                                SocialConnectionCard(
                                  isSubTitleReq: true,
                                  title: "Linkded",
                                  image: "assets/circle-flags_uk.png",
                                  color: const Color(0xff246A73),
                                  subTitle: document['email'],
                                ),
                                const SizedBox(height: 10),
                                const SocialConnectionCard(
                                  title: "Tap Here to Connect",
                                  image: "assets/face.png",
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 10),
                                const SocialConnectionCard(
                                  title: "Tap Here to Connect",
                                  image: "assets/call.png",
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Text(
                "Other",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(color: Color(0xff160F29), fontSize: 16, fontFamily: "ProximaNova", fontWeight: FontWeight.w600),
              ),
            ),
            CustomListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const EditProfile()));
              },
              title: "Edit Profile",
            ),
            const SizedBox(height: 10),
            CustomListTile(
              onTap: () {},
              title: "FAQ",
            ),
            const SizedBox(height: 10),
            CustomListTile(
              onTap: () {},
              title: "Report a problem",
            ),
            const SizedBox(height: 10),
            CustomListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => const EventRequestTab()));
              },
              title: "Request For Activities",
            ),
            const SizedBox(height: 10),
            CustomListTile(
              onTap: () {},
              title: "Join the partner ship program",
            ),
            const SizedBox(height: 10),
            CustomListTile(
              onTap: () {},
              title: "Join for the bussiness",
            ),
            const SizedBox(height: 10),
            CustomListTile(
              isSuffixIconRequired: false,
              onTap: () async {
                await AuthServices().deleteAccount(context);
              },
              title: "Delete Account",
            ),
            const SizedBox(height: 20),
            SecondaryButton(
              onTap: () async {
                await AuthServices().signOut(context);
              },
              title: "Log Out",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
