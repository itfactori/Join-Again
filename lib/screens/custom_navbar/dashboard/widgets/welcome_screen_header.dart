import 'package:flutter/material.dart';
import 'package:join/screens/activities/activities_panel/physical_activity.dart';
import 'package:join/screens/activities/activities_panel/relaxation_activity.dart';
import 'package:join/screens/activities/activities_panel/sip_together_activity.dart';

import '../../../../utils/lists.dart';
import '../../../activities/activities_panel/creative_activity.dart';
import '../../../activities/activities_panel/interlectual_activity.dart';

class WelcomeScreenHorizontalHeader extends StatelessWidget {
  const WelcomeScreenHorizontalHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 100),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(welcomeScreenHeaderImages.length, (index) {
            return InkWell(
              onTap: () {
                if (index == 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const Physical()));
                } else if (index == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const Physical(title: "Interllectual Activities",)));
                } else if (index == 2) {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const Physical(title: "Sip Together",)));
                } else if (index == 3) {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const Physical(title: "Creative Activities",)));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const Physical(title: "Relaxation and Leisure Activities")));
                }
              },
              child: Column(
                children: [
                  Image.asset(welcomeScreenHeaderImages[index], width: 50, height: 50, fit: BoxFit.cover),
                  const SizedBox(height: 10),
                  Text(
                    welcomeScreenHeaderTitles[index],
                    style: TextStyle(
                        color: const Color(0xff160F29).withOpacity(.8),
                        fontSize: 10,
                        fontFamily: "ProximaNova",
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            );
          }),
        ));
  }
}
