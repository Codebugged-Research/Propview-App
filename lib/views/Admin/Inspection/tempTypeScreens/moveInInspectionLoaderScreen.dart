import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
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
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MoveInInspectionScreen(
                  propertyElement: propertyElement,
                ),
            settings: RouteSettings()),
      );
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
