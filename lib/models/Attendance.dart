// To parse this JSON data, do
//
//     final attendance = attendanceFromJson(jsonString);

import 'dart:convert';

import 'User.dart';

Attendance attendanceFromJson(String str) => Attendance.fromJson(json.decode(str));

String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
    Attendance({
        this.count,
        this.data,
    });

    int count;
    Data data;

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        count: json["count"] == null ? null : json["count"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "count": count == null ? null : count,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    Data({
        this.attendance,
    });

    List<AttendanceElement> attendance;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        attendance: json["attendance"] == null ? null : List<AttendanceElement>.from(json["attendance"].map((x) => AttendanceElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "attendance": attendance == null ? null : List<dynamic>.from(attendance.map((x) => x.toJson())),
    };
}

class AttendanceElement {
    AttendanceElement({
        this.attendanceId,
        this.userId,
        this.parentId,
        this.punchIn,
        this.punchOut,
        this.meterIn,
        this.meterOut,
        this.workHour,
        this.date,
        this.tblUsers,
    });

    int attendanceId;
    String userId;
    String parentId;
    DateTime punchIn;
    DateTime punchOut;
    String meterIn;
    String meterOut;
    String workHour;
    String date;
    User tblUsers;

    factory AttendanceElement.fromJson(Map<String, dynamic> json) => AttendanceElement(
        attendanceId: json["attendance_id"] == null ? null : json["attendance_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        punchIn: json["punch_in"] == null ? null : DateTime.parse(json["punch_in"]),
        punchOut: json["punch_out"] == "--/--/-- -- : --" ? DateTime.now() : DateTime.parse(json["punch_out"]),
        meterIn: json["meter_in"] == null ? null : json["meter_in"],
        meterOut: json["meter_out"] == null ? null : json["meter_out"],
        workHour: json["work_hour"] == null ? null : json["work_hour"],
        date: json["date"] == null ? null : json["date"],
        tblUsers: json["tbl_users"] == null ? null : User.fromJson(json["tbl_users"]),
    );

    Map<String, dynamic> toJson() => {
        "attendance_id": attendanceId == null ? null : attendanceId,
        "user_id": userId == null ? null : userId,
        "parent_id": parentId == null ? null : parentId,
        "punch_in": punchIn == null ? null : punchIn.toIso8601String(),
        "punch_out": punchOut == null ? null : punchOut.toIso8601String(),
        "meter_in": meterIn == null ? null : meterIn,
        "meter_out": meterOut == null ? null : meterOut,
        "work_hour": workHour == null ? null : workHour,
        "date": date == null ? null : date,
    };
}
