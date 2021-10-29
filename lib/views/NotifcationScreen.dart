import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen();

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  initState() {
    super.initState();
    getData();
  }

  List notifications = [];

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> nList = prefs.getStringList("notifications") ?? [];
    setState(() {
      notifications = nList.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(color: Color(0xff314b8c)),
        ),
        centerTitle: true,
      ),
      body: notifications.length > 0
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = jsonDecode(notifications[index]);
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: Colors.grey.withOpacity(0.2),
                      leading: Icon(Icons.notifications_on),
                      title: Text(
                        notification["title"],
                      ),
                      subtitle: Text(
                        notification["message"],
                      ),
                      trailing: Text(
                        dateTimeFormatter(
                          notification["time"],
                        ),
                      ),
                    ),
                  );
                },
              ))
          : Center(
              child: Text('No Notifications Yet!'),
            ),
    );
  }

  dateTimeFormatter(String dat) {
    DateTime date = DateTime.parse(dat);
    return '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${DateTime.now().year}\n${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}';
  }
}
