import 'package:flutter/material.dart';

import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/services/facilityService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/roomWidget.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/subRoomWidget.dart';
import 'package:propview/views/Admin/widgets/propertyStructureAlertWidget.dart';

class PropertyStructureScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<String> imageList;
  PropertyStructureScreen({this.propertyElement, this.imageList});
  @override
  _PropertyStructureScreenState createState() =>
      _PropertyStructureScreenState();
}

class _PropertyStructureScreenState extends State<PropertyStructureScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;

  PropertyElement propertyElement;
  List<Facility> facilities = [];

  List<Room> rooms = [];
  List<SubRoom> subRooms = [];

  TabController tabController;

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    tabController = TabController(length: 2, vsync: this);
    loadData();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    facilities = await FacilityService.getFacilities();
    print(facilities.length);
    rooms = await RoomService.getRoomByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    if (rooms.length != 0) {
      subRooms = await SubRoomService.getSubRoomByPropertyId(
          propertyElement.tableproperty.propertyId.toString());
      showDialog(
          context: context,
          builder: (_) {
            return PropertyStructureAlertWidget(
              title: 'Property Structure already defined!',
              body: 'Do you want to edit the Property Structure?',
            );
          });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Property Structure'),
          bottom: TabBar(
              controller: tabController,
              indicatorColor: Color(0xff314B8C),
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              unselectedLabelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: 'Rooms'),
                Tab(text: 'Sub Rooms'),
              ]),
        ),
        body: isLoading
            ? circularProgressWidget()
            : TabBarView(controller: tabController, children: [
                RoomWidget(
                  rooms: rooms,
                  facilities: facilities,
                  imageList: widget.imageList,
                ),
                SubRoomWidget(
                  subRooms: subRooms,
                  facilities: facilities,
                  imageList: widget.imageList,
                ),
              ]));
  }
}
