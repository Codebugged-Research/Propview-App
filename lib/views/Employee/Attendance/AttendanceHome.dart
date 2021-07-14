import 'dart:convert';

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/config.dart';
import 'package:propview/models/Attendance.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/attendanceService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Employee/Attendance/LogCard.dart';
import 'package:propview/views/Employee/Attendance/SoloAttendanceScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome();

  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  Attendance attendance;
  bool loading = false;
  User user;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    attendance = await AttendanceService.getAllUserIdWithoutDate(user.userId);
    print(attendance.count);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("punch");
    if (json != null) {
      Map decodedJson = jsonDecode(json);
      if(decodedJson["out"] == "--/--/-- -- : --"){
        setState(() {
          label = "Punch Out";
        });
      }
    }
    setState(() {
      loading = false;
    });
  }

  String label = "Punch In";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: loading
          ? circularProgressWidget()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 50, 12, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 25,
                              child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                  height: 50,
                                  width: 50,
                                  placeholder: "assets/loader.gif",
                                  fit: BoxFit.cover,
                                  image:
                                      "${Config.STORAGE_ENDPOINT}${user.userId}.jpeg",
                                  imageErrorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                        "assets/dummy.png",
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Employee",
                                   style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle2
                            .copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/immigration.png",
                                height: 50,
                              ),
                              Text(
                               label,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SoloAttendanceScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Attendance Logs',
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: attendance.count == 0
                        ? Center(
                            child: Text(
                              'No Logs!',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .subtitle1
                                  .copyWith(
                                      color: Color(0xff314B8C),
                                      fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 0),
                            itemCount: attendance.count,
                            itemBuilder: (context, index) {
                              return LogCard(
                                attendanceElement:
                                    attendance.data.attendance[index],
                              );
                            },
                          ),
                  )
                ],
              ),
            ),
    );
  }
}
