import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/config.dart';
import 'package:propview/models/City.dart';
import 'package:propview/models/attd.dart';
import 'package:url_launcher/url_launcher.dart';

class AttendanceCard extends StatefulWidget {
  final Attd attd;
  final List<City> cities;

  const AttendanceCard({this.attd, this.cities});

  @override
  _AttendanceCardState createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  @override
  void initState() {
    super.initState();
    getCityName();
  }

  List<String> cityList = [];

  getCityName() {
    cityList.clear();
    if (widget.attd.user.department == "Operations") {
      List city = widget.attd.user.city.split(",");
      for (int i = 0; i < city.length; i++) {
        cityList.add(widget.cities
            .where((element) => element.ccid.toString() == city[i])
            .first
            .ccname);
      }
    }
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                        placeholder: "assets/loader.gif",
                        image:
                            "${Config.STORAGE_ENDPOINT}${widget.attd.user.userId}.jpeg",
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            backgroundImage: AssetImage(
                              "assets/dummy.png",
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.attd.user.name,
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        widget.attd.user.department == "Operations"
                            ? Flexible(
                                child: Text(
                                  cityList.join(","),
                                  softWrap: true,
                                  style: GoogleFonts.nunito(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_people,
                    color: widget.attd.isPresent
                        ? Colors.black
                        : Colors.grey.shade300,
                  ),
                  VerticalDivider(),
                  InkWell(
                    child: Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                    onTap: () async {
                      if (await canLaunch(
                          "tel:+91 ${widget.attd.user.officialNumber}")) {
                        await launch(
                            "tel:+91 ${widget.attd.user.officialNumber}");
                      } else {
                        throw "tel:+91 ${widget.attd.user.officialNumber}";
                      }
                    },
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
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
