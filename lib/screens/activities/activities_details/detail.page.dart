import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:join/screens/activities/widgets/detail_page_photo_widget.dart';

import '../widgets/detail_page_activity_footer.dart';
import '../widgets/detail_page_activity_header.dart';

class DetailPage extends StatefulWidget {
  final dynamic data;

  const DetailPage({super.key, this.data});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String googleApikey = "AIzaSyBffT8plN_Vdcd308KgmzIfGVQN6q-CkAo";
  GoogleMapController? mapController; //contrller for Google map
  CameraPosition cameraPosition = const CameraPosition(target: LatLng(51.1657, 10.4515));
  bool _isLoading = false;
  List latlong = [];
  String location = 'Please move map to A specific location.';
  TextEditingController _locationController = TextEditingController();
  BitmapDescriptor? customMarkerIcon;

  Future<void> loadCustomMarkerIcon() async {
    String markerIconPath = 'assets/place_detail.png';
    final ByteData byteData = await rootBundle.load(markerIconPath);
    final Uint8List byteList = byteData.buffer.asUint8List();

    setState(() {
      customMarkerIcon = BitmapDescriptor.fromBytes(byteList);
    });
  }

  initializeData() async {
    setState(() {
      isLoading = true;
    });
    startPosition = LatLng(widget.data['latitude'], widget.data['longitude']);
    await loadCustomMarkerIcon();
    markers.add(Marker(
        markerId: MarkerId(widget.data['uid']),
        position: LatLng(widget.data['latitude'], widget.data['longitude']),
        icon: customMarkerIcon!,
        infoWindow: InfoWindow(
            title: "${widget.data['title']}",
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              height: MediaQuery.of(context).size.height * .4,
                              child: Image.network(widget.data['photo'])),
                          Text("Name: ${widget.data['title']}"),
                        ],
                      ),
                    );
                  });
            })));
    setState(() {
      isLoading = false;
    });
  }

  LatLng? startPosition;

  bool isLoading = false;
  List<Marker> markers = [];

  PageController pageController = PageController();

  @override
  void initState() {
    initializeData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.data['title'],
          style: const TextStyle(fontFamily: "ProximaNova", fontWeight: FontWeight.w700, fontSize: 17, color: Color(0xff160F29)),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailPagePhotoWidget(data: widget.data),
              const SizedBox(height: 15),
              DetailPageActivityHeader(data: widget.data),
              const SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.data['description'],
                        style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Location",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        widget.data['address'],
                        style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        height: 135,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GoogleMap(
                                  zoomGesturesEnabled: true,
                                  //enable Zoom in, out on map
                                  initialCameraPosition: CameraPosition(
                                    target: startPosition!, //initial position
                                    zoom: 14.0, //initial zoom level
                                  ),
                                  markers: Set<Marker>.of(markers),
                                  mapType: MapType.normal,
                                  //map type
                                  onMapCreated: (controller) {
                                    setState(() {
                                      mapController = controller;
                                    });
                                  },
                                  onCameraMove: (CameraPosition cameraPositiona) {
                                    cameraPosition = cameraPositiona;
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
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              DetailPageActivityFooter(data: widget.data),
            ],
          ),
        ),
      ),
    );
  }
}
