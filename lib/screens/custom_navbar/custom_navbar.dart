import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/custom_navbar/dashboard/message_screens/message_screen.dart';
import 'package:join/services/notification_services.dart';

import '../../utils/globals.dart';
import '../activities/create_activity.dart';
import 'dashboard/my_profile.dart';
import 'dashboard/welcome_page.dart';
import 'dashboard/your_calender.dart';

class CustomNavBar extends StatefulWidget {
  // MainScreen ({Key key}) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  NotificationServices notificationServices = NotificationServices();

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;

  int currentTab = 0;
  final List<Widget> screens = [
    const WelComePage(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const WelComePage();

  @override
  void initState() {
    notificationServices.getNotificationPermission();
    notificationServices.getDeviceToken();
    notificationServices.initNotification(context);
    userID = FirebaseAuth.instance.currentUser!.uid ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: const StadiumBorder(),
          backgroundColor: const Color(0xffFF7E87),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (builder) => CreateActivity()));
            _fabAnimationController.reset();
            _borderRadiusAnimationController.reset();
            _borderRadiusAnimationController.forward();
            _fabAnimationController.forward();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          notchMargin: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Welcome
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = const WelComePage();
                    currentTab = 0;
                  });
                },
                child: Image.asset(
                  currentTab == 0 ? 'assets/locationcolor.png' : 'assets/location.png',
                  height: 20,
                ),
              ),

              //Calender
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = const YourCalender();

                    currentTab = 1;
                  });
                },
                child: Image.asset(
                  currentTab == 1 ? 'assets/colors.png' : 'assets/calender.png',
                  height: 20,
                ),
              ),
              SizedBox(),
              //Chat
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = const MessageScreen();

                    currentTab = 2;
                  });
                },
                child: Image.asset(
                  currentTab == 2 ? 'assets/chats.png' : 'assets/chat1.png',
                  height: 20,
                ),
              ),
              //Profile
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() {
                    currentScreen = const MyProfile();
                    currentTab = 3;
                  });
                },
                child: Image.asset(
                  currentTab == 3 ? 'assets/profilecolor.png' : 'assets/person.png',
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
