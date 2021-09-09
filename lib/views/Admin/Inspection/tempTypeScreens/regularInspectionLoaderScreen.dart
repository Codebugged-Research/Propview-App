import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/Types/regularInspectionScreen.dart';
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
      // data = prefs
      //     .getString("regular-${propertyElement.tableproperty.propertyId}");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegularInspectionScreen(
            propertyElement: propertyElement,
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegularInspectionScreen(
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
