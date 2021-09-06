import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/Types/fullInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/Types/moveOutInspectionScreen.dart';
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
      data =
          prefs.getString("moveout-${propertyElement.tableproperty.propertyId}");
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MoveOutInspectionScreen(
                  propertyElement: propertyElement,
                ),
            settings: RouteSettings()),
      );
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MoveOutInspectionScreen(
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
