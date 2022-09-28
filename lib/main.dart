import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:propview/services/gpsService.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:propview/services/reminderService.dart';
import 'package:propview/utils/theme.dart';
import 'package:propview/views/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

ReminderService reminderService;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("logo");

  final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings);

  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> nList = prefs.getStringList("notifications") ?? [];
  await Firebase.initializeApp();
  print(message);
  nList.add(jsonEncode({
    "message": message.notification.body,
    "title": message.notification.title,
    "start": message.data['startTime'] ?? "",
    "end": message.data['endTime'] ?? "",
    "time": DateTime.now().toString(),
  }));
  print(nList.length);
  prefs.setStringList("notifications", nList);
  if (message.data['startTime'] != null) {
    scheduleIncoming(_flutterLocalNotificationsPlugin, message);
    scheduleOutgoing(_flutterLocalNotificationsPlugin, message);
  }
}

scheduleIncoming(
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin,
    RemoteMessage message) async {
  var scheduledNotificationStartTime =
      determineScheduledTime(message.data['startTime']);
  var android = AndroidNotificationDetails("id", "channel",
      channelDescription: "description");
  var platform = new NotificationDetails(android: android);
  // ignore: deprecated_member_use
  await _flutterLocalNotificationsPlugin.schedule(
      0,
      "Scheduled Task",
      "Your scehduled task will about to start within 15 minutes",
      scheduledNotificationStartTime,
      platform);
}

scheduleOutgoing(
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin,
    RemoteMessage message) async {
  var scheduledNotificationEndTime =
      determineScheduledTime(message.data['endTime']);

  var android = AndroidNotificationDetails("id", "channel",
      channelDescription: "description");

  var platform = new NotificationDetails(android: android);
  // ignore: deprecated_member_use
  await _flutterLocalNotificationsPlugin.schedule(
      0,
      "Scheduled Task",
      "Your scheduled task will about to end within 15 minutes",
      scheduledNotificationEndTime,
      platform);
}

DateTime determineScheduledTime(String time) {
  DateTime start = DateTime.parse(time);
  DateTime scheduledTime = start.subtract(Duration(minutes: 15));
  print(scheduledTime);
  return scheduledTime;
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
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
  }

  bool gps = false;

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(
        "Latitude: ${position.latitude} Longitude: ${position.longitude} Speed ${position.speed}");
    await GPSService.createGPS(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Timer.periodic(Duration(minutes: 5), (Timer t) async {
      print("${t.tick} hello2 triggred");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      gps = prefs.getBool("gps") ?? false;
      if (gps) {
        await getLocation();
      }
    });
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
