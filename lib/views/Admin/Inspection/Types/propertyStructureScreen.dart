import 'package:flutter/material.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/services/facilityService.dart';
import 'package:propview/utils/progressBar.dart';

class PropertyStructureScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  PropertyStructureScreen({this.propertyElement});
  @override
  _PropertyStructureScreenState createState() =>
      _PropertyStructureScreenState();
}

class _PropertyStructureScreenState extends State<PropertyStructureScreen> {
  bool isLoading = false;

  PropertyElement propertyElement;
  List<Facility> facilities = [];

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    facilities = await FacilityService.getFacilities();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? circularProgressWidget()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Property\n",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                                text: "Structure",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.normal))
                          ]))
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
