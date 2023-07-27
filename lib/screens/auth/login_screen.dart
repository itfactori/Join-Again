import 'package:flutter/material.dart';
import 'package:join/screens/auth/phone/continue_phone.dart';
import 'package:join/screens/auth/widgets/auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoggedIn = false;

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
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
                        onPressed: () async {},
                        title: "Log In With Google",
                        image: "assets/googl.png",
                      ),
                      const SizedBox(height: 20),
                      //todo Implement Facebook Auth From Here

                      AuthButton(
                        onPressed: () async {
                          // initiateFacebookLogin();
                        },
                        title: "Log In With Facebook",
                        image: "assets/l.png",
                      ),
                      const SizedBox(height: 20),
                      AuthButton(
                        onPressed: () async {
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
