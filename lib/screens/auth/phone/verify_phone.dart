import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/auth/email_and_pass/sign_up_screen.dart';
import 'package:pinput/pinput.dart';
import '../../../themes/pin_theme.dart';
import '../../profile_creation/status/phonestatus/checkphonestatus.dart';

class VerifyPhone extends StatefulWidget {

  final String phone;
  // final String codeDigits;
  final String? verificationId;
  VerifyPhone({required this.verificationId,required this.phone,});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final TextEditingController controllerpin = TextEditingController();
  final FocusNode pinVerifyPhonePFocusNode = FocusNode();

  String? verificationCode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // verificationPhone();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/splash.png',
                height: 100,
                width: 200,
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                child: Text("verification: ${widget.phone}"),
              ),

              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                focusNode: pinVerifyPhonePFocusNode,
                controller: controllerpin,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                onCompleted: (pin) async {
                  try {
                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: controllerpin.text);

                    // Sign the user in (or link) with the credential
                    await FirebaseAuth.instance.signInWithCredential(credential).then((value){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen(isPhoneAuth: true,uid: value.user!.uid,phoneNumber: value.user!.phoneNumber,)));

                    });

                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Invalid Code"),
                      duration: Duration(seconds: 12),
                    ));
                  }
                },
              ),
              Container(
                child: const Text(
                  'Please enter the 6-digit code \n  sent to your number',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              // TextButton(
              //   child: Text("Continue"),
              //   onPressed: (() {
              //     addPhone();
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (builder) => ProfileDetail()));
              //   }),
              // )
            ],
          ),
        ),
      ),
    );
  }

  // void verificationPhone() async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: "${widget.codeDigits + widget.phone}",
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await FirebaseAuth.instance
  //             .signInWithCredential(credential)
  //             .then((value) {
  //           if (value.user != null) {
  //             Navigator.of(context).push(
  //               MaterialPageRoute(
  //                 builder: (builder) => CheckPhoneStatus(),
  //               ),
  //             );
  //             // Customdialog.closeDialog(context);
  //           } else {}
  //         });
  //       },
  //       verificationFailed: (FirebaseException e) {
  //         FocusScope.of(context).unfocus();
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text(e.message.toString()),
  //           duration: const Duration(seconds: 12),
  //         ));
  //       },
  //       codeSent: (String VID, int? resentToken) {
  //         setState(() {
  //           verificationCode = VID;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String VID) {
  //         setState(() {
  //           verificationCode = VID;
  //         });
  //       },
  //       timeout: const Duration(seconds: 50));
  // }

  // void addPhone() async {
  //   await DatabaseMethods().phone();
  //   // .then((value) => Customdialog.closeDialog(context));
  // }
}
