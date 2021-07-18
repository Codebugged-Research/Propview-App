import 'package:flutter/material.dart';
import 'package:propview/models/Room.dart';

class RoomWidget extends StatefulWidget {
  final List<Room> rooms;
  RoomWidget({this.rooms});
  @override
  _RoomWidgetState createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  List<Room> rooms = [];

  @override
  void initState() {
    super.initState();
    rooms = widget.rooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Hi");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
