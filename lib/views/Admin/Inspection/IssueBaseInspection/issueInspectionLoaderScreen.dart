import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/IssueBaseInspection/issueInspectionScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssueInspectionLoaderScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  IssueInspectionLoaderScreen({this.propertyElement});

  @override
  _IssueInspectionLoaderScreenState createState() =>
      _IssueInspectionLoaderScreenState();
}

class _IssueInspectionLoaderScreenState
    extends State<IssueInspectionLoaderScreen> {
  bool isLoading = false;
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
          prefs.getString("issue-${propertyElement.tableproperty.propertyId}");
      if (data == null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IssueInspectionScreen(
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
            builder: (context) => IssueInspectionScreen(
              propertyElement: propertyElement,
              rows: rows,
              summary: tempData["summary"],
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
          builder: (context) => IssueInspectionScreen(
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
