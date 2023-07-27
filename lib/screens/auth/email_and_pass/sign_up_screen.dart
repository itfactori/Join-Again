import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join/screens/auth/email_and_pass/login_screen.dart';
import 'package:join/screens/auth/widgets/gender_selecting_widget.dart';
import 'package:join/services/auth_service.dart';

import '../../../themes/app_colors.dart';
import '../../../widgets/custom_input.dart';
import '../../../widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  final bool? isPhoneAuth;
  final String? uid;
  final String? phoneNumber;
  const SignUpScreen({this.isPhoneAuth = false, this.uid, this.phoneNumber, Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  File? selectedImage;
  final int _groupVal = 0;
  DateTime? selectedData;

  String? _currentAddress;

  @override
  initState() {
    if (widget.isPhoneAuth!) {
      phoneController.text = widget.phoneNumber!;
    }

    super.initState();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Center(
                child: Image.asset(
                  "assets/splash.png",
                  height: 60,
                  width: 200,
                ),
              ),
              const SizedBox(height: 20),
              selectedImage == null
                  ? Center(
                      child: CircleAvatar(
                        backgroundColor: AppColors.mainColor,
                        radius: 55,
                        child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return SizedBox(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              getUserImage(ImageSource.camera);
                                            },
                                            leading: const Icon(Icons.camera_alt),
                                            title: const Text("From Camera"),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.pop(context);
                                              getUserImage(ImageSource.gallery);
                                            },
                                            leading: const Icon(Icons.photo),
                                            title: const Text("From Gallery"),
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: const Icon(Icons.image, color: Colors.white)),
                      ),
                    )
                  : Center(
                      child: CircleAvatar(
                      radius: 55,
                      backgroundImage: FileImage(File(selectedImage!.path)),
                    )),
              const SizedBox(height: 15),
              CustomInput(
                controller: nameController,
                hintText: "Full Name",
                prefixIcon: Icons.person_2,
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: emailController,
                hintText: "E-mail",
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 10),
              CustomInput(
                keyboardType: TextInputType.number,
                controller: phoneController,
                hintText: "Phone",
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 10),
              CustomInput(
                onPressed: () {
                  selectDateOfBirth();
                },
                readOnly: true,
                controller: TextEditingController(),
                hintText: selectedData == null ? "Date Of Birth" : "${selectedData!.day} - ${selectedData!.month} -  ${selectedData!.year}",
                prefixIcon: Icons.calendar_month,
              ),
              const SizedBox(height: 10),
              CustomInput(
                controller: passwordController,
                hintText: "Password",
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 10),
              GenderSelectingWidget(groupVal: _groupVal),
              const SizedBox(height: 20),
              PrimaryButton(
                title: "Sign Up",
                onTap: () async {
                  await _getCurrentPosition();
                  await signUp();
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
                },
                child: const Center(
                  child: Text(
                    "Already Have an Account? Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  getUserImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      selectedImage = File(pickedFile!.path);
    });
  }

  selectDateOfBirth() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    setState(() {
      selectedData = pickedDate;
    });
  }

  signUp() {
    if (selectedImage == null) {
      EasyLoading.showError("Image is Empty");
    } else if (nameController.text.isEmpty) {
      EasyLoading.showError("Full Name is Empty");
    } else if (emailController.text.isEmpty) {
      EasyLoading.showError("Email is Empty");
    } else if (phoneController.text.isEmpty) {
      EasyLoading.showError("Phone Number is Empty");
    } else if (selectedData == null) {
      EasyLoading.showError("Date of Birth is Empty");
    } else if (passwordController.text.isEmpty) {
      EasyLoading.showError("Password is Empty");
    } else {
      if (widget.isPhoneAuth!) {
        AuthServices.signUp(
          context: context,
          fullName: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          dateOfBirth: selectedData,
          password: passwordController.text,
          gender: _groupVal == 0
              ? "Male"
              : _groupVal == 1
                  ? "Female"
                  : "Other",
          position: _currentPosition,
          selectedImage: selectedImage!,
        );
      } else {
        AuthServices.signUp(
          context: context,
          fullName: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          dateOfBirth: selectedData,
          password: passwordController.text,
          gender: _groupVal == 0 ? "Male" : "Female",
          position: _currentPosition,
          selectedImage: selectedImage!,
        );
      }
    }
  }
}
