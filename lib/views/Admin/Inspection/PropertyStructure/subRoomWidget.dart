import 'package:flutter/material.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Subroom.dart';

class SubRoomWidget extends StatefulWidget {
  final List<SubRoom> subRooms;
  final List<Facility> facilities;
  final List<String> imageList;
  SubRoomWidget({this.subRooms, this.facilities, this.imageList});
  @override
  _SubRoomWidgetState createState() => _SubRoomWidgetState();
}

class _SubRoomWidgetState extends State<SubRoomWidget> {
  List<SubRoom> subRooms = [];
  List<Facility> facilities = [];
  List<String> imageList;

  @override
  void initState() {
    super.initState();
    subRooms = widget.subRooms;
    facilities = widget.facilities;
    imageList = widget.imageList;
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
          print("Nice");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
