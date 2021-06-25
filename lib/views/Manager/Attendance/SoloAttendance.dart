import 'dart:convert';

import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Attendance.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/attendanceService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoloAttendance extends StatefulWidget {
  const SoloAttendance();

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

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    getPunch();
    setState(() {
      loading = false;
    });
  }

  getPunch() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString("punch");
    if (json != null) {
      Map decodedJson = jsonDecode(json);
      setState(() {
        start = decodedJson["in"];
        end = decodedJson["out"];
        startMeter = decodedJson["inMeter"];
        endMeter = decodedJson["outMeter"];
        reset = decodedJson["reset"];
        id = decodedJson["id"] == null ? "-" : decodedJson["id"];
      });
    }
    print(id);
    setState(() {
      loading = false;
    });
  }

  savePunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
  }

  updateLog() async {
    print(start);
    print(end);
    DateTime startTime = DateTime.parse(start);
    DateTime endTime = DateTime.parse(end);
    AttendanceElement tempAttendance;
    if (id != "-") {
      tempAttendance = await AttendanceService.getLogById(id);
      print(tempAttendance.toJson());
      tempAttendance.meterOut = user.bikeReading == 1 ? endMeter : "-";
      tempAttendance.punchOut = endTime;
      tempAttendance.workHour =
          endTime.difference(startTime).inHours.toString();
    }
    var result = await AttendanceService.updateLog(
        tempAttendance.toJson(), id);
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

  createLog() async {
    // DateTime startTime = DateTime.parse(start);
    // DateTime endTime = DateTime.parse(end);
    // var payload = {
    // "user_id": user.userId,
    // "parent_id": user.parentId,
    // "punch_in": start,
    // "punch_out": end,
    // "meter_in": user.bikeReading == 1 ? startMeter : "-",
    // "meter_out": user.bikeReading == 1 ? endMeter : "-",
    // "work_hour": endTime.difference(startTime).inHours.toString(),
    // "date": dateFormatter()
    // };
    var payload = {
      "user_id": user.userId,
      "parent_id": user.parentId,
      "punch_in": start,
      "punch_out": end,
      "meter_in": user.bikeReading == 1 ? startMeter : "-",
      "meter_out": user.bikeReading == 1 ? endMeter : "-",
      "work_hour": 0,
      "date": dateFormatter()
    };
    var result = await AttendanceService.createLog(payload);
    if (result != false) {
      setState(() {
        id = result.toString();
      });
      savePunch();
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

  String start = "--/--/-- -- : --";
  String end = "--/--/-- -- : --";
  String startMeter = "-";
  String endMeter = "-";
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
                                  "https://propview.sgp1.digitaloceanspaces.com/User/${user.userId}.png",
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                reset
                                    ? InkWell(
                                        onTap: () async {
                                          setState(() {
                                            start = "--/--/-- -- : --";
                                            end = "--/--/-- -- : --";
                                            startMeter = "-";
                                            endMeter = "-";
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
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.add,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
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
                                    Text(
                                      "Reading In",
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      startMeter,
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: startMeter == "-"
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
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
                                    Text(
                                      "Reading Out",
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      endMeter,
                                      style: GoogleFonts.nunito(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: endMeter == "-"
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
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
                                  color: Colors.white,
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
                    endMeter = _endMeterController.text;
                  });
                },
                controller: _endMeterController,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: _endMeterController.text.isNotEmpty &&
                        (int.parse(startMeter) <= int.parse(endMeter))
                    ? () {
                        setState(
                          () {
                            end = DateTime.now().toString();
                            endMeter = double.parse(_endMeterController.text)
                                .toInt()
                                .toString();
                            reset = true;
                            savePunch();
                            updateLog();
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    : () {
                        setState(() {
                          endMeter = "-";
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
                    startMeter = _startMeterController.text;
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
                            startMeter =
                                double.parse(_startMeterController.text)
                                    .toInt()
                                    .toString();
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
    savePunch();
    updateLog();
    Navigator.of(context).pop();
  }
}