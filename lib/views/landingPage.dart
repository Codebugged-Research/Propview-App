import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:propview/services/reminderService.dart';
import 'package:propview/views/Home/homeScreen.dart';
import 'package:propview/views/Profile/ProfileScreen.dart';
import 'package:propview/views/TaskManager/taskManagerHome.dart';

class LandingScreen extends StatefulWidget {
  final int selectedIndex;
  LandingScreen({this.selectedIndex});
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    ReminderService reminderService;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content:
            Text("A new task Has been Assigned to you by the admin."),
            title: Text("Alert"),
          ));
      // if (message.data != null) {
      //   print('Message also contained a notification: ${message.notification}');
      //   reminderService.sheduledNotification(
      //       message.data['startTime'], message.data['endTime']);
      // }
    });
    _selectedIndex = widget.selectedIndex;
  }

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    TaskMangerHome(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
                  icon: Icons.house_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.work,
                  text: 'Task',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
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
