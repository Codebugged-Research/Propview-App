import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Attendance.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/attendanceService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Employee/Attendance/LogCard.dart';

class SoloAttendanceScreen extends StatefulWidget {
  final User user;
  const SoloAttendanceScreen({this.user});

  @override
  _SoloAttendanceScreenState createState() => _SoloAttendanceScreenState();
}

class _SoloAttendanceScreenState extends State<SoloAttendanceScreen> {
  Attendance attendance;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    attendance =
        await AttendanceService.getAllUserIdWithoutDate(widget.user.userId);
    print(attendance.count);
    setState(() {
      loading = false;
    });
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
                                      "https://propview.sgp1.digitaloceanspaces.com/User/${widget.user.userId}.png",
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
                                  widget.user.name,
                                  style: GoogleFonts.nunito(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Employee",
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
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
                  Expanded(child: attendance.count == 0
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
                        ),)
                ],
              ),
            ),
    );
  }
}
