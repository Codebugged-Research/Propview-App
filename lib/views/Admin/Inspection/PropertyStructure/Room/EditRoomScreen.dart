import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/roomType.dart';

class EditRoomScreen extends StatefulWidget {
  final RoomsToPropertyModel room;
  final PropertyElement propertyElement;
  final List<PropertyRoom> roomTypes;

  EditRoomScreen({this.room, this.propertyElement, this.roomTypes});

  @override
  _EditRoomScreenState createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  RoomsToPropertyModel room;
  PropertyElement propertyElement;
  List<PropertyRoom> roomTypes;

  @override
  void initState() {
    super.initState();
    room = widget.room;
    propertyElement = widget.propertyElement;
    roomTypes = widget.roomTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Room'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [Text('Edit Room'), Text('${room.roomId}')],
        ),
      ),
    );
  }
}
