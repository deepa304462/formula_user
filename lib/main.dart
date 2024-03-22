import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/res/colours.dart';
import 'package:formula_user/res/common.dart';
import 'package:formula_user/screens/bottom_navigation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:formula_user/dependencyinjection/injection_container.dart' as ic;
import 'package:video_player/video_player.dart';


final serviceLocator = GetIt.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDhcEMZ_oGAay0Z6u1iVZgg6eaRDzc1zAM",
      appId: "735367481552",
      messagingSenderId: "735367481552",
      projectId: "com.mathformula.app",
    ),
  );
  MobileAds.instance.initialize();
  runApp( const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/splash_video.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      Timer(Duration(seconds:0 ), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });

    Future.delayed(Duration(seconds: 6), () {
      getLogInValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.transparent,
      body: _visible
          ? Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      )
          : Container(),
    );
  }

  Future<void> getLogInValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    Common.isLogin = isLoggedIn ?? false;
    Common.isPrime = false;

    if (isLoggedIn ?? false) {
      await checkPrimeMember();
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyBottomNavigation()),
            (e) => false,
      );
    }
  }

  Future<void> checkPrimeMember() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      DocumentSnapshot doc = await users.doc(prefs.getString('userId')).get();
      if (doc['isPrimeMember']) {
        prefs.setBool('isPrimeMember', true);
        Common.isPrime = true;
      } else {
        prefs.setBool('isPrimeMember', false);
        Common.isPrime = false;
      }
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyBottomNavigation()),
            (e) => false,
      );
    } catch (e) {
      print('Error checking user existence: $e');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyBottomNavigation()),
            (e) => false,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
