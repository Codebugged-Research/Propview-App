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
import 'package:propview/views/Manager/landingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class SoloAttendance extends StatefulWidget {
  final AttendanceElement attendanceElement;

  const SoloAttendance({this.attendanceElement});

  @override
  _SoloAttendanceState createState() => _SoloAttendanceState();
}

class _SoloAttendanceState extends State<SoloAttendance> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool loading = false;
  User user;
  AttendanceElement attendanceElement;
  Position position;

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getData() async {
    setState(() {
      loading = true;
    });
    await getLocation();
    user = await UserService.getUser();
    if (widget.attendanceElement != null) {
      attendanceElement = await AttendanceService.getLogById(
          widget.attendanceElement.attendanceId);
    }
    getPunch();
    setState(() {
      loading = false;
    });
  }

  getPunch() async {
    setState(() {
      loading = true;
    });
    if (widget.attendanceElement != null) {
      setState(() {
        start = attendanceElement.punchIn.toString();
        end = attendanceElement.punchOut == Config.dummyTime
            ? "--/--/-- -- : --"
            : attendanceElement.punchOut.toString();
        startMeter = attendanceElement.meterIn;
        endMeter = attendanceElement.punchOut == Config.dummyTime
            ? 0
            : attendanceElement.meterOut;
        reset = attendanceElement.punchOut == Config.dummyTime ? false : true;
        id = attendanceElement.attendanceId.toString();
      });
    }
    setState(() {
      loading = false;
    });
  }

  updateLog() async {
    if (position != null) {
      showInSnackBar(
        context,
        "Please turn on your location! Try again.",
        1500,
      );
    } else {
      DateTime startTime = DateTime.parse(start);
      DateTime endTime = DateTime.parse(end);
      AttendanceElement tempAttendance;
      if (id != "-") {
        tempAttendance = await AttendanceService.getLogById(id);
        print(tempAttendance.toJson());
        tempAttendance.geo_out =
            position.latitude.toString() + "," + position.longitude.toString();
        tempAttendance.meterOut = user.bikeReading == 1 ? endMeter : 0;
        tempAttendance.punchOut = endTime;
        tempAttendance.workHour = endTime.difference(startTime).inHours;
        tempAttendance.diff_km =
            user.bikeReading == 1 ? endMeter - startMeter : 0;
      }
      var result =
          await AttendanceService.updateLog(tempAttendance.toJson(), id);
      if (result && id != "-") {
        showInSnackBar(
          context,
          "Attendance updated successfully",
          1500,
        );
      } else {
        showInSnackBar(
          context,
          "Attendance updation failed",
          1500,
        );
      }
    }
  }

  createLog() async {
    if (position == null) {
      showInSnackBar(
        context,
        "Please turn on your location! Try again.",
        1500,
      );
    } else {
      var payload = {
        "user_id": user.userId,
        "parent_id": user.parentId,
        "punch_in": start,
        "punch_out": end,
        "meter_in": user.bikeReading == 1 ? startMeter : 0,
        "meter_out": user.bikeReading == 1 ? endMeter : 0,
        "work_hour": 0,
        "date": dateFormatter(),
        "name": user.name,
        "email": user.officialEmail,
        "diff_km": 0,
        "geo_in":
            position.latitude.toString() + "," + position.longitude.toString(),
        "geo_out": 0,
      };
      var result = await AttendanceService.createLog(payload);
      if (result != false) {
        setState(() {
          id = result.toString();
        });
        showInSnackBar(
          context,
          "Attendance added successfully",
          1500,
        );
      } else {
        showInSnackBar(
          context,
          "Attendance failed",
          1500,
        );
      }
    }
  }

  String start = "--/--/-- -- : --";
  String end = "--/--/-- -- : --";
  int startMeter = 0;
  int endMeter = 0;
  String id = "-";

  TextEditingController _startMeterController = TextEditingController();
  TextEditingController _endMeterController = TextEditingController();

  bool reset = false;

  dateFormatter() {
    var date = DateTime.now();
    return '${date.day.toString().padLeft(2, "0")}-${date.month.toString().padLeft(2, "0")}-${DateTime.now().year}';
  }

  dateTimeFormatter(String dat) {
    DateTime date = DateTime.parse(dat);
    return '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${DateTime.now().year}  ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}';
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
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LandingScreen(
                                  selectedIndex: 2,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 16,
                        ),
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
                  ),
                  Expanded(
                    child: Image.asset("assets/attendance.png"),
                    flex: 3,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 32,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Punch In",
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      start == "--/--/-- -- : --"
                                          ? start
                                          : dateTimeFormatter(start),
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: start == "--/--/-- -- : --"
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    user.bikeReading == 1
                                        ? Text(
                                            "Reading In",
                                            style: GoogleFonts.nunito(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Container(),
                                    user.bikeReading == 1
                                        ? Text(
                                            startMeter.toString(),
                                            style: GoogleFonts.nunito(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: startMeter == 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Punch Out",
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      end == "--/--/-- -- : --"
                                          ? end
                                          : dateTimeFormatter(end),
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: end == "--/--/-- -- : --"
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    user.bikeReading == 1
                                        ? Text(
                                            "Reading Out",
                                            style: GoogleFonts.nunito(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )
                                        : Container(),
                                    user.bikeReading == 1
                                        ? Text(
                                            endMeter.toString(),
                                            style: GoogleFonts.nunito(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: endMeter == 0
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          end == "--/--/-- -- : --"
                              ? MaterialButton(
                                  onPressed: user.bikeReading == 1
                                      ? () {
                                          if (start == "--/--/-- -- : --") {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Do you want to punch in now?"),
                                                actions: [
                                                  MaterialButton(
                                                    child: Text("Punch In"),
                                                    onPressed: punchInMeter,
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Do you want to punch out now?"),
                                                actions: [
                                                  MaterialButton(
                                                    child: Text("Punch Out"),
                                                    onPressed: punchOurMeter,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      : () {
                                          if (start == "--/--/-- -- : --") {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Do you want to punch in now?"),
                                                actions: [
                                                  MaterialButton(
                                                    child: Text("Punch In"),
                                                    onPressed: punchin,
                                                  )
                                                ],
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Do you want to punch out now?"),
                                                actions: [
                                                  MaterialButton(
                                                    child: Text("Punch Out"),
                                                    onPressed: punchout,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                  color: start == "--/--/-- -- : --"
                                      ? Colors.white
                                      : Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8),
                                    child: Text(
                                      start == "--/--/-- -- : --"
                                          ? "Punch In"
                                          : "Punch Out",
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: start == "--/--/-- -- : --"
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          reset
                              ? MaterialButton(
                                  onPressed: user.bikeReading == 1
                                      ? () async {
                                          setState(() {
                                            start = "--/--/-- -- : --";
                                            end = "--/--/-- -- : --";
                                            startMeter = 0;
                                            endMeter = 0;
                                            id = "-";
                                            reset = false;
                                          });
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setString(
                                            "punch",
                                            jsonEncode(
                                              {
                                                "in": start,
                                                "out": end,
                                                "inMeter": startMeter,
                                                "outMeter": endMeter,
                                                "reset": reset,
                                                "id": id
                                              },
                                            ),
                                          );
                                          if (start == "--/--/-- -- : --") {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Do you want to punch in now?"),
                                                actions: [
                                                  MaterialButton(
                                                    child: Text("Punch In"),
                                                    onPressed: punchInMeter,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      : () async {
                                          setState(() {
                                            start = "--/--/-- -- : --";
                                            end = "--/--/-- -- : --";
                                            startMeter = 0;
                                            endMeter = 0;
                                            id = "-";
                                            reset = false;
                                          });
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setString(
                                            "punch",
                                            jsonEncode(
                                              {
                                                "in": start,
                                                "out": end,
                                                "inMeter": startMeter,
                                                "outMeter": endMeter,
                                                "reset": reset,
                                                "id": id
                                              },
                                            ),
                                          );
                                          if (start == "--/--/-- -- : --") {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: Text(
                                                    "Do you want to punch in now?"),
                                                actions: [
                                                  MaterialButton(
                                                    child: Text("Punch In"),
                                                    onPressed: punchin,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8),
                                    child: Text(
                                      "Punch In",
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    flex: 3,
                  )
                ],
              ),
            ),
    );
  }

  punchOurMeter() {
    _endMeterController.clear();
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            title: Text("Enter punch out meter reading :",
                style: GoogleFonts.nunito(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xff314B8C).withOpacity(0.12),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 16, color: Colors.black),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.list_alt,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  setState(() {
                    endMeter = int.parse(_endMeterController.text);
                  });
                },
                controller: _endMeterController,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: _endMeterController.text.isNotEmpty &&
                        (startMeter <= endMeter)
                    ? () {
                        setState(
                          () {
                            end = DateTime.now().toString();
                            endMeter = int.parse(_endMeterController.text);
                            reset = true;
                            updateLog();
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    : () {
                        setState(() {
                          endMeter = 0;
                          reset = true;
                        });
                        Navigator.of(context).pop();
                        showInSnackBar(context,
                            "Enter valid meter input to punch out", 1800);
                      },
                child: Text(
                  "Punch Out",
                  style: GoogleFonts.nunito(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  punchInMeter() {
    _startMeterController.clear();
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
            ),
            title: Text("Enter punch in meter reading :",
                style: GoogleFonts.nunito(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xff314B8C).withOpacity(0.12),
              ),
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 16, color: Colors.black),
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.list_alt,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
                onChanged: (value) {
                  setState(() {
                    startMeter = int.parse(_startMeterController.text);
                  });
                },
                controller: _startMeterController,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: _startMeterController.text.isNotEmpty
                    ? () {
                        setState(
                          () {
                            start = DateTime.now().toString();
                            startMeter = int.parse(_startMeterController.text);
                            createLog();
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    : () {
                        showInSnackBar(
                            context, "Enter valid meter input to start", 1500);
                      },
                child: Text(
                  "Punch In",
                  style: GoogleFonts.nunito(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  punchin() {
    setState(() {
      start = DateTime.now().toString();
    });
    createLog();
    Navigator.of(context).pop();
  }

  punchout() {
    setState(() {
      end = DateTime.now().toString();
      reset = true;
    });
    updateLog();
    Navigator.of(context).pop();
  }
}
