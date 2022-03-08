import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/models/RegularInspectionRow.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/regulationInspectionRowService.dart';
import 'package:propview/services/regulationInspectionService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/inspectionWebView2.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config.dart';

class RegularInspectionDetailsScreen extends StatefulWidget {
  final RegularInspection regularInspection;

  RegularInspectionDetailsScreen({this.regularInspection});

  @override
  _RegularInspectionDetailsScreenState createState() =>
      _RegularInspectionDetailsScreenState();
}

class _RegularInspectionDetailsScreenState
    extends State<RegularInspectionDetailsScreen> {
  bool isLoading = false;

  RegularInspection regularInspection;
  User user;
  PropertyElement propertyElement;
  List<RegularInspectionRow> regularInspectionRowList = [];

  @override
  void initState() {
    super.initState();
    regularInspection = widget.regularInspection;
    loadDataForScreen();
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    user =
        await UserService.getUserById(regularInspection.employeeId.toString());
    propertyElement = await PropertyService.getPropertyById(
        regularInspection.propertyId.toString());
    List rowList = regularInspection.rowList.split(",").toList();
    if (regularInspection.rowList != "") {
      for (int i = 0; i < rowList.length; i++) {
        regularInspectionRowList.add(
            await RegularInspectionRowService.getRegularInspectionRowById(
                rowList[i]));
      }
    } else {
      regularInspectionRowList = [];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Regular Inspection Details",
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("View PDF"),
                  value: 1,
                ),
              ],
              onSelected: (value) async {
                if (value == 1) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => InspectionWebView2(
                        url:
                            "https://api.propdial.co.in/pdf/regular/${regularInspection.id}",
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: isLoading
            ? circularProgressWidget()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Regular Inspection\n",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                                text: "History",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.normal))
                          ])),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      // titleWidget(context, 'Inspection Type'),
                      // subHeadingWidget(context, 'Regular Inspection'),
                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Property ID'),
                      subHeadingWidget(
                          context, '${regularInspection.propertyId}'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Property Name'),
                      subHeadingWidget(context,
                          '${propertyElement.tblSociety.socname} ,  ${propertyElement.tableproperty.unitNo}'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Created By'),
                      subHeadingWidget(context, '${user.name}'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return inspectionCard(index);
                        },
                        itemCount: regularInspectionRowList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  Widget inspectionCard(int tableindex) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleWidget(
              context, regularInspectionRowList[tableindex].roomsubroomName),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 350,
            child: inspectionRowCard(tableindex),
          ),
        ],
      ),
    );
  }

  inspectionRowCard(int index) {
    return ListView(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15)),
                BoxShadow(
                    offset: Offset(-2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Termite Issue:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  enabled: false,
                  minLines: 14,
                  maxLines: 15,
                  initialValue: regularInspectionRowList[index].termiteCheck,
                  decoration: decoration,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15)),
                BoxShadow(
                    offset: Offset(-2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15))
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Seepage Check:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  enabled: false,
                  minLines: 14,
                  maxLines: 15,
                  initialValue: regularInspectionRowList[index].seepageCheck,
                  decoration: decoration,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15)),
                BoxShadow(
                    offset: Offset(-2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15))
              ],
            ),
            child: Column(
              children: [
                Text(
                  'General Cleanliness:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  enabled: false,
                  minLines: 14,
                  maxLines: 15,
                  initialValue:
                      regularInspectionRowList[index].generalCleanliness,
                  decoration: decoration,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15)),
                BoxShadow(
                    offset: Offset(-2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15))
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Other Issues:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  enabled: false,
                  minLines: 14,
                  maxLines: 15,
                  initialValue: regularInspectionRowList[index].otherIssue,
                  decoration: decoration,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15)),
                BoxShadow(
                    offset: Offset(-2, 2),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.15))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Photo:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                photoPick(regularInspectionRowList[index].photo),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget photoPick(
    List<String> list,
  ) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      insetPadding: EdgeInsets.zero,
                      title: Text('Photo : ${list[index].trim()}'),
                      content: Image.network(
                        Config.INSPECTION_STORAGE_ENDPOINT + list[index].trim(),
                      ),
                      actions: [
                        MaterialButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: Image.network(
                Config.INSPECTION_STORAGE_ENDPOINT + list[index].trim(),
                height: 60,
                width: 45,
              ),
            );
          },
        ),
      ),
    );
  }

  InputDecoration decoration = InputDecoration(
    filled: true,
    hintText: 'Enter review',
    fillColor: Colors.grey[300],
    labelStyle: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12.0)),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12.0)),
  );

  Widget titleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .headline6
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }

  Widget subHeadingWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
    );
  }
}
