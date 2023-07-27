import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:join/models/events_model.dart';
import 'package:join/providers/events_provider.dart';
import 'package:join/providers/filter_provider.dart';
import 'package:join/screens/custom_navbar/dashboard/widgets/navigate_to_friends_screen.dart';
import 'package:join/screens/custom_navbar/dashboard/widgets/navigate_to_request_screen.dart';
import 'package:join/screens/custom_navbar/dashboard/widgets/welcome_screen_header.dart';
import 'package:provider/provider.dart';

import '../../activities/all_activity_from_db.dart';
import '../../filters/filters.dart';
import '../../notification/notiy.dart';

//todo please fix padding problem
class WelComePage extends StatefulWidget {
  const WelComePage({super.key});

  @override
  State<WelComePage> createState() => _WelComePageState();
}

class _WelComePageState extends State<WelComePage> {
  int value = 1;

  String googleApikey = "AIzaSyBffT8plN_Vdcd308KgmzIfGVQN6q-CkAo";
  GoogleMapController? mapController;
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(51.1657, 10.4515));
  BitmapDescriptor? customMarkerIcon;
  BitmapDescriptor? currentUserMarkerIcon;
  BitmapDescriptor? physicalActivityIcon;
  BitmapDescriptor? intellectualActivityIcon;
  BitmapDescriptor? sipTogetherIcon;
  BitmapDescriptor? relaxationActivityIcon;
  BitmapDescriptor? creativeActivityIcon;
  BitmapDescriptor? friendIcon;
  List<EventsModel> eventsListInSpecificRange = [];

  double positionLat = 0.0;
  double positionLong = 0.0;
  bool isLoading = true;

  List<Marker> markersIncludingAll = [];
  List<Marker> allUsersMarkers = [];
  List<Marker> allEventMarkers = [];

  List<Marker> currentUserMarker = [];
  List<Marker> markers = [];
  bool isDataFetched = false;
  bool noFriendsData = false;
  LatLng? startLocation;


  @override
  void initState() {
    initializeScreen();

    super.initState();
  }

  initializeScreen() async {
    await loadCurrentUserCustomMarkerIcon();
    await loadCustomMarkerIcon();
    await fetchLocationData();

    await getAllEvents();
    await getEvents();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      getEvents();

    });
    _getCurrentPosition();


  }
  @override
  Widget build(BuildContext context) {
    startLocation =  LatLng(positionLat, positionLong);

      print("OnBuild");
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 200),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
          title: const Text(
            "Welcome to JOIN",
            style: TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w700, fontSize: 17, color: Color(0xff160F29)),
            overflow: TextOverflow.ellipsis,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              "assets/hand.png",
              height: 22,
              width: 22,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => Filters()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/right.png"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (builder) => Noti()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/noti.png"),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: value,
                    child: const Text("Requests"),
                    onTap: () {
                      setState(() {
                        value = 1;
                      });
                    },
                  ),
                  PopupMenuItem(
                    value: value,
                    child: const Text("Friends"),
                    onTap: () {
                      setState(() {
                        value = 2;
                      });
                    },
                  ),
                ];
              },
              onSelected: (v) {
                if (v == 1) {
                  navigateToRequestScreen(context);
                } else if (v == 2) {
                  navigateToFriendsScreen(context);
                }
              },
            )
          ],
          flexibleSpace: const WelcomeScreenHorizontalHeader(),
        ),
      ),
      body: SizedBox(
        height: 600,
        child: Stack(
          children: [
            positionLat==0.0&&isLoading
                ? const Center(child: Text("Getting location.."),)/*Stack(
                    children: [
                      GoogleMap(
                        myLocationButtonEnabled: true,
                        zoomGesturesEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: startLocation!, //initial position
                          zoom: 14.0, //initial zoom level
                        ),
                        markers: Set<Marker>.of(markers),
                        mapType: MapType.normal, //map type
                        onMapCreated: (controller) {
                          setState(() {
                            mapController = controller;
                          });
                        },
                        onCameraMove: (CameraPosition cameraPositiona) {
                          cameraPosition = cameraPositiona;
                        },
                      ),
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  )*/
                : Stack(
              children: [
                GoogleMap(
                  mapToolbarEnabled: true,
                  myLocationEnabled:true/* Provider.of<FilterProvider>(context).showMyLocation*/,
                  myLocationButtonEnabled: true,
                  // zoomGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: startLocation!, //initial position
                    zoom: 14.0, //initial zoom level
                  ),
                  markers:  Provider.of<FilterProvider>(context).showUsers == false &&
                      Provider.of<FilterProvider>(context).showEvents == false
                      ? Set<Marker>.of(currentUserMarker)
                      : Provider.of<FilterProvider>(context).showUsers &&
                      Provider.of<FilterProvider>(context).showEvents == false
                      ? Set<Marker>.of(allUsersMarkers)
                      :  Provider.of<FilterProvider>(context).showUsers &&
                      Provider.of<FilterProvider>(context).showEvents
                      ? Set<Marker>.of(markersIncludingAll)
                      :  Provider.of<FilterProvider>(context).showUsers == false &&
                      Provider.of<FilterProvider>(context).showEvents
                      ? Set<Marker>.of(allEventMarkers) : Set<Marker>.of([]),
                  mapType: MapType.normal, //map type
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                  onCameraMove: (CameraPosition cameraPositiona) {
                    cameraPosition = cameraPositiona;
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 80),
                height: 34,
                width: 94,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(34),
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      //todo
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AllActivityScreen()));
                    },
                    child: const Text(
                      "List View",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //  searchController.dispose();
    super.dispose();
  }

  getAllEvents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('activity').get();
    List<EventsModel> eventsList = [];
    if (snapshot.docs.isNotEmpty) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        EventsModel event = EventsModel.fromJson(snapshot.docs[i]);
        eventsList.add(event);
      }

      Provider.of<EventsProvider>(context, listen: false).updateEvents(eventsList);
      Provider.of<EventsProvider>(context, listen: false).updateRange(eventsList);
    }
  }

  getEvents() async {
    eventsListInSpecificRange = Provider.of<EventsProvider>(context, listen: false).eventsInRange;
  //  print(eventsListInSpecificRange.length);
    if (eventsListInSpecificRange.isNotEmpty) {
      for (int i = 0; i < eventsListInSpecificRange.length; i++) {
        if (eventsListInSpecificRange[i].category == 'Physical Activities') {
          var marker = Marker(
              markerId: MarkerId(eventsListInSpecificRange[i].eventId),
              position: LatLng(eventsListInSpecificRange[i].latitude, eventsListInSpecificRange[i].longitude),
              icon: physicalActivityIcon!,
              infoWindow: InfoWindow(
                  title: eventsListInSpecificRange[i].title,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(eventsListInSpecificRange[i].photo),
                                Text("Name: ${eventsListInSpecificRange[i].title}"),
                                // Text("Lat: ${s['positionLat']}\n${friendInfo['positionLong']}")
                              ],
                            ),
                          );
                        });
                  }));

          markersIncludingAll.add(marker);
          allEventMarkers.add(marker);
        }
        else if (eventsListInSpecificRange[i].category == 'Interllectual Activities') {
          var marker = Marker(
              markerId: MarkerId(eventsListInSpecificRange[i].eventId),
              position: LatLng(eventsListInSpecificRange[i].latitude, eventsListInSpecificRange[i].longitude),
              icon: intellectualActivityIcon!,
              infoWindow: InfoWindow(
                  title: eventsListInSpecificRange[i].title,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(eventsListInSpecificRange[i].photo),
                                Text("Name: ${eventsListInSpecificRange[i].title}"),
                                // Text("Lat: ${s['positionLat']}\n${friendInfo['positionLong']}")
                              ],
                            ),
                          );
                        });
                  }));
          //markersIncludingEventsAndAllUsers.add(marker);
          //markersIncludingEventsAndCurrentUser.add(marker);
          markersIncludingAll.add(marker);
          allEventMarkers.add(marker);
        }
        else if (eventsListInSpecificRange[i].category == 'Sip Together') {
          var marker = Marker(
              markerId: MarkerId(eventsListInSpecificRange[i].eventId),
              position: LatLng(eventsListInSpecificRange[i].latitude, eventsListInSpecificRange[i].longitude),
              icon: sipTogetherIcon!,
              infoWindow: InfoWindow(
                  title: eventsListInSpecificRange[i].title,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(eventsListInSpecificRange[i].photo),
                                Text("Name: ${eventsListInSpecificRange[i].title}"),
                                // Text("Lat: ${s['positionLat']}\n${friendInfo['positionLong']}")
                              ],
                            ),
                          );
                        });
                  }));
          //markersIncludingEventsAndAllUsers.add(marker);
          //markersIncludingEventsAndCurrentUser.add(marker);
          markersIncludingAll.add(marker);
          allEventMarkers.add(marker);
        }
        else if (eventsListInSpecificRange[i].category == 'Relaxation and Leisure Activities') {
          var marker = Marker(
              markerId: MarkerId(eventsListInSpecificRange[i].eventId),
              position: LatLng(eventsListInSpecificRange[i].latitude, eventsListInSpecificRange[i].longitude),
              icon: relaxationActivityIcon!,
              infoWindow: InfoWindow(
                  title: eventsListInSpecificRange[i].title,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(eventsListInSpecificRange[i].photo),
                                Text("Name: ${eventsListInSpecificRange[i].title}"),
                                // Text("Lat: ${s['positionLat']}\n${friendInfo['positionLong']}")
                              ],
                            ),
                          );
                        });
                  }));
         // markersIncludingEventsAndAllUsers.add(marker);
         // markersIncludingEventsAndCurrentUser.add(marker);
          markersIncludingAll.add(marker);
          allEventMarkers.add(marker);
        }
        else if (eventsListInSpecificRange[i].category == 'Creative Activities') {
          var marker = Marker(
              markerId: MarkerId(eventsListInSpecificRange[i].eventId),
              position: LatLng(eventsListInSpecificRange[i].latitude, eventsListInSpecificRange[i].longitude),
              icon: creativeActivityIcon!,
              infoWindow: InfoWindow(
                  title: eventsListInSpecificRange[i].title,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            insetPadding: EdgeInsets.zero,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(eventsListInSpecificRange[i].photo),
                                Text("Name: ${eventsListInSpecificRange[i].title}"),
                                // Text("Lat: ${s['positionLat']}\n${friendInfo['positionLong']}")
                              ],
                            ),
                          );
                        });
                  }));
         // markersIncludingEventsAndAllUsers.add(marker);
          //markersIncludingEventsAndCurrentUser.add(marker);
          markersIncludingAll.add(marker);
          allEventMarkers.add(marker);
        }
      }
    }


    print("AllEvent Marker>>>>>${eventsListInSpecificRange.length}");
    setState(() {

    });
  }


  Future<void> fetchLocationData() async {
    setState(() {
      isLoading = true;
    });
    var userInfo = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (userInfo.exists) {
      print(userInfo.exists);
      positionLat = userInfo['positionLat'];
      positionLong = userInfo['positionLong'];


      List friends = userInfo['friends'];
      print("=================>>>>> Friends length" + "${friends.length}");
      if (friends.isNotEmpty) {
        print("Friends is not emty");
        print(friends.length);
        for (int i = 0; i < friends.length; i++) {
          var friendInfo = await FirebaseFirestore.instance.collection("users").doc(friends[i]).get();

          if (friendInfo.exists) {
            bool isPublicLocation=true;
            try{

              isPublicLocation=(friendInfo['isPublicLocation']);
            }catch(e){
              isPublicLocation=true;

            }
            if(isPublicLocation) {
              var marker = Marker(
                  markerId: MarkerId(friendInfo['uid']),
                  position: LatLng(
                      friendInfo['positionLat'], friendInfo['positionLong']),
                  icon: friendIcon!,
                  infoWindow: InfoWindow(
                      title: "${friendInfo['name']}",
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                insetPadding: EdgeInsets.zero,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(friendInfo['photo']),
                                    Text("Name: ${friendInfo['name']}"),
                                    Text(
                                        "Lat: ${friendInfo['positionLat']}\n${friendInfo['positionLong']}")
                                  ],
                                ),
                              );
                            });
                      }));
              markersIncludingAll.add(marker);
              allUsersMarkers.add(marker);
            }
          }
        }

        setState(() {
          isLoading = false;
          isDataFetched = true;
          noFriendsData = true;
        });
      }
    }
    print(markersIncludingAll.length);
    print(allUsersMarkers.length);
    setState(() {
      isLoading = false;
      isDataFetched = true;
      noFriendsData = true;
    });
  }

  Future<void> loadCurrentUserCustomMarkerIcon() async {
    String markerIconPath = 'assets/place_detail.png';
    final ByteData byteData = await rootBundle.load(markerIconPath);
    final Uint8List byteList = byteData.buffer.asUint8List();

    String friendIconPath = 'assets/user_icon.png';
    final ByteData byteData1 = await rootBundle.load(friendIconPath);
    final Uint8List byteList1 = byteData1.buffer.asUint8List();

    String physicalIconPath = 'assets/physical_activity.png';
    final ByteData byteData2 = await rootBundle.load(physicalIconPath);
    final Uint8List byteList2 = byteData2.buffer.asUint8List();

    String intellectualIconPath = 'assets/intellactual_activity.png';
    final ByteData byteData3 = await rootBundle.load(intellectualIconPath);
    final Uint8List byteList3 = byteData3.buffer.asUint8List();

    String creativeActivity = 'assets/creative_activity.png';
    final ByteData byteData4 = await rootBundle.load(creativeActivity);
    final Uint8List byteList4 = byteData4.buffer.asUint8List();

    String relaxationActivity = 'assets/relaxation_activity.png';
    final ByteData byteData5 = await rootBundle.load(relaxationActivity);
    final Uint8List byteList5 = byteData5.buffer.asUint8List();

    String sipTogether = 'assets/sip_together.png';
    final ByteData byteData6 = await rootBundle.load(sipTogether);
    final Uint8List byteList6 = byteData6.buffer.asUint8List();

    setState(() {
      currentUserMarkerIcon = BitmapDescriptor.fromBytes(byteList);
      friendIcon = BitmapDescriptor.fromBytes(byteList1);
      physicalActivityIcon = BitmapDescriptor.fromBytes(byteList2);
      intellectualActivityIcon = BitmapDescriptor.fromBytes(byteList3);
      creativeActivityIcon = BitmapDescriptor.fromBytes(byteList4);
      relaxationActivityIcon = BitmapDescriptor.fromBytes(byteList5);
      sipTogetherIcon = BitmapDescriptor.fromBytes(byteList6);

    });
  }

  Future<void> loadCustomMarkerIcon() async {
    String markerIconPath = 'assets/user_loc.png';
    final ByteData byteData = await rootBundle.load(markerIconPath);
    final Uint8List byteList = byteData.buffer.asUint8List();

    setState(() {
      customMarkerIcon = BitmapDescriptor.fromBytes(byteList);
    });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {

      if(mapController==null){
        positionLat=position.latitude;
        positionLong=position.longitude;
      }else{
        positionLat=position.latitude;
        positionLong=position.longitude;
        mapController?.animateCamera(CameraUpdate.newLatLng( LatLng(positionLat, positionLong)));
      }

    }).catchError((e) {
      debugPrint(e);
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
    permission = await Geolocator.checkPermission( );
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

}
