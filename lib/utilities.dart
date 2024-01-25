
import 'package:flutter/material.dart';

void pushToNewRoute(BuildContext context, Widget routeName) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => routeName));
}

void pushToNewRouteAndClearAll(BuildContext context, Widget routeName) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => routeName), (route) => false);
}