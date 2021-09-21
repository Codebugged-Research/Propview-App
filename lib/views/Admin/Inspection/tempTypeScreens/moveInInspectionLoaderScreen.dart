import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/Types/moveInInspectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoveInInspectionLoaderScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  MoveInInspectionLoaderScreen({this.propertyElement});

  @override
  _MoveInInspectionLoaderScreenState createState() =>
      _MoveInInspectionLoaderScreenState();
}

class _MoveInInspectionLoaderScreenState
    extends State<MoveInInspectionLoaderScreen> {
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
          prefs.getString("movein-${propertyElement.tableproperty.propertyId}");
      if (data == null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MoveInInspectionScreen(
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
            rows[j].add(Issue(
                issueName: tempData["rows"][i][j]['issue_name'],
                status: tempData["rows"][i][j]['status'],
                remarks: tempData["rows"][i][j]['remarks'],
                photo: tempData["rows"][i][j]['photo'].cast<String>()));
          }
        }
        print(rows);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MoveInInspectionScreen(
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MoveInInspectionScreen(
            propertyElement: propertyElement,
          ),
        ),
      );
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
