import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/constants/uiConstants.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/facilityService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';

import '../tagWidget.dart';

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

  bool isLoading = false;

  Facility facilityDropDownValue;
  PropertyRoom roomTypeDropDownValue;
  PropertyRoom subRoomTypeDropDownValue;

  List<Facility> facilities = [];
  List<Facility> facilityTag = [];
  List<String> imageList;
  List<RoomsToPropertyModel> rooms = [];

  List<PropertyRoom> allRoomTypes = [];
  List<PropertyRoom> subRoomTypes = [];

  final formkey = new GlobalKey<FormState>();

  TextEditingController roomLengthFeetController =
      new TextEditingController(text: "0");
  TextEditingController roomLengthInchesController =
      new TextEditingController(text: "0");
  TextEditingController roomWidthFeetController =
      new TextEditingController(text: "0");
  TextEditingController roomWidthInchesController =
      new TextEditingController(text: "0");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    widget.roomTypes.forEach((element) {
      if (element.issub == 0) {
        allRoomTypes.add(element);
      } else {
        subRoomTypes.add(element);
      }
    });
    setState(() {
      isLoading = true;
    });
    facilities = await FacilityService.getFacilities();
    subRoom = widget.subRoom;
    propertyElement = widget.propertyElement;
    roomLengthFeetController.text = (subRoom.roomSize1.toInt()).toString();
    roomLengthInchesController.text =
        (((subRoom.roomSize1 * 10) % 10)*1.2).toInt().toString();
    roomWidthFeetController.text = (subRoom.roomSize2.toInt()).toString();
    roomWidthInchesController.text =
        (((subRoom.roomSize2 * 10) % 10)*1.2).toInt().toString();
    subRoom.facility.split(",").forEach((element) {
       facilityTag.add(facilities
          .firstWhere((element2) => element2.facilityId == int.tryParse(element))?? 84);
    });
    facilityDropDownValue = facilities.first;
    roomTypeDropDownValue =
        allRoomTypes.firstWhere((element) => element.roomId == subRoom.roomId);
    subRoomTypeDropDownValue = subRoomTypes
        .firstWhere((element) => element.roomId == subRoom.subRoomId);
    setState(() {
      isLoading = false;
    });
  }

  addTag(Facility tag) {
    setState(() {
      facilityTag.add(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Sub-Room'),
        ),
        body: isLoading
            ? Center(
                child: circularProgressWidget(),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(children: [
                  SizedBox(height: UIConstants.fitToHeight(16, context)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text('Edit the Sub-RoomDetails',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700)),
                    ),
                  ),
                  SizedBox(height: UIConstants.fitToHeight(16, context)),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Container(
                        child: Form(
                          key: formkey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                    setState(() {
                                      roomTypeDropDownValue = value;
                                    });
                                  },
                                  items: allRoomTypes
                                      .map<DropdownMenuItem>((value) {
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
                                  child: Text('SubRoom Type',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                ),
                                DropdownButton(
                                  isExpanded: true,
                                  value: subRoomTypeDropDownValue,
                                  elevation: 8,
                                  underline: Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width,
                                    color: Color(0xff314B8C),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      subRoomTypeDropDownValue = value;
                                    });
                                  },
                                  items: subRoomTypes
                                      .map<DropdownMenuItem>((value) {
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
                                              fontWeight: FontWeight.w700)),
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(4, context)),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: inputWidget(
                                          roomLengthFeetController,
                                          'Please enter Room Length.',
                                          false,
                                          'Room Length',
                                          'Room Size Length',
                                          'ft', (value) {
                                        print(value);
                                      }),
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      flex: 1,
                                      child: inputWidget(
                                          roomLengthInchesController,
                                          'Please enter Room Length.',
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
                                  child: Text('Room Width',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700)),
                                ),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(4, context)),
                                Row(
                                  children: [
                                    Flexible(
                                      child: inputWidget(
                                          roomWidthFeetController,
                                          'Please enter Room Width.',
                                          false,
                                          'Room Width',
                                          'Room Width',
                                          'ft', (value) {
                                        print(value);
                                      }),
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      flex: 1,
                                      child: inputWidget(
                                          roomWidthInchesController,
                                          'Please enter Room Length.',
                                          false,
                                          'Room Width',
                                          'Room Width',
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
                                    setState(() {
                                      addTag(value);
                                      facilityDropDownValue = value;
                                    });
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
                                        UIConstants.fitToHeight(16, context)),
                                Visibility(
                                    visible: facilityTag.length > 0,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 100,
                                      width: 100,
                                      child: TagWidget(tagList: facilityTag),
                                    )),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(8, context)),
                                buttonWidget(context),
                                SizedBox(
                                    height:
                                        UIConstants.fitToHeight(32, context)),
                              ],
                            ),
                          ),
                        ),
                      ))
                ]))),
      ),
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
              SubRoomElement subRoomUpdate = SubRoomElement(
                propertySubRoomId: subRoom.propertySubRoomId,
                propertyId: propertyElement.tableproperty.propertyId,
                roomId: roomTypeDropDownValue.roomId,
                subRoomId: subRoomTypeDropDownValue.roomId,
                roomSize1: roomLength,
                roomSize2: roomWidth,
                facility: modelFacilty.join(','),
              );
              print(subRoomUpdate.toJson());
              setState(() {
                loader = true;
              });
              bool result = await SubRoomService.updateSubRoom(
                  jsonEncode(subRoomUpdate.toJson()),
                  subRoom.propertySubRoomId.toString());
              setState(() {
                loader = false;
              });
              if (result) {
                showInSnackBar(
                    context, 'Sub-Room data edited successfully!', 2500);
              Navigator.of(context).pop(true);
              } else {
                showInSnackBar(
                    context, 'Sub-Room data edit failed! Try again.', 2500);
              }
            },
            child: Text("Edit Sub-Room",
                style: Theme.of(context).primaryTextTheme.subtitle1),
          );
  }

  Widget inputWidget(
      TextEditingController textEditingController,
      String validation,
      bool isVisible,
      String label,
      String hint,
      String suffixText,
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
        suffixText: suffixText,
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
