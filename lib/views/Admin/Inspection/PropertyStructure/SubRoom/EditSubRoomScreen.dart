import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/roomType.dart';

class EditSubRoomScreen extends StatefulWidget {
  final SubRoomElement subRoom;
  final PropertyElement propertyElement;
  final List<PropertyRoom> roomTypes;

  EditSubRoomScreen({this.subRoom, this.propertyElement, this.roomTypes});

  @override
  _EditSubRoomScreenState createState() => _EditSubRoomScreenState();
}

class _EditSubRoomScreenState extends State<EditSubRoomScreen> {
  SubRoomElement subRoom;
  PropertyElement propertyElement;
  List<PropertyRoom> roomTypes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subRoom = widget.subRoom;
    propertyElement = widget.propertyElement;
    roomTypes = widget.roomTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Sub-Room'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [Text('Edit Sub-Room'), Text('${subRoom.subRoomId}')],
        ),
      ),
    );
  }
}
