import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReminderService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initiliazeReminder() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

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

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Instant Notifications
  Future instantNofitication() async {
    var android = AndroidNotificationDetails("id", "channel", "description");

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo instant notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Image notification
  Future imageNotification() async {
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("logo"),
        largeIcon: DrawableResourceAndroidBitmap("logo"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", "description",
        styleInformation: bigPicture);

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  Future stylishNotification() async {
    var android = AndroidNotificationDetails("id", "channel", "description",
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("logo"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Stylish notification", "Tap to do something", platform);
  }

  //Sheduled Notification

  Future sheduledNotification() async {
    var scheduledNotificationDateTime = determineScheduledTime();
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

    await _flutterLocalNotificationsPlugin.schedule(
        0,
        "Package  is ready for pickup.",
        "Reach  to pick up",
        scheduledNotificationDateTime,
        platform);
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  DateTime determineScheduledTime() {
    DateTime currentDateTime = DateTime.now();
    DateTime scheduledDateTime = currentDateTime.add(Duration(seconds: -15));
    return scheduledDateTime;
  }
}
