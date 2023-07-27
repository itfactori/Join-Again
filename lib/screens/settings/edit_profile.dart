import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join/themes/app_colors.dart';
import 'package:join/widgets/image_uploading_widget.dart';

import '../../widgets/secondry_button.dart';
import '../custom_navbar/custom_navbar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateofBrithController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? gender;
  Uint8List? _image;
  String image = "";
  final List workoutButtons = ["Football", "Golf", "Yoga", "Cricket", "Football", "Hockey"];
  final List activityButtons = ["Networking", "Study Groups", "Languages", "Cricket", "Football", "Hockey"];
  final List socialButtons = ["Networking", "Study Groups", "Languages", "Cricket", "Football", "Hockey"];
  final List cultureButtons = ["Museum", "Exbition", "Languages", "Cricket", "Football", "Hockey"];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.clear();
    dateofBrithController.clear();
    phoneController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(fontFamily: "ProximaNova", fontSize: 20, color: Color(0xff160F29), fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              var document = snapshot.data;
              nameController.text = document['name'];
              dateofBrithController.text = document['dob'].toDate().toString();
              gender = document['gender'];
              image = document['photo'];

              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Stack(
                  children: [
                    Image.asset(
                      "assets/Group 1000001549.png",
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    Card(
                      margin: EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              // onTap: () => selectImage(),
                              child: _image != null
                                  ? Center(
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            padding: EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0x20FF7E87),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: 3,
                                                    color: Color(0xFFFF7E87),
                                                  ),
                                                  image: DecorationImage(image: MemoryImage(_image!))),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 5,
                                              right: 5,
                                              child: Image.asset(
                                                "assets/cmr.png",
                                                height: 25,
                                                width: 25,
                                                fit: BoxFit.cover,
                                              )),
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            padding: EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0x20FF7E87),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    width: 3,
                                                    color: Color(0xFFFF7E87),
                                                  ),
                                                  image: DecorationImage(image: NetworkImage(image))),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 5,
                                              right: 5,
                                              child: Image.asset(
                                                "assets/cmr.png",
                                                height: 25,
                                                width: 25,
                                                fit: BoxFit.cover,
                                              )),
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Name",
                              style:
                                  TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              height: 46,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBF1F3),
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                              ),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10),
                                  hintText: "Fawad Kaleem",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Choose your Date of Birth",
                              style:
                                  TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              height: 46,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                color: Color(0xFFEBF1F3),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: dateofBrithController,
                                decoration: InputDecoration(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/card.png",
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10),
                                  hintText: "21/05/2023",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEBF1F3),
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    child: RadioListTile(
                                      contentPadding: EdgeInsets.zero,
                                    //  fillColor: MaterialStateProperty.all(Color(0xFFFF7E87)),
                                      title: Text("Male"),
                                      value: "Male",
                                      groupValue: gender,
                                      activeColor: AppColors.mainColor,
                                      onChanged: (v) {
                                        setState(() {
                                          gender = v;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEBF1F3),
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                    ),
                                    child: RadioListTile(
                                      contentPadding: EdgeInsets.zero,
                                   //   fillColor: MaterialStateProperty.all(Color(0xFFFF7E87)),
                                      title: Text(
                                        "Female",
                                      ),
                                      value: "Female",
                                      activeColor: AppColors.mainColor,
                                      groupValue: gender,
                                      onChanged: (v) {
                                        setState(() {
                                          gender = v;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Phone Number",
                              style:
                                  TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              height: 46,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                color: Color(0xFFEBF1F3),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: phoneController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 10, left: 10),
                                  hintText: "Add Phone Number",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffEBF1F3))),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Interest",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "ProximaNova",
                            fontSize: 20,
                            color: Color.fromARGB(255, 2, 0, 7),
                          )),
                      const Text("Choose up to 5 interests per category",
                          style: TextStyle(
                            fontFamily: "ProximaNova",
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Color(0xff736F7F),
                          )),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/s.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Workout and Athletics",
                                    style: TextStyle(
                                        fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "2/5",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xffECF2F3),
                                thickness: 2,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                    workoutButtons.length,
                                    (index) => TextCard(
                                          title: workoutButtons[index],
                                        )),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/flower.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Activities for intellectual",
                                    style: TextStyle(
                                        fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "2/5",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xffECF2F3),
                                thickness: 2,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                    activityButtons.length,
                                    (index) => TextCard(
                                          title: activityButtons[index],
                                        )),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Image.asset(
                                    "assets/soc.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Social & hangout",
                                    style: TextStyle(
                                        fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "2/5",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xffECF2F3),
                                thickness: 2,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                    socialButtons.length,
                                    (index) => TextCard(
                                          title: socialButtons[index],
                                        )),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/as.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Culture and adventure",
                                    style: TextStyle(
                                        fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Colors.black),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "2/5",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xffECF2F3),
                                thickness: 2,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                    cultureButtons.length,
                                    (index) => TextCard(
                                          title: cultureButtons[index],
                                        )),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      SecondaryButton(
                        onTap: () async {
                          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                            "name": nameController.text,
                            "dob": dateofBrithController.text,
                            "gender": gender,
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => CustomNavBar(),
                            ),
                          );
                        },
                        title: 'Save',
                      ),
                    ],
                  ),
                )
              ]);
            }),
      ),
    );
  }

  selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      _image = ui;
    });
  }
}

class TextCard extends StatelessWidget {
  final String? title;

  const TextCard({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          title!,
          style: TextStyle(color: Color(0xff246A73), fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
      width: 80,
      height: 26,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Color(0xff368F8B).withOpacity(.10)),
    );
  }
}
