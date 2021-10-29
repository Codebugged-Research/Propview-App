import 'dart:convert';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:propview/config.dart';
import 'package:propview/services/baseService.dart';
import 'package:propview/services/reminderService.dart';
import 'package:propview/utils/udpatepop.dart';
import 'package:propview/views/Employee/Attendance/AttendanceHome.dart';
import 'package:propview/views/Employee/Home/homeScreen.dart';
import 'package:propview/views/Employee/TaskManager/taskManagerHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  final int selectedIndex;

  LandingScreen({this.selectedIndex});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    checkversion();
    initialiseLocalNotification();
    ReminderService reminderService;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> nList = prefs.getStringList("notifications") ?? [];
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text(message.notification.body),
                title: Text(message.notification.title),
              ));
      if (message.data != null) {
        scheduleIncoming(_flutterLocalNotificationsPlugin, message);
        scheduleOutgoing(_flutterLocalNotificationsPlugin, message);
      }
      nList.add(jsonEncode({
        "message": message.notification.body,
        "title": message.notification.title,
        "start": message.data['startTime'],
        "end": message.data['endTime'],
        "time": DateTime.now().toString(),
      }));
      prefs.setStringList("notifications", nList);
    });
    _selectedIndex = widget.selectedIndex;
  }

  initialiseLocalNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("logo");

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // *
  scheduleIncoming(
      FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin,
      RemoteMessage message) async {
    var scheduledNotificationStartTime =
        determineScheduledTime(message.data['startTime']);
    var android = AndroidNotificationDetails("id", "channel", "description");
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
    var android = AndroidNotificationDetails("id", "channel", "description");

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);
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

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  List<Widget> _widgetOptions = <Widget>[
    AttendanceHome(),
    TaskMangerHome(),
    HomeScreen(),
    // ProfileScreen(),
  ];

  checkversion() async {
    var getVersion = await BaseService.getAppCurrentVersion();
    var responseMap = jsonDecode(getVersion);
    if (responseMap != Config.APP_VERISON) {
      versionErrorWiget(responseMap, context,
          "https://play.google.com/store/apps/details?id=com.propdial.propview");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to exit'),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Color(0xff314B8C),
              hoverColor: Color(0xff314B8C),
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 200),
              tabBackgroundColor: Color(0xff314B8C),
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.fact_check,
                  text: 'Attendance',
                ),
                GButton(
                  icon: Icons.work,
                  text: 'Task',
                ),
                GButton(
                  icon: Icons.house_outlined,
                  text: 'Home',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
