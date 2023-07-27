import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void getNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      carPlay: true,
      criticalAlert: true,
      announcement: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      EasyLoading.showSuccess("Permission Granted");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      EasyLoading.showSuccess("Provisional Authorization Granted");
    } else {
      EasyLoading.showError("Notification Permission Denied");
    }
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message, message.data['userId']);
    });
  }

  void initNotification(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context!, initialMessage, initialMessage.data['userId']);
    }

    //Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (Platform.isAndroid) {
        initLocalNotifications(context, remoteMessage!);
        showNotification(context, remoteMessage);
        handleMessage(context, remoteMessage, remoteMessage.data['userId']);
      } else {
        showNotification(context, remoteMessage!);
        handleMessage(context, remoteMessage, remoteMessage.data['userId']);
      }
    });

    //BackGround
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        handleMessage(context, remoteMessage, remoteMessage.data['userId']);
      }
    });
  }

  void getDeviceToken() async {
    String? token = await messaging.getToken();
    await FirebaseFirestore.instance.collection("tokens").doc(FirebaseAuth.instance.currentUser!.uid).set({
      "token": token,
    });
  }

  Future<void> showNotification(BuildContext context, RemoteMessage message) async {
    initLocalNotifications(context, message);
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message, String? userId) {
    print("Handle Notification Called =============== ${message.data}");
    if (message.data['userId'] == userId) {
    } else {
      EasyLoading.showError("Not Navigate");
      EasyLoading.showError("Not Navigate");
    }
  }
}
