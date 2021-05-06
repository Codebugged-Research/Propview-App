import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/views/Notification/notificationScreen.dart';

class TaskMangerHome extends StatefulWidget {
  @override
  _TaskMangerHomeState createState() => _TaskMangerHomeState();
}

class _TaskMangerHomeState extends State<TaskMangerHome> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  User user;
  bool loading = false;

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListTile(
                        leading: Image.asset("assets/dummy.png"),
                        title: Text(
                          user.name,
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          user.userType,
                          style: GoogleFonts.nunito(
                            color: Color(0xffB2B2B2),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => NotificationScreen()));
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[200],
                                    offset: const Offset(
                                      0.0,
                                      0.0,
                                    ),
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                  ),
                                ]),
                            child: Icon(
                              Icons.notifications_none_outlined,
                              color: Color(0xff314B8C),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.red,
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(color: Colors.orange),
                      flex: 9,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
