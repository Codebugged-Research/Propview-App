import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/views/landingPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 9000);
    return new Timer(duration, navigate);
  }

  void navigate() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LandingPage()));
    // var auth = await AuthService.getSavedAuth();
    // if (auth != null) {
    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (context) {
    //     return LandingScreen(selectedIndex: 0);
    //   }));
    // } else {
    //   Navigator.of(context)
    //       .pushReplacement(MaterialPageRoute(builder: (context) {
    //     return LogInScreen();
    //   }));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff314B8C),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 14,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/logo.png"),
                  Text(
                    "PropView",
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Made with ❤ By Codebugged AI",
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
