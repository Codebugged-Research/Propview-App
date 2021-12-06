import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/services/regulationInspectionService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/widgets/regularInspectionCard.dart';

class RegularInspectionHistoryScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  RegularInspectionHistoryScreen({this.propertyElement});

  @override
  _RegularInspectionHistoryScreenState createState() =>
      _RegularInspectionHistoryScreenState();
}

class _RegularInspectionHistoryScreenState
    extends State<RegularInspectionHistoryScreen> {
  PropertyElement propertyElement;
  List<RegularInspection> regularInspection;

  bool isLoading = false;

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
    regularInspection =
        await RegularInspectionService.getRegularInspectionByPropertyId(
            propertyElement.tableproperty.propertyId.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Regular Inspection History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? circularProgressWidget()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: regularInspection.isEmpty
                  ? Center(
                      child: Text(
                        'No Regular Inspection Found!!',
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
                      itemCount: regularInspection.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RegularInspectionCard(
                          regularInspection: regularInspection[index],
                          propertyElement: propertyElement,
                        );
                      })),
    );
  }
}
