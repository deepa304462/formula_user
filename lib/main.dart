import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/res/colours.dart';
import 'package:formula_user/res/common.dart';
import 'package:formula_user/res/styles.dart';
import 'package:formula_user/screens/auth/login_page.dart';
import 'package:formula_user/screens/bottom_navigation.dart';
import 'package:formula_user/screens/home_page.dart';
import 'package:formula_user/utilities.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_model.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDhcEMZ_oGAay0Z6u1iVZgg6eaRDzc1zAM",
      appId: "735367481552",
      messagingSenderId: "735367481552",
      projectId: "com.physics.formula_admin",
    ),
  );
  MobileAds.instance.initialize();
  runApp(const MaterialApp(
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
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      getLogInValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.buttonColor2,
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          height: 250,
          width: 250,
        ),
      ),
    );
  }

  getLogInValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? isLoggedIn = prefs.getBool('isLoggedIn');
    Common.isLogin = isLoggedIn ?? false;
    Common.isPrime = false;

    if (isLoggedIn ?? false) {
      checkPrimeMember();
    } else {
      pushToNewRouteAndClearAll(context, MyBottomNavigation());
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
      pushToNewRouteAndClearAll(context, MyBottomNavigation());
    } catch (e) {
      print('Error checking user existence: $e');
      pushToNewRouteAndClearAll(context, MyBottomNavigation());
    }
  }
}
