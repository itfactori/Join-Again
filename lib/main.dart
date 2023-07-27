import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:join/providers/events_provider.dart';
import 'package:join/providers/filter_provider.dart';
import 'package:join/screens/auth/first_screen.dart';
import 'package:join/screens/custom_navbar/custom_navbar.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  Provider.debugCheckInvalidValueType=null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
      providers: [
        Provider(create: (_)=>FilterProvider()),
        Provider(create: (_)=>EventsProvider())

      ],
      child: const MyApp()));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        scaffoldBackgroundColor: const Color(0xFFEDF3F4),
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white

        ),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        nextScreen: FirebaseAuth.instance.currentUser != null ? CustomNavBar() : const FirstScreen(),
        splash: Image.asset(
          'assets/splash.png',
          height: 150,
          width: 150,
        ),
        duration: 2000,
        splashIconSize: 150,
        splashTransition: SplashTransition.slideTransition,
        backgroundColor: Colors.white,
      ),
    );
  }
}
