import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/res/colours.dart';
import 'package:formula_user/screens/bottom_navigation.dart';
import 'package:formula_user/screens/home_page.dart';
import 'package:lottie/lottie.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: "AIzaSyDhcEMZ_oGAay0Z6u1iVZgg6eaRDzc1zAM",
          appId: "735367481552",
          messagingSenderId: "735367481552",
          projectId: "com.physics.formula_admin"
      ));
  runApp(   MaterialApp(
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
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/animation5.json'),
      splashIconSize: 400,
     // backgroundColor: Colours.buttonColor2,
      splashTransition: SplashTransition.fadeTransition,
      nextScreen:  const MyBottomNavigation(), // Replace HomeScreen with your main app screen
      duration: 7000, // Adjust the duration as needed
    );
  }
}
