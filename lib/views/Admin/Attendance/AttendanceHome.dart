import 'package:collection/collection.dart';
import "package:flutter/material.dart";
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:propview/config.dart';
import 'package:propview/models/Attendance.dart';
import 'package:propview/models/City.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/attd.dart';
import 'package:propview/services/attendanceService.dart';
import 'package:propview/services/cityService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/Attendance/AttendanceCard.dart';
import 'package:propview/views/Admin/Attendance/LogCard.dart';
import 'package:propview/views/Admin/Attendance/SoloAttendance.dart';
import 'package:propview/views/Admin/Profile/ProfileScreen.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome();

  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool loading = false;
  User user;
  int index = 0;
  List<User> userList = [];
  TabController _tabController;
  Attendance attendance;
  Attendance attendance2;
  Attendance attendanceToday;
  List bools = [];
  List<City> cities = [];
  Map gg;

  AttendanceElement myAttendance;

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    userList = await UserService.getAllUser();
    attendance = await AttendanceService.getAllWithoutDate(0, 1000);
    attendanceToday = await AttendanceService.getAllWithDate(dateFormatter());
    cities = await CityService.getCities();
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
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    var today = attendanceToday.data.attendance
        .where((element) => element.userId == user.userId.toString())
        .toList();
    if (today.length > 0) {
      myAttendance = today.last;
      if (myAttendance.punchOut == Config.dummyTime) {
        setState(() {
          label = "Punch Out";
        });
      }
    }
    setState(() {
      attendance2 = attendance;
      loading = false;
    });
  }

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

  dateFormatter2(dat) {
    var date = DateTime.parse(dat);
    return '${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${DateTime.now().year}';
  }

  String start = "";
  String end = "";

  TextEditingController _searchController = TextEditingController();
  bool serachLoading = false;

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
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(),
                                    ),
                                  );
                                },
                                child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    height: 50,
                                    width: 50,
                                    placeholder: "assets/loader.gif",
                                    fit: BoxFit.cover,
                                    image:
                                        "${Config.STORAGE_ENDPOINT}${user.userId}.jpeg",
                                    imageErrorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
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
                                    user.name.split(" ").first,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Admin/Super Admin",
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
                            if (myAttendance != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SoloAttendance(
                                    attendanceElement: myAttendance,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SoloAttendance(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                        setState(() {
                          index = value;
                        });
                        _tabController.animateTo(
                          value,
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 600),
                        );
                      },
                    ),
                  ),
                  index == 1
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16, top: 8, bottom: 6),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 75,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xff314B8C).withOpacity(0.12),
                                  ),
                                  child: TypeAheadFormField(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      controller: this._searchController,
                                    ),
                                    suggestionsCallback: (pattern) {
                                      List<User> matches = [];
                                      matches.addAll(userList);
                                      matches.retainWhere((s) => s.name
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                      return matches;
                                    },
                                    itemBuilder: (context, User suggestion) {
                                      return ListTile(
                                        title: Text(suggestion.name),
                                        subtitle:
                                            Text(suggestion.officialEmail),
                                      );
                                    },
                                    noItemsFoundBuilder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Type to find User !',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                      );
                                    },
                                    transitionBuilder:
                                        (context, suggestionsBox, controller) {
                                      return suggestionsBox;
                                    },
                                    onSuggestionSelected: (suggestion) async {
                                      setState(() {
                                        serachLoading = true;
                                        _searchController.text =
                                            suggestion.name;
                                      });
                                      List<AttendanceElement> temp = attendance
                                          .data.attendance
                                          .where((element) {
                                        return element.name
                                            .toLowerCase()
                                            .contains(
                                                suggestion.name.toLowerCase());
                                      }).toList();
                                      attendance2.data.attendance = temp;
                                      attendance2.count = temp.length;
                                      if (temp.length == 0) {
                                        showInSnackBar(
                                            context,
                                            "No attendance log found in database !",
                                            2500);
                                      } else {
                                        showInSnackBar(
                                            context,
                                            "${temp.length} logs found in database !",
                                            2500);
                                      }
                                      setState(() {
                                        start = "";
                                        end = "";
                                        serachLoading = false;
                                      });
                                    },
                                    validator: (value) => value.isEmpty
                                        ? 'Please select an Owner Name'
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Icon(Icons.clear),
                              onTap: () async {
                                serachLoading = true;
                                start = "";
                                end = "";
                                attendance =
                                    await AttendanceService.getAllWithoutDate(
                                        0, 1000);
                                attendance2.count = attendance.count;
                                attendance2.data.attendance =
                                    attendance.data.attendance;
                                setState(() {
                                  _searchController.clear();
                                  serachLoading = false;
                                });
                              },
                            ),
                          ],
                        )
                      : Container(),
                  _searchController.text != ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: start == ""
                                      ? DateTime.now()
                                      : DateTime.parse(start),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime(2055),
                                );
                                if (start == "") {
                                  setState(() {
                                    start = picked.toString();
                                    end = DateTime.now().toString();
                                  });
                                } else if (picked != null &&
                                    picked != DateTime.parse(start))
                                  setState(() {
                                    start = picked.toString();
                                  });
                                List<AttendanceElement> temp =
                                    attendance.data.attendance.where((element) {
                                  return element.punchIn.isAfter(
                                        DateTime.parse(start),
                                      ) &&
                                      element.punchIn.isBefore(
                                        DateTime.parse(end),
                                      ) &&
                                      element.name.toLowerCase().contains(
                                            _searchController.text
                                                .toLowerCase(),
                                          );
                                }).toList();
                                setState(() {
                                  attendance2.data.attendance = temp;
                                  attendance2.count = temp.length;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today),
                                  Text(
                                    start == ""
                                        ? "Starting"
                                        : dateFormatter2(
                                            start,
                                          ),
                                  )
                                ],
                              ),
                            ),
                            Text("To"),
                            MaterialButton(
                              onPressed: () async {
                                final DateTime picked = await showDatePicker(
                                  context: context,
                                  initialDate: end == ""
                                      ? DateTime.now()
                                      : DateTime.parse(end),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime(2055),
                                );
                                if (end == "") {
                                  setState(() {
                                    end = picked.toString();
                                  });
                                } else if (picked != null &&
                                    picked != DateTime.parse(end)) {
                                  setState(() {
                                    end = picked.toString();
                                  });
                                }
                                List<AttendanceElement> temp =
                                    attendance.data.attendance.where((element) {
                                  return element.punchIn.isAfter(
                                        DateTime.parse(start),
                                      ) &&
                                      element.punchIn.isAtSameMomentAs(
                                        DateTime.parse(end),
                                      ) &&
                                      element.name.toLowerCase().contains(
                                            _searchController.text
                                                .toLowerCase(),
                                          );
                                }).toList();
                                setState(() {
                                  attendance2.data.attendance = temp;
                                  attendance2.count = temp.length;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today),
                                  Text(
                                    end == ""
                                        ? "Till Date"
                                        : dateFormatter2(
                                            end,
                                          ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : SizedBox(),
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
                                          : gg.entries.skip(index).first.key,
                                    ),
                                    children: _buildExpandableContent(
                                        gg.entries.skip(index).first.value),
                                  );
                                },
                              ),
                        serachLoading
                            ? circularProgressWidget()
                            : attendance2.count == 0
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
                                    itemCount: attendance2.count,
                                    itemBuilder: (context, index) {
                                      return LogCard(
                                        attendanceElement:
                                            attendance2.data.attendance[index],
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
        cities: cities,
        attd: Attd(
          isPresent: users[i].present,
          user: users[i],
        ),
      ));
    return columnContent;
  }
}
