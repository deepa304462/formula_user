import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formula_user/core/constant/pixel_size.dart';

class CommonUtils {
  static void displayToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green.shade600,
        textColor: Colors.white,
        fontSize: PixelSize.h5);
  }
}
