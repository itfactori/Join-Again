import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join/screens/profile_creation/status/phonestatus/user_phone_dob.dart';
import 'package:join/services/storage_services.dart';
import 'package:join/widgets/custom_input.dart';
import 'package:join/widgets/image_uploading_widget.dart';
import 'package:join/widgets/snakbar.dart';

import '../../../../widgets/primary_button.dart';

class UserPhonePhotoEmail extends StatefulWidget {
  const UserPhonePhotoEmail({super.key});

  @override
  State<UserPhonePhotoEmail> createState() => _UserPhonePhotoEmailState();
}

class _UserPhonePhotoEmailState extends State<UserPhonePhotoEmail> {
  Uint8List? _image;
  TextEditingController nameController = TextEditingController();
  bool _isLoading = false;

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/splash.png",
              height: 150,
              width: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () => selectImage(),
              child: Container(
                width: 374,
                height: 157,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xffD2D2D2),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image != null
                        ? CircleAvatar(radius: 59, backgroundImage: MemoryImage(_image!))
                        : Image.asset(
                            "assets/phone.png",
                            width: 51,
                            height: 39,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Upload Profile Photo',
                          style: TextStyle(
                            fontFamily: 'ProximaNova',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontFamily: 'ProximaNova',
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomInput(
              prefixIcon: Icons.person_2,
              controller: nameController,
              hintText: "Enter Your Name",
            ),
            SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    //todo
                    onTap: createProfile,
                    title: "Next",
                  ),
          ],
        ),
      ),
    );
  }

  selectImage() async {
    Uint8List ui = await pickImage(ImageSource.gallery);
    setState(() {
      _image = ui;
    });
  }

  void createProfile() async {
    if (nameController.text.isEmpty || _image!.isEmpty) {
      showSnakBar("All Fields are Required", context);
    } else {
      setState(() {
        _isLoading = true;
      });
      await _getCurrentPosition();
      String photoURL = await StorageServices().uploadImageToStorage('ProfilePics', _image!, false);
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "name": nameController.text,
        "photo": photoURL,
        "positionLat": _currentPosition!.latitude,
        "positionLong": _currentPosition!.longitude
      });
      setState(() {
        _isLoading = false;
      });
      showSnakBar("Name and Photo Added", context);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const UserPhoneDob()));
    }
  }
}
