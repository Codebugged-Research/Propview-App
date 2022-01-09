import 'package:flutter/material.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportAttendance extends StatefulWidget {
  const ExportAttendance();

  @override
  _ExportAttendanceState createState() => _ExportAttendanceState();
}

class _ExportAttendanceState extends State<ExportAttendance> {
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Export Attendance',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
            ),
            CircleAvatar(
              radius: 72,
              backgroundColor: Color(0xff314B8C).withOpacity(0.8),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xff314B8C).withOpacity(0.5),
                child: Icon(
                  Icons.import_export,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: Color(0xff314B8C),
                  onPressed: () async {
                    start = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime.now(),
                    );
                    setState(() {});
                  },
                  child: Text(
                    "Choose Start Date",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  color: Color(0xff314B8C),
                  onPressed: () async {
                    end = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime.now(),
                    );
                    setState(() {});
                  },
                  child: Text(
                    "Choose End Date",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(start.day.toString() +
                    "/" +
                    start.month.toString() +
                    "/" +
                    start.year.toString()),
                Text(end.day.toString() +
                    "/" +
                    end.month.toString() +
                    "/" +
                    end.year.toString()),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              height: 50,
              minWidth: 180,
              color: Color(0xff314B8C),
              onPressed: () async {
                if (start.isAfter(end)) {
                  showInSnackBar(context, "Invalid Date Range", 1400);
                } else {
                  String start_date = start.year.toString() +
                      "-" +
                      start.month.toString().padLeft(2, "0") +
                      "-" +
                      start.day.toString().padLeft(2, "0");
                  String end_date = end.year.toString() +
                      "-" +
                      end.month.toString().padLeft(2, "0") +
                      "-" +
                      end.day.toString().padLeft(2, "0");
                  print(
                      "https://api.propdial.co.in/api/attendanceexport/${start_date}/${end_date}/attendance_${start_date}_${end_date}");
                  launch(
                      "https://api.propdial.co.in/api/attendanceexport/${start_date}/${end_date}/attendance_${start_date}_${end_date}");
                }
              },
              child: Text(
                "Export Attendance",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
