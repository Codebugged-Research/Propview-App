import 'package:flutter/material.dart';
import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/services/inspectionService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/widgets/inspectionCard.dart';

class MoveInInspectionHistoryScreen extends StatefulWidget {
  MoveInInspectionHistoryScreen({this.propertyElement});

  final PropertyElement propertyElement;

  @override
  _MoveInInspectionHistoryScreenState createState() =>
      _MoveInInspectionHistoryScreenState();
}

class _MoveInInspectionHistoryScreenState
    extends State<MoveInInspectionHistoryScreen> {
  List<Inspection> inspections = [];
  bool isLoading = false;
  PropertyElement propertyElement;

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
    inspections = await InspectionService.getInspectionByPropertyIdAndType(
        propertyElement.tableproperty.propertyId.toString(), "Move in Inspection");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Move In Inspection History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? circularProgressWidget()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: inspections.isEmpty
                  ? Center(
                      child: Text(
                        'No Inspection Found!!',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle1
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: inspections.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InspectionCard(
                          inspection: inspections[index],
                          propertyElement: propertyElement,
                        );
                      },
                    ),
            ),
    );
  }
}
