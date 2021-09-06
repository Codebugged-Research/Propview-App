import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/Types/issueInspectionScreen.dart';
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
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => IssueInspectionScreen(
                  propertyElement: propertyElement,
                ),
            settings: RouteSettings()),
      );
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => IssueInspectionScreen(
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
