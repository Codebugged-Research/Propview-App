import 'package:flutter/material.dart';
import 'package:propview/models/Subroom.dart';

class SubRoomWidget extends StatefulWidget {
  final List<SubRoom> subRooms;
  SubRoomWidget({this.subRooms});
  @override
  _SubRoomWidgetState createState() => _SubRoomWidgetState();
}

class _SubRoomWidgetState extends State<SubRoomWidget> {
  List<SubRoom> subRooms = [];

  @override
  void initState() {
    super.initState();
    subRooms = widget.subRooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: subRooms.length == 0 ? Center(child: Text('No Sub-Rooms are available!')): Text(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Nice");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
