import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/MoveOutInspection/moveOutInspectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoveOutInspectionLoaderScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  MoveOutInspectionLoaderScreen({this.propertyElement});

  @override
  _MoveOutInspectionLoaderScreenState createState() =>
      _MoveOutInspectionLoaderScreenState();
}

class _MoveOutInspectionLoaderScreenState
    extends State<MoveOutInspectionLoaderScreen> {
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
          .getString("moveout-${propertyElement.tableproperty.propertyId}");
      print(data);
      if (data == null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MoveOutInspectionScreen(
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
            List<String> photos = [];
            tempData["rows"][i][j]['photo'].forEach((e) {
              photos.add(e);
            });
            rows[i].add(
              Issue(
                issueName: tempData["rows"][i][j]['issue_name'],
                status: tempData["rows"][i][j]['status'],
                remarks: tempData["rows"][i][j]['remarks'],
                photo: photos,
              ),
            );
          }
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MoveOutInspectionScreen(
              propertyElement: propertyElement,
              newBillAmounts: tempData["newBillAmounts"]
                  .map<double>((bill) => double.parse(bill.toString()))
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
          builder: (context) => MoveOutInspectionScreen(
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
