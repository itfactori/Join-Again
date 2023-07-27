import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:join/models/events_model.dart';
import 'package:join/providers/events_provider.dart';
import 'package:join/providers/filter_provider.dart';
import 'package:provider/provider.dart';

class Filters extends StatefulWidget {

  final bool isFromActivity;

  const Filters({super.key,   this.isFromActivity=false});

  @override
  State<Filters> createState() => _FiltersState();
}



class _FiltersState extends State<Filters> {

  @override
  void initState() {


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 243, 246),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text("Setting"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
    builder: (context, AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
    return const Center(child: CircularProgressIndicator());
    }
    try{
      var document = snapshot.data;
      Provider.of<FilterProvider>(context,listen: false).
      updateShowMyLocation(document['isPublicLocation']);
    }catch(e){
      Provider.of<FilterProvider>(context,listen: false).
      updateShowMyLocation(true);

      }

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: !widget.isFromActivity,
              child: SwitchListTile(
                title: const Text(
                  'Public Location',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                subtitle: const Text(
                  "Your Location is now public and you will be shown to other users on the map",
                  style: TextStyle(fontSize: 12),
                ),
                value: Provider.of<FilterProvider>(context).showMyLocation,
                onChanged: (bool value)   {
                   FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid) .update({
                    "isPublicLocation": value,
                  });
                /*  setState(() {
                    Provider.of<FilterProvider>(context,listen: false).updateShowMyLocation(value);
                  });*/
                },
              ),
            ),


            Visibility(
                visible: !widget.isFromActivity,child: const Divider()),
            Visibility(
              visible: !widget.isFromActivity,
              child: SwitchListTile(
                title: const Text(
                  'Show Users',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                value: Provider.of<FilterProvider>(context).showUsers,
                onChanged: (bool value) {
                  setState(() {
                    Provider.of<FilterProvider>(context,listen: false).updateShowUsers(value);
                  });
                },
              ),
            ),
            Visibility(
                visible: !widget.isFromActivity,
                child: const Divider()),
            Visibility(
              visible: !widget.isFromActivity,
              child: SwitchListTile(
                title: const Text(
                  'Show Events',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                value: Provider.of<FilterProvider>(context).showEvents,
                onChanged: (bool value) {
                  setState(() {
                    Provider.of<FilterProvider>(context,listen: false).updateShowEvents(value);
                  });
                },
              ),
            ),
            Visibility(
                visible: !widget.isFromActivity,child: const Divider()),
            Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Events in next ${Provider.of<FilterProvider>(context).dayValueHolder} days",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Slider(
                    value: Provider.of<FilterProvider>(context).dayValueHolder.toDouble(),
                    min: 1,
                    max: 7,
                    divisions: 7,
                    activeColor: const Color(0xff246A73),
                    inactiveColor: Colors.grey,
                    label: '${Provider.of<FilterProvider>(context).dayValueHolder.round()}',
                    onChangeEnd: (newValue){
                      List<EventsModel> events=Provider.of<EventsProvider>(context,listen: false).events;
                      List<EventsModel> updatedEvents=[];
                      int value=int.parse(newValue.toStringAsFixed(0));
                      print(value);
                      for(int i=0;i<events.length;i++){
                        DateTime today=DateTime.now();
                        DateTime eventDate=DateFormat.yMMMMd('en_US').parse(events[i].date);
                        String todayFormatted=DateFormat('yyyy-MM-dd').format(today);
                        String formattedDate=DateFormat('yyyy-MM-dd').format(eventDate);
                        print(value);
                        if(DateTime.parse(formattedDate).difference(DateTime.parse(todayFormatted)).inDays<value){
                          updatedEvents.add(events[i]);
                        }
                      }
                      Provider.of<EventsProvider>(context,listen: false).updateRange(updatedEvents);
                    },
                    onChanged: (double newValue) {
                      setState(() {
                        Provider.of<FilterProvider>(context,listen: false).updateDays(newValue.round());
                      });
                    },
                    semanticFormatterCallback: (double newValue) {
                      return '${newValue.round()}';
                    })),
          ],
    );
    }),
    );
  }
}