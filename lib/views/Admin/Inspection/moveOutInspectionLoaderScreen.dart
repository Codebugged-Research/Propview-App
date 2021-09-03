import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoveOutInspectionLoaderScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  MoveOutInspectionLoaderScreen({this.propertyElement});
  @override
  _MoveOutInspectionLoaderScreenState createState() => _MoveOutInspectionLoaderScreenState();
}

class _MoveOutInspectionLoaderScreenState extends State<MoveOutInspectionLoaderScreen> {

  bool isLoading = false;
  SharedPreferences prefs;
  PropertyElement propertyElement;

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    initialiseSharedPreference();
    loadDataForScreen();
  }

  initialiseSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    var data =
    prefs.getString("moveout-${propertyElement.tableproperty.propertyId}");
    print(data);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isLoading
              ? circularProgressWidget()
              : Routing.makeRouting(context,
              routeMethod: 'push',
              newWidget: MoveOutInspectionLoaderScreen(
                propertyElement: propertyElement,
              ))),
    );
  }
}
