import 'package:flutter/material.dart';
import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/services/inspectionService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/widgets/inspectionCard.dart';

class InspectionHistoryScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  InspectionHistoryScreen({this.propertyElement});
  @override
  _InspectionHistoryScreenState createState() =>
      _InspectionHistoryScreenState();
}

class _InspectionHistoryScreenState extends State<InspectionHistoryScreen> {
  bool isLoading = false;

  PropertyElement propertyElement;
  List<Inspection> inspections = [];

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    loadDataForScreen();
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    inspections = await InspectionService.getInspectionByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Inspection History'),
        ),
        body: isLoading
            ? circularProgressWidget()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: inspections.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InspectionCard();
                    })));
  }
}
