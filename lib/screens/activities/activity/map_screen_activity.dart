import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:join/widgets/primary_button.dart';
import 'package:join/widgets/snakbar.dart';
import 'package:uuid/uuid.dart';

import '../../../services/storage_services.dart';
import '../../custom_navbar/custom_navbar.dart';
import 'geo_service.dart';

class MapScreenActivity extends StatefulWidget {
  final dynamic startTime;
  final dynamic endTime;
  final String? title;
  final String? description;
  final String? category;
  final dynamic day;
  final dynamic image;
  final bool isActivityPrivate;
  const MapScreenActivity(
      {super.key,
      required this.category,
      required this.day,
      required this.title,
      required this.description,
      required this.endTime,
      required this.startTime,
      required this.image,
      required this.isActivityPrivate});

  @override
  State<MapScreenActivity> createState() => _MapScreenActivityState();
}

class _MapScreenActivityState extends State<MapScreenActivity> {
  final TextEditingController _locationController = TextEditingController();
  String googleApikey = "AIzaSyBffT8plN_Vdcd308KgmzIfGVQN6q-CkAo";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  bool _isLoading = false;
  bool loading = false;
  List latlong = [];
  String location = 'Please move map to A specific location.';
  var eventId = Uuid().v4();
  @override
  void initState() {
    getLatLong();
    _locationController.text = "Select Activity Location From Map";
    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LatLng startLocation = _isLoading ? const LatLng(25.276987, 55.296249) : LatLng(latlong[0], latlong[1]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 6,
        title: const Text(
          "Set Location",
          style: TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w700, fontSize: 17, color: Color(0xff160F29)),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SizedBox(
              height: 800,
              child: Stack(
                children: [
                  GoogleMap(
                    zoomGesturesEnabled: true, //enable Zoom in, out on map
                    initialCameraPosition: CameraPosition(
                      target: startLocation,
                      zoom: 14.0,
                    ),
                    mapType: MapType.normal, //map type
                    onMapCreated: (controller) {
                      setState(() {
                        mapController = controller;
                      });
                    },
                    onCameraMove: (CameraPosition cameraPositiona) {
                      cameraPosition = cameraPositiona; //when map is dragging
                    },
                    onCameraIdle: () async {
                      List<Placemark> addresses =
                          await placemarkFromCoordinates(cameraPosition!.target.latitude, cameraPosition!.target.longitude);

                      var first = addresses.first;
                      print("${first.name} : ${first..administrativeArea}");

                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(cameraPosition!.target.latitude, cameraPosition!.target.longitude);
                      Placemark place = placemarks[0];
                      location = '${place.street},${place.subLocality},${place.locality},${place.thoroughfare},';

                      setState(() {
                        _locationController.text = location;
                      });
                    },
                  ),
                  Center(
                    child: Icon(Icons.location_on),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 60, left: 20, right: 20),
                      height: 174,
                      width: 343,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.1), //(x,y)
                          blurRadius: 0.5,
                        ),
                      ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            child: const Text(
                              "Location",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Color(0xff736F7F), fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: const Color(0xffE5E5EA),
                                ),
                              ),
                              margin: const EdgeInsets.only(left: 15, top: 10, right: 10),
                              child: TextField(
                                onTap: () async {
                                  var place = await PlacesAutocomplete.show(
                                      context: context,
                                      apiKey: googleApikey,
                                      mode: Mode.overlay,
                                      types: [],
                                      strictbounds: false,
                                      onError: (err) {
                                        print(err);
                                      });

                                  if (place != null) {
                                    setState(() {
                                      location = place.description.toString();
                                      _locationController.text = location;
                                    });
                                    final plist = GoogleMapsPlaces(
                                      apiKey: googleApikey,
                                      apiHeaders: await GoogleApiHeaders().getHeaders(),
                                      //from google_api_headers package
                                    );
                                    String placeid = place.placeId ?? "0";
                                    final detail = await plist.getDetailsByPlaceId(placeid);
                                    final geometry = detail.result.geometry!;
                                    final lat = geometry.location.lat;
                                    final lang = geometry.location.lng;
                                    var newlatlang = LatLng(lat, lang);
                                    mapController
                                        ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                                  }
                                },
                                controller: _locationController,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xffE5E5EA))),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E5EA),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xffE5E5EA),
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.pin_drop_rounded,
                                      color: Colors.black,
                                    ),
                                    border: InputBorder.none,
                                    hintText: "52 Rue Des Fleurs 33500 Libourne"),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              )),
                          Container(
                            margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            child: Center(
                              child: loading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : PrimaryButton(
                                      onTap: () async {
                                        setState(() {
                                          loading = true;
                                        });
                                        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                                        String photoURL = await StorageServices().uploadImageToStorage('UserPics', widget.image!, true);
                                        FirebaseFirestore.instance.collection("activity").doc(eventId).set({
                                          "title": widget.title,
                                          "eventId": eventId,
                                          "description": widget.description,
                                          "address": _locationController.text,
                                          "category": widget.category,
                                          "photo": photoURL,
                                          "latitude": position.latitude,
                                          "longitude": position.longitude,
                                          "date": widget.day,
                                          "uid": FirebaseAuth.instance.currentUser!.uid,
                                          "startTime": widget.startTime,
                                          "endTime": widget.endTime,
                                          "activity": widget.category,
                                          "activityStatus": "ongoing",
                                          "acceptedUser": [FirebaseAuth.instance.currentUser!.uid],
                                          "isActivityPrivate": widget.isActivityPrivate,
                                          "requestedUserIds": []
                                        });
                                        await FirebaseFirestore.instance.collection('groupChat').doc(eventId).set({
                                          "membersId": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                                          "groupAdminId": FirebaseAuth.instance.currentUser!.uid,
                                          "groupName": widget.title,
                                          "createdAt": DateTime.now(),
                                          "docId": eventId,
                                        });

                                        setState(() {
                                          loading = false;
                                        });

                                        showSnakBar("Activity Created Successfully", context!);

                                        Navigator.pushReplacement(context!, MaterialPageRoute(builder: (builder) => CustomNavBar()));
                                      },
                                      title: 'Save',
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void getLatLong() async {
    setState(() {
      _isLoading = true;
    });
    latlong = await getLocation().getLatLong();
    setState(() {
      latlong;
      _isLoading = false;
    });
  }
}
