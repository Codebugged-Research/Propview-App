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
    var android = AndroidNotificationDetails("id", "channel",channelDescription:  "description");

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

    var android = AndroidNotificationDetails("id", "channel",channelDescription:  "description",
        styleInformation: bigPicture);

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  Future stylishNotification() async {
    var android = AndroidNotificationDetails("id", "channel",channelDescription:  "description",
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

  Future sheduledNotification(String startTime, String endTime) async {
    print("Hello");
    var scheduledNotificationStartTime = determineScheduledTime(startTime);
    var scheduledNotificationEndTime = determineScheduledTime(endTime);
    var bigPicture = BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("logo"),
        largeIcon: DrawableResourceAndroidBitmap("logo"),
        contentTitle: "Pickup Package Notification",
        summaryText: "Pickup your package from .",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel",channelDescription:  "description",
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

    await _flutterLocalNotificationsPlugin.schedule(
        0,
        "Scheduled Task",
        "Your scehduled task will about to end within 15 minutes",
        scheduledNotificationEndTime,
        platform);
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  DateTime determineScheduledTime(String time) {
    DateTime start = DateTime.parse(time);
    DateTime scheduledTime = start.subtract(Duration(minutes: 1));
    return scheduledTime;
  }
}
