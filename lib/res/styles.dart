import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle textWith16(Color color) {
    return GoogleFonts.cardo(
      color: color,
      fontSize: 16,
    );
  }

  static TextStyle textWith16bold(Color color) {
    return GoogleFonts.cardo(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.bold
    );
  }

  static TextStyle textWith20withBold500(Color color) {
    return GoogleFonts.cardo(color: color, fontSize: 20, fontWeight: FontWeight.w500);
  }

  static TextStyle textWith18withBold500(Color color) {
    return GoogleFonts.cardo(color: color, fontSize: 18, fontWeight: FontWeight.w500);
  }

  static TextStyle textWith18withBold(Color color) {
    return GoogleFonts.cardo(color: color, fontSize: 18, fontWeight: FontWeight.bold);
  }

  static TextStyle textWith12(Color color) {
    return GoogleFonts.cardo(
      color: color,
      fontSize: 12,
    );
  }

  static TextStyle textWith14(Color color) {
    return GoogleFonts.cardo(
      color: color,
      fontSize: 14,
    );
  }

  static TextStyle textWith14withBold(Color color) {
    return GoogleFonts.cardo(color: color, fontSize: 14, fontWeight: FontWeight.bold);
  }

  static TextStyle textWith20withBold(Color color) {
    return GoogleFonts.cardo(color: color, fontSize: 20, fontWeight: FontWeight.bold);
  }
}
