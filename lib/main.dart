import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:propview/services/reminderService.dart';
import 'package:propview/utils/theme.dart';
import 'package:propview/views/splashScreen.dart';

ReminderService reminderService;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("logo");

  IOSInitializationSettings iosInitializationSettings =
      IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true);

  final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosInitializationSettings);

  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp();
  if (message.data != null) {
    scheduleIncoming(_flutterLocalNotificationsPlugin, message);
    scheduleOutgoing(_flutterLocalNotificationsPlugin, message);
  }
}

scheduleIncoming(
    FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin,
    RemoteMessage message) async {
  var scheduledNotificationStartTime =
      determineScheduledTime(message.data['startTime']);
  var bigPicture = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("logo"),
      largeIcon: DrawableResourceAndroidBitmap("logo"),
      contentTitle: "Pickup Package Notification",
      summaryText: "Pickup your package from .",
      htmlFormatContent: true,
      htmlFormatContentTitle: true);
  var android = AndroidNotificationDetails("id", "channel", "description",
      styleInformation: bigPicture);
  var ios = IOSNotificationDetails();
  var platform = new NotificationDetails(android: android, iOS: ios);
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
  var bigPicture = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("logo"),
      largeIcon: DrawableResourceAndroidBitmap("logo"),
      contentTitle: "Pickup Package Notification",
      summaryText: "Pickup your package from .",
      htmlFormatContent: true,
      htmlFormatContentTitle: true);

  var android = AndroidNotificationDetails("id", "channel", "description",
      styleInformation: bigPicture);

  var ios = IOSNotificationDetails();

  var platform = new NotificationDetails(android: android, iOS: ios);
  // ignore: deprecated_member_use
  await _flutterLocalNotificationsPlugin.schedule(
      0,
      "Scheduled Task",
      "Your scehduled task will about to end within 15 minutes",
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
