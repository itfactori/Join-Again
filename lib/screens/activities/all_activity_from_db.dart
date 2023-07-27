import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:join/providers/filter_provider.dart';
import 'package:join/screens/activities/widgets/all_activity_card.dart';
import 'package:provider/provider.dart';

import '../../../themes/app_colors.dart';
import '../../models/events_model.dart';
import '../../providers/events_provider.dart';
import '../filters/filters.dart';

class AllActivityScreen extends StatefulWidget {
  const AllActivityScreen({Key? key}) : super(key: key);

  @override
  State<AllActivityScreen> createState() => _AllActivityScreenState();
}

class _AllActivityScreenState extends State<AllActivityScreen> {
  bool isLoading=true;
  List<QueryDocumentSnapshot> updatedEvents=[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Activities",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.mainColor,
            )),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => const Filters(isFromActivity: true,))).then((value) =>
              {

                getEvent()
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/right.png"),
            ),
          ),
        ],
      ),
      body: isLoading? const Center(child: CircularProgressIndicator()):
      updatedEvents.isEmpty?
      const Center(
        child: Text("No Activity Found"),
      ):ListView.builder(
        itemCount: updatedEvents.length,
        itemBuilder: (context, index) {
          var data = updatedEvents[index];
          return AllActivityCard(data: data);
        },
      )


    );
  }

  @override
  void initState() {
    getEvent();
    super.initState();
  }

  Future<void> getEvent() async {
    updatedEvents=[];
    setState(() {
      isLoading=true;

    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('activity').get();
    List<QueryDocumentSnapshot> eventsList = [];
    if (snapshot.docs.isNotEmpty) {
      for (int i = 0; i < snapshot.docs.length; i++) {
        eventsList.add(snapshot.docs[i]);
      }
    }

    int value=Provider.of<FilterProvider>(context, listen: false).dayValueHolder;

    for(int i=0;i<eventsList.length;i++){
      try{
        DateTime today=DateTime.now();
        DateTime eventDate=DateFormat.yMMMMd('en_US').parse(eventsList[i]['date']);
        String todayFormatted=DateFormat('yyyy-MM-dd').format(today);
        String formattedDate=DateFormat('yyyy-MM-dd').format(eventDate);
        print(value);
        if(DateTime.parse(formattedDate).difference(DateTime.parse(todayFormatted)).inDays<value){
          updatedEvents.add(eventsList[i]);
        }
      }catch(e){

      }

    }

    setState(() {
      isLoading=false;
      updatedEvents;
    });
  }
}
