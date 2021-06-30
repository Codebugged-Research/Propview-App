import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Attendance.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/attd.dart';
import 'package:propview/services/attendanceService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Manager/Attendance/AttendanceCard.dart';
import 'package:propview/views/Manager/Attendance/LogCard.dart';
import 'package:propview/views/Manager/Attendance/SoloAttendance.dart';

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
              .where(
                  (element) => element.userId == userList[i].userId.toString())
              .length >
          0) {
        bools.add(true);
      } else {
        bools.add(false);
      }
    }
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    setState(() {
      attendance.count += myAttendance.count;
      attendance.data.attendance.addAll(myAttendance.data.attendance);
      loading = false;
    });
  }

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
                                      "https://propview.sgp1.digitaloceanspaces.com/User/${user.userId}.jpeg",
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
                                  style: GoogleFonts.nunito(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Manager",
                                  style: GoogleFonts.nunito(
                                    color: Color(0xffB2B2B2),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                "Punch In",
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
                                itemCount: userList.length,
                                itemBuilder: (context, index) {
                                  return AttendanceCard(
                                    attd: Attd(
                                      isPresent: bools[index],
                                      user: userList[index],
                                    ),
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
}
