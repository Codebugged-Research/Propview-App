import 'package:flutter/material.dart';
import 'package:propview/services/reminderService.dart';
import 'package:provider/provider.dart';

class NotificationTest extends StatefulWidget {
  @override
  _NotificationTestState createState() => _NotificationTestState();
}

class _NotificationTestState extends State<NotificationTest> {
  @override
  void initState() {
    super.initState();
    Provider.of<ReminderService>(context, listen: false).initiliazeReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
                child: Consumer<ReminderService>(
      builder: (context, model, _) =>
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            onPressed: () => model.instantNofitication(),
            child: Text('Instant Notification')),
        ElevatedButton(
            onPressed: () => model.imageNotification(),
            child: Text('Image Notification')),
        ElevatedButton(
            onPressed: () => model.stylishNotification(),
            child: Text('Media Notification')),
        ElevatedButton(
            onPressed: () => model.sheduledNotification(),
            child: Text('Scheduled Notification')),
        ElevatedButton(
            onPressed: () => model.cancelNotification(),
            child: Text('Cancel Notification')),
      ]),
    ))));
  }
}
