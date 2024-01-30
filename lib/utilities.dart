
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void pushToNewRoute(BuildContext context, Widget routeName) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => routeName));
}

void pushToNewRouteAndClearAll(BuildContext context, Widget routeName) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => routeName), (route) => false);
}

Future<void> storeToSharedPreference(bool isLoggedIn) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await  prefs.setBool('isLoggedIn',isLoggedIn );
}