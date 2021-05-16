import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:propview/services/reminderService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/theme.dart';
import 'package:propview/views/splashScreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("${message.notification.body}");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
        child: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              // Check for errors
              if (snapshot.hasError) {
                return MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: Text("Firebase Connection error"),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return MaterialApp(
                  title: 'Propview',
                  debugShowCheckedModeBanner: false,
                  theme: ThemeClass.buildTheme(context),
                  home: SplashScreen(),
                );
              }
              return circularProgressWidget();
            }),
        providers: [ChangeNotifierProvider(create: (_) => ReminderService())]);
  }
}
