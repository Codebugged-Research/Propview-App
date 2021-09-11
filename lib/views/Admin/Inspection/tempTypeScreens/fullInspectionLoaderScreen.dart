import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/Types/fullInspectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullInspectionLoaderScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  FullInspectionLoaderScreen({this.propertyElement});

  @override
  _FullInspectionLoaderScreenState createState() =>
      _FullInspectionLoaderScreenState();
}

class _FullInspectionLoaderScreenState
    extends State<FullInspectionLoaderScreen> {
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
      data =
          prefs.getString("full-${propertyElement.tableproperty.propertyId}");
      print(data);
      if (data == null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullInspectionScreen(
              propertyElement: propertyElement,
            ),
          ),
        );
        print("use cache Data but no --------------------------");
      } else {
        var tempData = jsonDecode(data);
        List<List<Issue>> rows = [];
        for (int i = 0; i < tempData["rows"].length; i++) {
          rows.add([]);
          for (int j = 0; j < tempData["rows"][i].length; j++) {
            rows[j].add(
              Issue(
                issueName: tempData["rows"][i][j]['issue_name'],
                status: tempData["rows"][i][j]['status'],
                remarks: tempData["rows"][i][j]['remarks'],
                photo: tempData["rows"][i][j]['photo'].cast<String>()
              )
            );
          }
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullInspectionScreen(
              propertyElement: propertyElement,
              bills: tempData["bills"]
                  .map<BillToProperty>((bill) => BillToProperty.fromJson(bill))
                  .toList(),
              rows: rows,
              issueTableList: tempData["issueTableList"]
                  .map<IssueTableData>(
                      (issueTableMap) => IssueTableData.fromJson(issueTableMap))
                  .toList(),
            ),
          ),
        );
        print("use cache Data --------------------------");
      }
    } catch (e) {
      print(e);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FullInspectionScreen(
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
