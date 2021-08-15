// To parse this JSON data, do
//
//     final city = cityFromJson(jsonString);

import 'dart:convert';

List<City> cityFromJson(String str) =>
    List<City>.from(json.decode(str).map((x) => City.fromJson(x)));

String cityToJson(List<City> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class City {
  City({
    this.ccid,
    this.cid,
    this.sid,
    this.ccname,
    this.ccSlug,
    this.ccDesc,
    this.ccImage,
    this.cityIcon,
    this.status,
    this.metaTitle,
    this.metaKeyword,
    this.metaDescription,
    this.totalp,
    this.totals,
  });

  int ccid;
  int cid;
  int sid;
  String ccname;
  String ccSlug;
  String ccDesc;
  String ccImage;
  String cityIcon;
  int status;
  String metaTitle;
  String metaKeyword;
  String metaDescription;
  int totalp;
  int totals;

  factory City.fromJson(Map<String, dynamic> json) => City(
        ccid: json["ccid"] == null ? null : json["ccid"],
        cid: json["cid"] == null ? null : json["cid"],
        sid: json["sid"] == null ? null : json["sid"],
        ccname: json["ccname"] == null ? null : json["ccname"],
        ccSlug: json["cc_slug"] == null ? null : json["cc_slug"],
        ccDesc: json["cc_desc"] == null ? null : json["cc_desc"],
        ccImage: json["cc_image"] == null ? null : json["cc_image"],
        cityIcon: json["city_icon"] == null ? null : json["city_icon"],
        status: json["status"] == null ? null : json["status"],
        metaTitle: json["meta_title"] == null ? null : json["meta_title"],
        metaKeyword: json["meta_keyword"] == null ? null : json["meta_keyword"],
        metaDescription:
            json["meta_description"] == null ? null : json["meta_description"],
        totalp: json["totalp"] == null ? null : json["totalp"],
        totals: json["totals"] == null ? null : json["totals"],
      );

  Map<String, dynamic> toJson() => {
        "ccid": ccid == null ? null : ccid,
        "cid": cid == null ? null : cid,
        "sid": sid == null ? null : sid,
        "ccname": ccname == null ? null : ccname,
        "cc_slug": ccSlug == null ? null : ccSlug,
        "cc_desc": ccDesc == null ? null : ccDesc,
        "cc_image": ccImage == null ? null : ccImage,
        "city_icon": cityIcon == null ? null : cityIcon,
        "status": status == null ? null : status,
        "meta_title": metaTitle == null ? null : metaTitle,
        "meta_keyword": metaKeyword == null ? null : metaKeyword,
        "meta_description": metaDescription == null ? null : metaDescription,
        "totalp": totalp == null ? null : totalp,
        "totals": totals == null ? null : totals,
      };
}
