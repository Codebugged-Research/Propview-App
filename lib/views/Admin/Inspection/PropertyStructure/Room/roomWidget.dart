import 'package:flutter/material.dart';

import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/Room/AddRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/Room/EditRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/propertyFunctions.dart';
import 'package:propview/views/Admin/widgets/roomCard.dart';

class RoomWidget extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<RoomsToPropertyModel> rooms;
  final List<Facility> facilities;
  final List<PropertyRoom> roomTypes;

  RoomWidget(
      {this.rooms, this.facilities, this.propertyElement, this.roomTypes});

  @override
  _RoomWidgetState createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  String facilityDropDownValue;
  String marbelTypeDropDownValue;

  List<RoomsToPropertyModel> rooms = [];
  List<Facility> facilities = [];
  List<String> flooringType = [];
  List<PropertyRoom> roomTypes = [];

  PropertyElement propertyElement;

  final formkey = new GlobalKey<FormState>();

  TextEditingController roomSizeOneController = new TextEditingController();
  TextEditingController roomSizeTwoController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    rooms = widget.rooms;
    facilities = widget.facilities;
    propertyElement = widget.propertyElement;
    flooringType = PropertyFunctions.getFlooringType();
    roomTypes = widget.roomTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: rooms.length == 0
              ? Center(
                  child: Text('No Rooms are available!',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(color: Colors.black)))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: rooms.length,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        await Routing.makeRouting(context,
                            routeMethod: 'push',
                            newWidget: EditRoomScreen(
                              room: rooms[index],
                              propertyElement: propertyElement,
                              roomTypes: roomTypes,
                            ));
                      },
                      child: RoomCard(
                        room: rooms[index],
                        propertyElement: propertyElement,
                        roomTypes: roomTypes,
                      ),
                    );
                  })),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routing.makeRouting(context,
              routeMethod: 'push',
              newWidget: AddRoomScreen(
                propertyElement: propertyElement,
                facilities: facilities,
                imageList: [],
                flooringType: flooringType,
                roomList: widget.roomTypes,
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
