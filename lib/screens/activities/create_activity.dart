import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join/screens/activities/widgets/custom_switch_tile.dart';
import 'package:join/widgets/dialog.dart';
import 'package:join/widgets/image_uploading_widget.dart';
import 'package:join/widgets/primary_button.dart';
import 'package:join/widgets/snakbar.dart';

import '../../themes/app_colors.dart';
import 'activity/next_activity_page.dart';

class CreateActivity extends StatefulWidget {
  @override
  State<CreateActivity> createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  TextEditingController createTitleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<String> dropdownItemList = [
    "Physical Activities",
    "Interllectual Activities",
    "Sip Together",
    "Creative Activities",
    "Relaxation and Leisure Activities"
  ];

  String art = "Physical Activities";

  TextEditingController descriptiontextController = TextEditingController();

  TextEditingController searchController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController createDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();

  bool switchValue1 = true;
  bool switchValue2 = true;
  bool switchValue3 = true;
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Create Activity",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w700, fontSize: 17, color: Color(0xff160F29)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/Group 6870.png",
                    height: 18,
                    width: 18,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Add Title Name ",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 10),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                    disabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: AppColors.mainColor)),
                    fillColor: Colors.white,
                    border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xff368F8B))),
                    hintText: "Wes Yabinlatelee",
                    helperStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff736F7F),
                    ),
                  ),
                  focusNode: FocusNode(),
                  controller: createTitleController,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Image.asset(
                    "assets/cat.png",
                    height: 18,
                    width: 18,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Choose Category",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.white,
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide.none,
                  )),
                  borderRadius: BorderRadius.circular(6),
                  value: art,
                  focusColor: Colors.black,
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
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Image.asset(
                    "assets/menus.png",
                    height: 18,
                    width: 18,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 107,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.red,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                    disabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                    enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 15, top: 40),
                    border: InputBorder.none,
                    hintText: "Add description",
                  ),
                  focusNode: FocusNode(),
                  controller: descriptiontextController,
                  maxLines: 6,
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                //todo
                onTap: () => selectImage(),
                child: _image != null
                    ? CircleAvatar(radius: 59, backgroundImage: MemoryImage(_image!))
                    : Image.asset(
                        "assets/Group 6860.png",
                        width: 343,
                        height: 104,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 16,
                  right: 20,
                  bottom: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    CustomSwitchTile(
                      title: 'Private / On Request',
                      subTitle: "Activate this Button to be able \nto accept or reject new users\n to your activity",
                      child: CupertinoSwitch(
                        activeColor: const Color(0xffFF6F79),
                        value: switchValue1,
                        onChanged: (bool? value) {
                          setState(() {
                            switchValue1 = value!;
                          });
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 19,
                      ),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomSwitchTile(
                      title: 'Notifications',
                      subTitle: "Get notified when someone \nis joining your activity.",
                      child: CupertinoSwitch(
                        activeColor: const Color(0xffFF6F79),
                        value: switchValue2,
                        onChanged: (bool? value) {
                          setState(() {
                            switchValue2 = value!;
                          });
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 19,
                      ),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomSwitchTile(
                      title: 'Repeat',
                      subTitle: "Toggle if this is activity shall\nbe repeated.",
                      child: CupertinoSwitch(
                        activeColor: const Color(0xffFF6F79),
                        value: switchValue3,
                        onChanged: (bool? value) {
                          setState(() {
                            switchValue3 = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.all(15),
                child: PrimaryButton(
                  onTap: dialog,
                  title: 'Next',
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      _image = ui;
    });
  }

  void dialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialogs(
          title: "Do you want to continue ?",
          fl: [
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                if (createTitleController.text.isEmpty) {
                  showSnakBar("Title is Required", context);
                  Navigator.pop(context);
                } else if (descriptiontextController.text.isEmpty) {
                  showSnakBar("Description is Required", context);

                  Navigator.pop(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => NextActivityPage(
                        title: createTitleController.text,
                        image: _image,
                        description: descriptiontextController.text,
                        cate: art,
                        isActivityPrivate: switchValue1,
                      ),
                    ),
                  );
                }
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ))
          ],
        );
      },
    );
  }
}
