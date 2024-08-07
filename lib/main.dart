import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/res/colours.dart';
import 'package:formula_user/res/common.dart';
import 'package:formula_user/screens/bottom_navigation.dart';
import 'package:formula_user/subscription_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'firebase_options.dart';

final serviceLocator = GetIt.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Formula_user",
      options: DefaultFirebaseOptions.currentPlatform);
  MobileAds.instance.initialize();
  runApp(ChangeNotifierProvider(
    create: (context) => SubscriptionManager(),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
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
    _controller = VideoPlayerController.asset("assets/splash_video.mp4",);
    _controller.initialize().then((_) {
      _controller.setLooping(false);
      Timer(const Duration(seconds: 0), () {
        setState(() {
          _controller.play();
          _visible = true;
        });
      });
    });
    Future.delayed(const Duration(seconds: 6), () {
      getLogInValue();
    });
  }

  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    if(!isRunning){
      isRunning = true;
      Provider.of<SubscriptionManager>(context).fetchSettingsFromFirestore();
      Provider.of<SubscriptionManager>(context, listen: true).initializeInAppPurchasesForPrimeCheck();
    }
    return Scaffold(
      backgroundColor: Colours.white,
      body: _visible
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height/2,
                  width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
            ],
          )
          : Container(),
    );
  }

  Future<void> getLogInValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    Common.isLogin = isLoggedIn ?? false;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyBottomNavigation()),
      (e) => false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
