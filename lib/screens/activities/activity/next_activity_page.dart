import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:join/widgets/dialog.dart';
import 'package:join/widgets/secondry_button.dart';

import '../../../themes/app_colors.dart';
import '../../custom_navbar/custom_navbar.dart';
import 'map_screen_activity.dart';

class NextActivityPage extends StatefulWidget {
  final String? title;
  final String? description;
  final dynamic image;
  final String? cate;
  final bool? isActivityPrivate;

  const NextActivityPage(
      {super.key, required this.description, required this.image, required this.cate, required this.title, this.isActivityPrivate});

  @override
  State<NextActivityPage> createState() => _NextActivityPageState();
}

class _NextActivityPageState extends State<NextActivityPage> {
  TextEditingController createDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    // startTimeController.text = "11: AM";
    // endTimeController.text = "1:PM";
    // createDateController.text = "20 July,2023";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 1, top: 12),
            child: Row(children: [
              Image.asset(
                "assets/select.png",
                height: 18,
                width: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Select Date",
                style: TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: TextFormField(
              onTap: () {
                _selectDate(context);
              },
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/Chevon Left.png",
                    height: 6,
                    width: 6,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                disabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                hintText: "12/04/2023",
                helperStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
              controller: createDateController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Row(children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 1, top: 12),
                    child: Row(children: [
                      Image.asset(
                        "assets/clock.png",
                        height: 18,
                        width: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Start Time",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 161,
                    height: 46,
                    child: TextField(
                      onTap: () {
                        _startTime(context);
                      },
                      controller: startTimeController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 20, left: 10),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/Chevon Left.png",
                            height: 6,
                            width: 6,
                          ),
                        ),
                        hintText: "10 : 00 AM",
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                        disabledBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                        enabledBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 1, top: 12),
                    child: Row(children: [
                      Image.asset(
                        "assets/clock.png",
                        height: 18,
                        width: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "End Time",
                        style: TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff736F7F)),
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 161,
                    height: 46,
                    child: TextField(
                      onTap: () {
                        _endTime(context);
                      },
                      controller: endTimeController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 20, left: 10),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/Chevon Left.png",
                            height: 6,
                            width: 6,
                          ),
                        ),
                        hintText: "10 : 00 AM",
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                        disabledBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                        enabledBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              )),
            ]),
          ),
          const SizedBox(height: 20),
          SecondaryButton(
            onTap: () {
              if (createDateController.text.isEmpty) {
                EasyLoading.showError("Create Date Must Be Filled");
              } else if (startTimeController.text.isEmpty) {
                EasyLoading.showError("Start Time Must Be Filled");
              } else if (endTimeController.text.isEmpty) {
                EasyLoading.showError("End Time Must Be Filled");
              } else {
                createProfile();
              }
            },
            title: "Ready To Share",
          ),
          const SizedBox(height: 15),
          Text(
            "Commercial hosts click here",
            style: TextStyle(
                color: AppColors.mainColor,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.mainColor),
          ),
        ],
      ),
    );
  }

  _startTime(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    startTimeController.text = time!.format(context); // to here
  }

  _endTime(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    endTimeController.text = time!.format(context); // to here
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
      createDateController
        ..text = DateFormat.yMMMMd('en_US').format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(offset: createDateController.text.length, affinity: TextAffinity.upstream));
    }
  }

  void createProfile() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialogs(
          title: "Are you sure to continue ?",
          fl: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => MapScreenActivity(
                        category: widget.cate,
                        title: widget.title,
                        description: widget.description,
                        image: widget.image,
                        startTime: startTimeController.text,
                        endTime: endTimeController.text,
                        day: createDateController.text,
                        isActivityPrivate: widget.isActivityPrivate!,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CustomNavBar()));
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
