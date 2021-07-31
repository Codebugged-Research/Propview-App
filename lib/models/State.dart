// To parse this JSON data, do
//
//     final state = stateFromJson(jsonString);

import 'dart:convert';

List<CStates> stateFromJson(String str) => List<CStates>.from(json.decode(str).map((x) => CStates.fromJson(x)));

String stateToJson(List<CStates> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CStates {
    CStates({
        this.sid,
        this.cid,
        this.sname,
        this.scode,
        this.scodeGst,
        this.stateIcon,
        this.status,
    });

    int sid;
    int cid;
    String sname;
    String scode;
    String scodeGst;
    String stateIcon;
    int status;

    factory CStates.fromJson(Map<String, dynamic> json) => CStates(
        sid: json["sid"] == null ? null : json["sid"],
        cid: json["cid"] == null ? null : json["cid"],
        sname: json["sname"] == null ? null : json["sname"],
        scode: json["scode"] == null ? null : json["scode"],
        scodeGst: json["scode_gst"] == null ? null : json["scode_gst"],
        stateIcon: json["state_icon"] == null ? null : json["state_icon"],
        status: json["status"] == null ? null : json["status"],
    );

    Map<String, dynamic> toJson() => {
        "sid": sid == null ? null : sid,
        "cid": cid == null ? null : cid,
        "sname": sname == null ? null : sname,
        "scode": scode == null ? null : scode,
        "scode_gst": scodeGst == null ? null : scodeGst,
        "state_icon": stateIcon == null ? null : stateIcon,
        "status": status == null ? null : status,
    };
}
