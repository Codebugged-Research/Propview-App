import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/constants/uiConstants.dart';

import 'package:propview/services/authService.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/landingPage.dart' as ad;
import 'package:propview/views/Manager/landingPage.dart' as man;
import 'package:propview/views/Employee/landingPage.dart' as emp;
import 'package:propview/views/loginScreen.dart';

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
    var duration = new Duration(milliseconds: 1500);
    return new Timer(duration, navigate);
  }

  void navigate() async {
    var auth = await AuthService.getSavedAuth();
    if (auth != null) {
      if (auth["role"] == "admin" || auth["role"] == "super_admin") {
        Routing.makeRouting(context,
            routeMethod: 'pushReplacement',
            newWidget: ad.LandingScreen(selectedIndex: 0));
      } else if (auth["role"] == "manager") {
        Routing.makeRouting(context,
            routeMethod: 'pushReplacement',
            newWidget: man.LandingScreen(selectedIndex: 0));
      } else if (auth["role"] == "employee") {
        Routing.makeRouting(context,
            routeMethod: 'pushReplacement',
            newWidget: emp.LandingScreen(selectedIndex: 0));
      } else {
        Routing.makeRouting(context,
            routeMethod: 'pushReplacement',
            newWidget: emp.LandingScreen(selectedIndex: 0));
      }
    } else {
      Routing.makeRouting(context,
          routeMethod: 'pushReplacement', newWidget: LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff314B8C),
      body: Container(
        height: UIConstants.fitToHeight(640, context),
        width: UIConstants.fitToWidth(360, context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }
}
