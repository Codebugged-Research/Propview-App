import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspectionRow.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/FullInspection/fullInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/RegularInspection/regularInspectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegularInspectionLoaderScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  RegularInspectionLoaderScreen({this.propertyElement});

  @override
  _RegularInspectionLoaderScreenState createState() =>
      _RegularInspectionLoaderScreenState();
}

class _RegularInspectionLoaderScreenState
    extends State<RegularInspectionLoaderScreen> {
  SharedPreferences prefs;
  PropertyElement propertyElement;

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    loadDataForScreen();
  }

  var data;

  loadDataForScreen() async {
    prefs = await SharedPreferences.getInstance();
    try {
      data = prefs
          .getString("regular-${propertyElement.tableproperty.propertyId}");
      if (data == null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegularInspectionScreen(
              propertyElement: propertyElement,
            ),
          ),
        );
        print("use cache Data but not found --------------------------");
      } else {
        var tempData = jsonDecode(data);
        List<RegularInspectionRow> rows = [];
        for (int i = 0; i < tempData["regularInspectionRowList"].length; i++) {
          List<String> photos = [];
          tempData["regularInspectionRowList"][i]['photo'].forEach((e) {
            photos.add(e);
          });
          rows.add(
            RegularInspectionRow(
              termiteCheck: tempData["regularInspectionRowList"][i]
                  ['termite_check'],
              seepageCheck: tempData["regularInspectionRowList"][i]
                  ['seepage_check'],
              generalCleanliness: tempData["regularInspectionRowList"][i]
                  ['general_cleanliness'],
              otherIssue: tempData["regularInspectionRowList"][i]['other_issue'],
              photo: photos,
              issub: tempData["regularInspectionRowList"][i]['issub'],
              roomsubroomId: tempData["regularInspectionRowList"][i]
                  ['roomsubroom_id'],
              roomsubroomName: tempData["regularInspectionRowList"][i]
                  ['roomsubroom_name'],
            ),
          );
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegularInspectionScreen(
              propertyElement: propertyElement,
              summary: tempData["summary"] ?? "",
              newBillAmounts: tempData["newBillAmounts"]
                  .map<double>((bill) => double.parse(bill.toString()))
                  .toList(),
              regularInspectionRowList: rows,
            ),
          ),
        );
        print("use cache Data --------------------------");
      }
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegularInspectionScreen(
            propertyElement: propertyElement,
          ),
        ),
      );
      print("use no Data --------------------------");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: circularProgressWidget(),
      ),
    );
  }
}
