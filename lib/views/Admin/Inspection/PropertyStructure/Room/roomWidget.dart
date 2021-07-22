import 'package:flutter/material.dart';

import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/Room/AddRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/propertyFunctions.dart';

class RoomWidget extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<Room> rooms;
  final List<Facility> facilities;
  RoomWidget({this.rooms, this.facilities, this.propertyElement});
  @override
  _RoomWidgetState createState() => _RoomWidgetState();
}

class _RoomWidgetState extends State<RoomWidget> {
  bool isBath = false;
  bool isBalcony = false;
  bool isWardrobe = false;

  String facilityDropDownValue;
  String marbelTypeDropDownValue;

  List<Room> rooms = [];
  List<Facility> facilities = [];
  List<String> facilitiesName = [];
  List<String> flooringType = [];

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
    facilitiesName = PropertyFunctions.getFacilityName(facilities);
    flooringType = PropertyFunctions.getFlooringType();
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
            : Text('Rooms are there!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routing.makeRouting(context,
              routeMethod: 'push',
              newWidget: AddRoomScreen(
                propertyElement: propertyElement,
                facilities: facilities,
                imageList: [],
                facilitiesName: facilitiesName,
                flooringType: flooringType,
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget inputWidget(
      TextEditingController textEditingController,
      String validation,
      bool isVisible,
      String label,
      String hint,
      save,
      StateSetter stateSetter) {
    return TextFormField(
      style: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 15.0, color: Color(0xff9FA0AD)),
        labelStyle: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff314B8C)),
            borderRadius: BorderRadius.circular(12.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff314B8C)),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff314B8C)),
            borderRadius: BorderRadius.circular(12.0)),
      ),
      obscureText: isVisible,
      validator: (value) => value.isEmpty ? validation : null,
      onSaved: save,
    );
  }
}
