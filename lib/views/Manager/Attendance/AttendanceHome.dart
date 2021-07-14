import 'dart:convert';

import 'package:collection/collection.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/config.dart';
import 'package:propview/models/Attendance.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/attd.dart';
import 'package:propview/services/attendanceService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Manager/Attendance/AttendanceCard.dart';
import 'package:propview/views/Manager/Attendance/LogCard.dart';
import 'package:propview/views/Manager/Attendance/SoloAttendance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome();

  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool loading = false;
  User user;
  List<User> userList = [];
  TabController _tabController;
  Attendance attendance;
  Attendance attendanceToday;
  List bools = [];

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    userList = await UserService.getAllUserUnderManger(user.userId);
    attendance =
        await AttendanceService.getAllByMangerIdWithoutDate(user.userId);
    attendanceToday = await AttendanceService.getAllByMangerIdWithDate(
        user.userId, dateFormatter());
    Attendance myAttendance =
        await AttendanceService.getAllUserIdWithoutDate(user.userId);
    print(myAttendance.data.attendance.length);
    for (int i = 0; i < userList.length; i++) {
      if (attendanceToday.data.attendance
              .where((element) =>
                  element.userId == userList[i].userId.toString() &&
                  element.isPresent)
              .length >
          0) {
        userList[i].present = true;
      } else {
        userList[i].present = false;
      }
    }
    gg = genGrouping();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("punch");
    if (json != null) {
      Map decodedJson = jsonDecode(json);
      if (decodedJson["out"] == "--/--/-- -- : --") {
        setState(() {
          label = "Punch Out";
        });
      }
    }
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    setState(() {
      attendance.count += myAttendance.count;
      attendance.data.attendance.addAll(myAttendance.data.attendance);
      loading = false;
    });
  }

  Map gg;

  genGrouping() {
    final groups = groupBy(userList, (User e) {
      return e.department;
    });
    return groups;
  }

  String label = "Punch In";

  dateFormatter() {
    var date = DateTime.now();
    return '${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${DateTime.now().year}';
  }

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
                mainAxisAlignment: MainAxisAlignment.start,
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
                              radius: 30,
                              child: ClipOval(
                                child: FadeInImage.assetNetwork(
                                  height: 60,
                                  width: 60,
                                  placeholder: "assets/loader.gif",
                                  fit: BoxFit.cover,
                                  image:
                                      "${Config.STORAGE_ENDPOINT}${user.userId}.jpeg",
                                  imageErrorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 30,
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
                                  "Manager",
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
                                builder: (context) => SoloAttendance(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TabBar(
                      isScrollable: true,
                      controller: _tabController,
                      indicator: UnderlineTabIndicator(
                        borderSide:
                            BorderSide(color: Color(0xff314B8C), width: 4.0),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff314B8C),
                      ),
                      unselectedLabelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.black.withOpacity(0.4),
                      labelColor: Color(0xff314B8C),
                      tabs: [
                        Tab(text: "Attendance"),
                        Tab(text: "Logs"),
                      ],
                      onTap: (value) {
                        _tabController.animateTo(
                          value,
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 600),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: <Widget>[
                        userList.length == 0
                            ? Center(
                                child: Text(
                                  'No Employees!',
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
                                itemCount: gg.entries.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    title: Text(
                                        gg.entries.skip(index).first.key == ""
                                            ? "Other"
                                            : gg.entries.skip(index).first.key),
                                    children: _buildExpandableContent(
                                        gg.entries.skip(index).first.value),
                                  );
                                },
                              ),
                        attendance.count == 0
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _buildExpandableContent(List<User> users) {
    List<Widget> columnContent = [];
    for (int i = 0; i < users.length; i++)
      columnContent.add(AttendanceCard(
        attd: Attd(
          isPresent: users[i].present,
          user: users[i],
        ),
      ));
    return columnContent;
  }
}
