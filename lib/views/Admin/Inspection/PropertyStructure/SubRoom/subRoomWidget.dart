import 'package:flutter/material.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/SubRoom/AddSubRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/propertyFunctions.dart';

class SubRoomWidget extends StatefulWidget {
  final List<SubRoom> subRooms;
  final List<Facility> facilities;
  final PropertyElement propertyElement;
  SubRoomWidget({this.subRooms, this.facilities, this.propertyElement});
  @override
  _SubRoomWidgetState createState() => _SubRoomWidgetState();
}

class _SubRoomWidgetState extends State<SubRoomWidget> {
  
  List<SubRoom> subRooms = [];
  List<Facility> facilities = [];
  List<String> facilitiesName = [];

  PropertyElement propertyElement;

  @override
  void initState() {
    super.initState();
    subRooms = widget.subRooms;
    facilities = widget.facilities;
    propertyElement = widget.propertyElement;
    facilitiesName = PropertyFunctions.getFacilityName(facilities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: subRooms.length == 0
            ? Center(
                child: Text('No Sub-Rooms are available!',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle1
                        .copyWith(color: Colors.black)))
            : Text('Sub Rooms are there'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routing.makeRouting(context,
              routeMethod: 'push', newWidget: AddSubRoomScreen(
                propertyElement: propertyElement,
                facilities: facilities,
                imageList: [],
                facilitiesName: facilitiesName,
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
