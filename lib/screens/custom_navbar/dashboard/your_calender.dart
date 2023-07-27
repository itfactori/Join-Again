import 'package:flutter/material.dart';
import 'package:join/screens/calender/widgets/on_going_activity.dart';

import '../../calender/all_ongoing_activities.dart';

class YourCalender extends StatefulWidget {
  const YourCalender({super.key});

  @override
  State<YourCalender> createState() => _YourCalenderState();
}

class _YourCalenderState extends State<YourCalender> {
  int currentIndex = 0;
  final List<String> tabTitle = ["Own", "Going"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Your Calender",
            style: TextStyle(fontFamily: "ProximaNova", fontSize: 20, color: Color(0xff160F29), fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 45,
                padding: const EdgeInsets.all(2),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0x22736F7F)), color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    tabTitle.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: currentIndex == index ? const Color(0xFF246A73) : Colors.transparent,
                          ),
                          child: Text(
                            tabTitle[index],
                            style: TextStyle(color: currentIndex == index ? Colors.white : const Color(0xFF736F7F)),
                          )),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: currentIndex == 0 ? const OnGoingActivity() : const AllOnGoingActivities(),
              ),
            ],
          ),
        ));
  }
}
