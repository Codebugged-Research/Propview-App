import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/inspectionHistoryScreen.dart';
import 'package:propview/views/Admin/Inspection/regularInspectionHistoryScreen.dart';

class HistoryScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  HistoryScreen({this.propertyElement});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;

  TabController tabController;
  PropertyElement propertyElement;

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    tabController = TabController(length: 2, vsync: this);
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection History'),
        elevation: 4.0,
        bottom: TabBar(
            controller: tabController,
            indicatorColor: Color(0xff314B8C),
            labelStyle: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            unselectedLabelStyle: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: 'Inspection'),
              Tab(text: 'Regular Inspection'),
            ]),
      ),
      body: isLoading
          ? circularProgressWidget()
          : TabBarView(
              controller: tabController,
              children: [
                InspectionHistoryScreen(
                  propertyElement: propertyElement,
                ),
                RegularInspectionHistoryScreen(
                  propertyElement: propertyElement,
                )
              ],
            ),
    );
  }
}
