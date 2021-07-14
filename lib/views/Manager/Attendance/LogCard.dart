import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/config.dart';
import 'package:propview/models/Attendance.dart';

class LogCard extends StatefulWidget {
  final AttendanceElement attendanceElement;
  const LogCard({this.attendanceElement});

  @override
  _LogCardState createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  dateTimeFormatter(String dat) {
    DateTime date = DateTime.parse(dat);
    return '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${DateTime.now().year}  ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(0.0, 0.0),
                blurRadius: 2.5,
                spreadRadius: 0.0,
              ),
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(0.0, 0.0),
                blurRadius: 2.5,
                spreadRadius: 0.0,
              ),
            ]),
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: ClipOval(
                  child: FadeInImage.assetNetwork(
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    placeholder: "assets/loader.gif",
                    image:
                        "${Config.STORAGE_ENDPOINT}${widget.attendanceElement.tblUsers.userId}.png",
                    imageErrorBuilder: (BuildContext context, Object exception,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                    context,
                    "Name: ",
                    widget.attendanceElement.tblUsers.name,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                        context,
                        "In Time: ",
                        dateTimeFormatter(
                            widget.attendanceElement.punchIn.toString()),
                      ),
                      textWidget(
                          context,
                          "Out Time: ",
                          dateTimeFormatter(
                              widget.attendanceElement.punchOut.toString())),
                    ],
                  ),
                  Row(
                    children: [
                      textWidget(
                        context,
                        "Meter In: ",
                        widget.attendanceElement.meterIn,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      textWidget(
                        context,
                        "Meter Out: ",
                        widget.attendanceElement.meterOut,
                      ),
                    ],
                  ),
                  textWidget(
                    context,
                    "Work Hours: ",
                    widget.attendanceElement.workHour,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textWidget(BuildContext context, String label, String data) {
    return RichText(
      text: TextSpan(
        text: label,
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: data,
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
