import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:join/screens/calender/widgets/custom_card_your_calender.dart';

class AllOnGoingActivities extends StatefulWidget {
  const AllOnGoingActivities({
    super.key,
  });

  @override
  State<AllOnGoingActivities> createState() => _AllOnGoingActivitiesState();
}

class _AllOnGoingActivitiesState extends State<AllOnGoingActivities> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('activity')
          .where("acceptedUser", arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return CustomYourCalenderCard(data: snapshot.data!.docs[index]);
          },
        );
      },
    );
  }
}
