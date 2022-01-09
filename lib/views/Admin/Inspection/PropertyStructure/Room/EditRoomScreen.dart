import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/constants/uiConstants.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/facilityService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/propertyFunctions.dart';

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

  bool isBath = false;
  bool isBalcony = false;
  bool isWardrobe = false;

  Facility facilityDropDownValue;
  String marbelTypeDropDownValue;
  PropertyRoom roomTypeDropDownValue;

  List<bool> _floorSelections = List.generate(3, (_) => false);
  List<bool> _roomSelection = List.generate(3, (_) => false);

  List<Facility> facilities = [];
  List<Facility> facilities2 = [];
  List<Facility> facilityTag = [];
  List<String> flooringType = [];

  final formkey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = true;

  getData() async {
    setState(() {
      isLoading = true;
    });
    flooringType = PropertyFunctions.getFlooringType();
    // facilities = await FacilityService.getFacilities();
    room = widget.room;
    roomTypes = widget.roomTypes;
    roomTypeDropDownValue =
        roomTypes.firstWhere((element) => element.roomId == room.roomId);
    facilities2 = await FacilityService.getFacilities();
    facilities2.forEach((element) {
      if (element.roomId
          .split(",")
          .contains(roomTypeDropDownValue.roomId.toString())) {
        facilities.add(element);
      }
    });
    propertyElement = widget.propertyElement;
    roomLengthFeetController.text = (room.roomSize1.toInt()).toString();
    roomLengthInchesController.text =
        (((room.roomSize1 * 10) % 10) * 1.2).toInt().toString();
    roomWidthFeetController.text = (room.roomSize2.toInt()).toString();
    roomWidthInchesController.text =
        (((room.roomSize2 * 10) % 10) * 1.2).toInt().toString();
    room.bath == 1 ? _roomSelection[0] = true : _roomSelection[0] = false;
    room.balcony == 1 ? _roomSelection[1] = true : _roomSelection[1] = false;
    room.wardrobe == 1 ? _roomSelection[2] = true : _roomSelection[2] = false;
    _floorSelections[
        flooringType.indexWhere((element) => element == room.flooring)] = true;
    print(room.facility.split(","));
    room.facility.split(",").forEach((element) {
      if (facilities
          .map((e) => e.facilityId.toString())
          .toList()
          .contains(element)) {
        facilityTag.add(
            facilities.firstWhere((e) => e.facilityId.toString() == element));
      }
    });
    facilityDropDownValue =
        facilities.firstWhere((element) => element.facilityId == 84);
    setState(() {
      isLoading = false;
    });
  }

  addTag(Facility tag) {
    setState(() {
      facilityTag.add(tag);
    });
  }

  TextEditingController roomLengthFeetController =
      new TextEditingController(text: "0");
  TextEditingController roomLengthInchesController =
      new TextEditingController(text: "0");
  TextEditingController roomWidthFeetController =
      new TextEditingController(text: "0");
  TextEditingController roomWidthInchesController =
      new TextEditingController(text: "0");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit the  Room Details',
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: circularProgressWidget(),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: UIConstants.fitToHeight(4, context)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Container(
                          child: Form(
                            key: formkey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(16, context)),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Room Type',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  value: roomTypeDropDownValue,
                                  elevation: 8,
                                  underline: Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width,
                                    color: Color(0xff314B8C),
                                  ),
                                  onChanged: (value) {
                                    facilities.clear();
                                    facilityTag.clear();
                                    facilities2.forEach((element) {
                                      if (element.roomId
                                          .split(",")
                                          .contains(value.roomId.toString())) {
                                        facilities.add(element);
                                      }
                                    });
                                    facilityDropDownValue = facilities[0];
                                    setState(() {
                                      roomTypeDropDownValue = value;
                                    });
                                  },
                                  items:
                                      roomTypes.map<DropdownMenuItem>((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.roomName),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(16, context)),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Room Length',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700))),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(4, context)),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: inputWidget(
                                          roomLengthFeetController,
                                          'Please enter Room Length!',
                                          false,
                                          'Room Length',
                                          'Room Length',
                                          'ft', (value) {
                                        print(value);
                                      }),
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      flex: 1,
                                      child: inputWidget(
                                          roomLengthInchesController,
                                          'Please enter Room Length',
                                          false,
                                          'Room Length',
                                          'Room Length',
                                          'inches', (value) {
                                        print(value);
                                      }),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(8, context)),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Room Breadth',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700))),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(4, context)),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: inputWidget(
                                          roomWidthFeetController,
                                          'Please enter Room Breadth!',
                                          false,
                                          'Room Breadth',
                                          'Room Breadth',
                                          'ft', (value) {
                                        print(value);
                                      }),
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      flex: 1,
                                      child: inputWidget(
                                          roomWidthInchesController,
                                          'Please enter Room Breadth!',
                                          false,
                                          'Room Breadth',
                                          'Room Breadth',
                                          'inches', (value) {
                                        print(value);
                                      }),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(16, context)),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Attached Room',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(16, context)),
                                ToggleButtons(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Bathroom'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Balcony'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Wardrobe'),
                                    )
                                  ],
                                  isSelected: _roomSelection,
                                  onPressed: (int index) {
                                    setState(() {
                                      _roomSelection[index] =
                                          !_roomSelection[index];
                                    });
                                  },
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(8, context)),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Flooring Type',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(16, context)),
                                ToggleButtons(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Vitrified Tiles'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Marble'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Wooden'),
                                    )
                                  ],
                                  isSelected: _floorSelections,
                                  onPressed: (int index) {
                                    _floorSelections =
                                        List.generate(3, (_) => false);
                                    setState(() {
                                      _floorSelections[index] =
                                          !_floorSelections[index];
                                    });
                                  },
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(8, context)),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Articles',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  value: facilityDropDownValue,
                                  elevation: 8,
                                  underline: Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width,
                                    color: Color(0xff314B8C),
                                  ),
                                  onChanged: (value) {
                                    if (value.facilityId == 84) {
                                      setState(() {
                                        facilityDropDownValue = value;
                                      });
                                      showInSnackBar(context,
                                          "Please Choose a valid article", 800);
                                    } else {
                                      setState(() {
                                        addTag(value);
                                        facilityDropDownValue = value;
                                        facilityTag.sort((a, b) => a
                                            .facilityName
                                            .compareTo(b.facilityName));
                                      });
                                    }
                                  },
                                  items:
                                      facilities.map<DropdownMenuItem>((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.facilityName),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(8, context)),
                                Visibility(
                                  visible: facilityTag.length > 0,
                                  child: ListView.builder(
                                      itemCount: facilityTag.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            showConfirm(index);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              height: 32,
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                color: Color(0xff314B8C),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                facilityTag[index].facilityName,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .headline6
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(24, context)),
                                buttonWidget(context),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(24, context)),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  showConfirm(index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Tag"),
          content: Text(
              "Are you sure you want to remove tag ${facilityTag[index].facilityName} ?"),
          actions: <Widget>[
            MaterialButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  facilityTag.removeAt(index);
    facilityTag.sort((a, b) => a.facilityName.compareTo(b.facilityName));
                });
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget inputWidget(
      TextEditingController textEditingController,
      String validation,
      bool isVisible,
      String label,
      String hint,
      String postText,
      save) {
    return TextFormField(
      style: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
      controller: textEditingController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        suffixText: postText,
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

  bool loader = false;

  Widget buttonWidget(BuildContext context) {
    return loader
        ? circularProgressWidget()
        : MaterialButton(
            minWidth: 360,
            height: 55,
            color: Color(0xff314B8C),
            onPressed: () async {
              List<String> modelFacilty = [];
              facilityTag.forEach((element) {
                modelFacilty.add(element.facilityId.toString());
              });
              double roomLength = double.parse(roomLengthFeetController.text) +
                  (double.parse(roomLengthInchesController.text) / 12.0);
              double roomWidth = double.parse(roomWidthFeetController.text) +
                  (double.parse(roomWidthInchesController.text) / 12.0);
              roomLength = double.parse(roomLength.toStringAsFixed(2));
              roomWidth = double.parse(roomWidth.toStringAsFixed(2));
              // ignore: missing_required_param
              RoomsToPropertyModel roomUpdate = RoomsToPropertyModel(
                propertyRoomId: room.propertyRoomId,
                propertyId: propertyElement.tableproperty.propertyId,
                roomId: roomTypeDropDownValue.roomId,
                roomSize1: roomLength,
                roomSize2: roomWidth,
                bath: _roomSelection[0] == true ? 1 : 0,
                balcony: _roomSelection[1] == true ? 1 : 0,
                wardrobe: _roomSelection[2] == true ? 1 : 0,
                facility: modelFacilty.join(','),
                flooring: flooringType[
                    _floorSelections.indexWhere((element) => element == true)],
              );
              print(roomUpdate.toJson());
              setState(() {
                loader = true;
              });
              bool result = await RoomService.updateRoom(
                  jsonEncode(roomUpdate.toJson()),
                  room.propertyRoomId.toString());
              setState(() {
                loader = false;
              });
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Room data edited successfully!"),
                  ),
                );
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Room data edit failed! Try again."),
                  ),
                );
              }
            },
            child: Text("Update Room",
                style: Theme.of(context).primaryTextTheme.subtitle1),
          );
  }
}
