import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:propview/services/reminderService.dart';
import 'package:propview/utils/theme.dart';
import 'package:propview/views/splashScreen.dart';

import 'services/reminderService.dart';
import 'services/reminderService.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //TODO:alert dialog box

  if (message.notification != null) {
    print(
        'background Message also contained a notification: ${message.notification}');
  }

  if (message.data != null) {
    //TODO:trigger schedule
    print(' background Message also contained a data: ${message.data["name"]}');
  }
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ReminderService reminderService;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //TODO:alert dialog box
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.data != null) {
        //TODO:trigger schedule
        print('Message also contained a notification: ${message.notification}');
        reminderService.sheduledNotification(message.data['startTime'], message.data['endTime']);
      }
    });
    print("initited");
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
        child: MaterialApp(
          title: 'Propview',
          debugShowCheckedModeBanner: false,
          theme: ThemeClass.buildTheme(context),
          home: SplashScreen(),
        ),
        providers: [ChangeNotifierProvider(create: (_) => ReminderService())]);
  }
}
