import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome();

  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  @override
  void initState() {
    // TODO: implement initState
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
    setState(() {
      loading = false;
    });
  }

  getPunch() {}

  savePunch() {}

  String start = "--/--/-- -- : --";
  String end = "--/--/-- -- : --";
  String startMeter = "-- : --";
  String endMeter = "-- : --";

  bool reset = false;

  dateTimeFormatter(String dat) {
    DateTime date = DateTime.parse(dat);
    return '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${DateTime.now().year}  ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: loading
          ? circularProgressWidget()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 50, 12, 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 35,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/loader.gif",
                            image:
                                "https://propview.sgp1.digitaloceanspaces.com/User/${user.userId}.png",
                            imageErrorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 35,
                                backgroundImage: AssetImage(
                                  "assets/dummy.png",
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Employee",
                        style: GoogleFonts.nunito(
                          color: Color(0xffB2B2B2),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                                        onTap: () {
                                          setState(() {
                                            start = "--/--/-- -- : --";
                                            end = "--/--/-- -- : --";
                                            startMeter = "-- : --";
                                            endMeter = "-- : --";
                                            reset = false;
                                          });
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
                                              Icons.replay,
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
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
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
                                      "Meter In",
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
                                        color: startMeter == ""
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
                                      "Meter Out",
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
                                        color: endMeter == "-- : --"
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
                            onPressed: () {
                              if (start == "--/--/-- -- : --") {
                                setState(() {
                                  reset = true;
                                  start = DateTime.now().toString();
                                });
                              } else {
                                setState(() {
                                  end = DateTime.now().toString();
                                });
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
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ):Container(),
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
}
