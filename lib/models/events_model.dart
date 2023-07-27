


import 'package:cloud_firestore/cloud_firestore.dart';

class EventsModelFields{
  static const String acceptedUser='acceptedUser';
  static const String activity='activity';
  static const String activityStatus='activityStatus';
  static const String address='address';
  static const String category='category';
  static const String date='date';
  static const String description='description';
  static const String endTime='endTime';
  static const String eventId='eventId';
  static const String isActivityPrivate='isActivityPrivate';
  static const String latitude='latitude';
  static const String longitude='longitude';
  static const String photo='photo';
  static const String requestedUserIds='requestedUserIds';
  static const String startTime='startTime';
  static const String title='title';
  static const String uid='uid';

}

class EventsModel{

  List acceptedUser;
  String activity;
  String activityStatus;
  String address;
  String category;
  String date;
  String description;
  String endTime;
  String eventId;
  bool isActivityPrivate;
  double latitude;
  double longitude;
  String photo;
  List requestedUserIds;
  String startTime;
  String title;
  String uid;

  EventsModel({
    required this.acceptedUser,
    required this.activity,
    required this.activityStatus,
    required this.address,
    required this.category,
    required this.date,
    required this.description,
    required this.endTime,
    required this.eventId,
    required this.isActivityPrivate,
    required this.latitude,
    required this.longitude,
    required this.photo,
    required this.requestedUserIds,
    required this.startTime,
    required this.title,
    required this.uid,
});

  factory EventsModel.fromJson(DocumentSnapshot json)=>EventsModel(
      acceptedUser: json[EventsModelFields.acceptedUser],
      activity: json[EventsModelFields.activity],
      activityStatus: json[EventsModelFields.activityStatus],
      address: json[EventsModelFields.address],
      category: json[EventsModelFields.category],
      date: json[EventsModelFields.date],
      description: json[EventsModelFields.description],
      endTime: json[EventsModelFields.endTime],
      eventId: json[EventsModelFields.eventId],
      isActivityPrivate: json[EventsModelFields.isActivityPrivate],
      latitude: json[EventsModelFields.latitude],
      longitude: json[EventsModelFields.longitude],
      photo: json[EventsModelFields.photo],
      requestedUserIds: json[EventsModelFields.requestedUserIds],
      startTime: json[EventsModelFields.startTime],
      title: json[EventsModelFields.title],
      uid: json[EventsModelFields.uid]
  );

}