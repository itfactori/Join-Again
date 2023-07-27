import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:join/models/userModel.dart';
import 'package:join/screens/auth/email_and_pass/login_screen.dart';
import 'package:join/screens/custom_navbar/custom_navbar.dart';
import 'package:join/themes/app_colors.dart';

import '../screens/auth/email_and_pass/sign_up_screen.dart';
import '../screens/auth/first_screen.dart';
import '../screens/auth/phone/verify_phone.dart';
import '../widgets/dialog.dart';
import '../widgets/snakbar.dart';

//todo user current Location lat lang to new field in firebase user collection with icon userIcon
class AuthServices {


  signInWithGoogle(BuildContext? context,Position? position) async {
    try {
      print("I am signIn with google");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

     UserModel user=UserModel(
         dob: Timestamp.fromDate(DateTime.now()),
         email: userCredential.user!.email!,
         friends: [],
         gender: 'male',
         name: userCredential.user!.displayName!,
         phone: userCredential.user!.phoneNumber!=null?userCredential.user!.phoneNumber!:'123456',
         photo: '',
         positionLat: position!.latitude,
         positionLong: position.longitude,
         uid: userCredential.user!.uid,
         isPublicLocation: true
     );

     DocumentSnapshot snapshot=await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
     if(snapshot.exists){
       Navigator.of(context!).push(MaterialPageRoute(builder: (_) => CustomNavBar()));
     }else{
       FirebaseFirestore.instance.collection('users').doc(user.uid).set(user.toMap()).then((value){
         Navigator.of(context!).push(MaterialPageRoute(builder: (_) => CustomNavBar()));
       });
     }

    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  // Future<UserCredential> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
  //
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

//OTP Number Add
  Future<String> emailGoogle() async {
    String res = 'Some error occured';
    try {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(
        {
          "email": FirebaseAuth.instance.currentUser!.email,
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "friends": [],
          "isPublicLocation": true,
        },
      );
      res = 'success';
      debugPrint(res);
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Future<String> phone() async {
  //   String res = 'Some error occured';
  //   try {
  //     //Add User to the database with modal
  //
  //     await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set(
  //       {
  //         "phone": FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
  //         "uid": FirebaseAuth.instance.currentUser!.uid,
  //         "friends": [],
  //       },
  //     );
  //     res = 'success';
  //     debugPrint(res);
  //   } catch (e) {
  //     res = e.toString();
  //   }
  //   return res;
  // }

  static verifyPhoneNumber(
      String phoneNumber, BuildContext context) async {
    try {
      EasyLoading.show(status: "Please wait");
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential)  {
          },

          verificationFailed: (e) {
            EasyLoading.showError(e.code.toString());
            EasyLoading.dismiss();
          },
          codeSent: (String verificationId, int? token) {
            EasyLoading.dismiss();
            Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPhone(verificationId: verificationId,phone: phoneNumber,)));
            // navigateToPage(
            //     context: context,
            //     pageName: registerverify(
            //       verificationId: verificationId,
            //       phone: phoneNumber,
            //     ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {

          });
    }
    on FirebaseAuthException catch(e){
      EasyLoading.showError(e.code);
      EasyLoading.dismiss();
    }
  }


  static signUp({
    BuildContext? context,
    String? fullName,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? password,
    String? gender,
    Position? position,
    File? selectedImage,
    String? uid,
  }) async {
    try {

      EasyLoading.show(status: "Please Wait");

      if(uid!=null){
        FirebaseStorage fs = FirebaseStorage.instance;
        Reference ref = fs.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(File(selectedImage!.path));
        String image = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('user').doc(uid).set({
          "uid": uid,
          "photo": image,
          "phone": phone,
          "name": fullName,
          "gender": gender,
          "friends": [],
          "email": email,
          "positionLat": position!.latitude,
          "positionLong": position.longitude,
          "dob": dateOfBirth,
          "isPublicLocation": true,
        });
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Your Account is Created Successfully Now Login With your Email And Password");
        Navigator.of(context!).push(MaterialPageRoute(builder: (_) => CustomNavBar()));
      }else{
        FirebaseStorage fs = FirebaseStorage.instance;
        Reference ref = fs.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(File(selectedImage!.path));
        String image = await ref.getDownloadURL();
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "photo": image,
          "phone": phone,
          "name": fullName,
          "gender": gender,
          "friends": [],
          "email": email,
          "positionLat": position!.latitude,
          "positionLong": position.longitude,
          "dob": dateOfBirth,
          "isPublicLocation": true
        });
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Your Account is Created Successfully Now Login With your Email And Password");
        Navigator.of(context!).push(MaterialPageRoute(builder: (_) => const LoginScreen()));

      }

      } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  static signIn({BuildContext? context, String? email, String? password}) async {
    try {
      EasyLoading.show(status: "Please Wait");
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
      EasyLoading.dismiss();
      Navigator.of(context!).push(MaterialPageRoute(builder: (_) => CustomNavBar()));
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      EasyLoading.dismiss();
    }
  }

  Future<void> signOut(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(

          title: const Text("Logout",style: TextStyle(
            color: Color(0xFF000000),
          ),),
          content: const Text("Are you sure you want to logout ?",style: TextStyle(
            color: Color(0xFF736F7F),
          ),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.black),
              )),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    showSnakBar("Logout Successfully", context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const FirstScreen()));
                  });
                },
                child:  Text(
                  "Yes",
                  style: TextStyle(color: AppColors.mainColor),
                )),

          ],
        );
      },
    );
  }

  Future<void> deleteAccount(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Delete Account",style: TextStyle(
            color: Color(0xFF000000),
          ),),
          content: const Text("Are you sure you want to  delete account?",style: TextStyle(
            color: Color(0xFF736F7F),
          ),),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No")),
            TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).delete().then((value) {
                    showSnakBar("Account Deleted Successfully", context);

                    FirebaseAuth.instance.currentUser!.delete();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const FirstScreen()));
                  });
                },
                child:  Text(
                  "Yes",
                  style: TextStyle(color: AppColors.mainColor),
                )),
          ],
        );
      },
    );
  }
}
