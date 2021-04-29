import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {
  static ThemeData buildTheme(BuildContext context) {
    ThemeData themeData = ThemeData(
      primaryColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Color(0xFFFFFFFF),
      appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Color(0xff314B8C),
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white)),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFFFFFFF)),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Color(0xff314B8C)),
      primaryTextTheme:
          GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme).copyWith(
              headline1: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),
              headline2: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),
              headline3: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),
              headline4: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),
              headline5: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),
              headline6: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal),
              subtitle1: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal),
              subtitle2: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
              caption: GoogleFonts.nunitoSans(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  letterSpacing: -0.32),
              overline: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
              ),
              button: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.25)),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xff314B8C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    return themeData;
  }
}
