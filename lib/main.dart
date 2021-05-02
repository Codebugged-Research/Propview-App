import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propview/utils/theme.dart';
import 'package:propview/views/splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Propview',
      debugShowCheckedModeBanner: false,
      theme: ThemeClass.buildTheme(context),
      home: SplashScreen(),
    );
  }
}