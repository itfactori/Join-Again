

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelFields{
  static const String dob='dob';
  static const String email='email';
  static const String friends='friends';
  static const String gender='gender';
  static const String name='name';
  static const String phone='phone';
  static const String photo='photo';
  static const String positionLat='positionLat';
  static const String positionLong='positionLong';
  static const String uid='uid';
  static const String isPublicLocation='isPublicLocation';
}
class UserModel{

  Timestamp dob;
  String email;
  List friends;
  String gender;
  String name;
  String phone;
  String photo;
  double positionLat;
  double positionLong;
  String uid;
  bool isPublicLocation;


  UserModel({
    required this.dob,
    required this.email,
    required this.friends,
    required this.gender,
    required this.name,
    required this.phone,
    required this.photo,
    required this.positionLat,
    required this.positionLong,
    required this.uid,
    required this.isPublicLocation,
});

  Map<String,dynamic> toMap()=>{
    UserModelFields.dob:dob,
    UserModelFields.email:email,
    UserModelFields.friends:friends,
    UserModelFields.gender:gender,
    UserModelFields.name:name,
    UserModelFields.phone:phone,
    UserModelFields.photo:photo,
    UserModelFields.positionLat:positionLat,
    UserModelFields.positionLong:positionLong,
    UserModelFields.uid:uid,
    UserModelFields.isPublicLocation:isPublicLocation,
  };

  factory UserModel.fromJson(DocumentSnapshot json)=>UserModel(
      dob: json[UserModelFields.dob],
      email: json[UserModelFields.email],
      friends: json[UserModelFields.friends],
      gender: json[UserModelFields.gender],
      name: json[UserModelFields.name],
      phone: json[UserModelFields.phone],
      photo: json[UserModelFields.photo],
      positionLat: json[UserModelFields.positionLat],
      positionLong: json[UserModelFields.positionLong],
      uid: json[UserModelFields.uid],
      isPublicLocation: json[UserModelFields.isPublicLocation]
  );

}