import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:join/screens/auth/email_and_pass/sign_up_screen.dart';
import 'package:join/screens/auth/phone/continue_phone.dart';
import 'package:join/screens/auth/widgets/auth_button.dart';

import '../../services/auth_service.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Position? _currentPosition;
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff160F29),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    scale: 100,
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/news.png",
                    ),
                  ),
                ),
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  "assets/small.png",
                  width: 130,
                  height: 60,
                ),
              ),
              LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.74,
                  margin: const EdgeInsets.only(top: 65),
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(
                        16,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Log In",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Color(0xff246A73), fontSize: 30, fontWeight: FontWeight.w700, fontFamily: "ProximaNova")),
                      const Text(
                        "Please select below option to continue.",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Color(0xff736F7F), fontSize: 16, fontFamily: "ProximaNova", fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 40),
                      AuthButton(
                        onPressed: () async {
                          EasyLoading.show(status: 'Signing in...');
                          await _getCurrentPosition();
                          await AuthServices().signInWithGoogle(context, _currentPosition);

                          /*    await AuthServices().signInWithGoogle().then((value) =>
                              {Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const CheckStatus()))});*/
                          // EasyLoading.showError("Will Implement Soon");
                        },
                        title: "Log In With Google",
                        image: "assets/googl.png",
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
                        },
                        title: "Log In With Email",
                        image: "assets/email.png",
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        onPressed: () async {
                          // EasyLoading.showError("Will Implement Soon");
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => const ContinuePhone()));
                        },
                        title: "Log In With Phone Number",
                        image: "assets/imgGgphone.png",
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff246A73).withOpacity(.10),
                        ),
                        margin: const EdgeInsets.only(left: 10, top: 24, right: 10),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "By registering or creating an account, you agree to our Terms of Use. Read our Privacy Policy to learn more about how we process your data.",
                            style:
                                TextStyle(fontSize: 14, color: Color(0xff246A73), fontWeight: FontWeight.w400, fontFamily: "ProximaNova"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
