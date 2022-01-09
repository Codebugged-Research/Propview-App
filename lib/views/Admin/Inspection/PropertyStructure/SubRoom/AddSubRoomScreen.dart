import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:propview/constants/uiConstants.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/facilityService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';

class AddSubRoomScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<PropertyRoom> roomTypes;

  AddSubRoomScreen({
    this.propertyElement,
    this.roomTypes,
  });

  @override
  _AddSubRoomScreenState createState() => _AddSubRoomScreenState();
}

class _AddSubRoomScreenState extends State<AddSubRoomScreen> {
  bool isLoading = false;

  Facility facilityDropDownValue;
  PropertyRoom roomTypeDropDownValue;
  PropertyRoom subRoomTypeDropDownValue;

  List<Facility> facilities = [];
  List<Facility> facilities2 = [];
  List<Facility> facilityTag = [];
  List<RoomsToPropertyModel> rooms = [];

  List<PropertyRoom> roomTypes = [];
  List<PropertyRoom> allRoomTypes = [];
  List<PropertyRoom> subRoomTypes = [];

  PropertyElement propertyElement;

  final formkey = new GlobalKey<FormState>();

  TextEditingController roomLengthFeetController =
      new TextEditingController(text: "0");
  TextEditingController roomLengthInchesController =
      new TextEditingController(text: "0.00");
  TextEditingController roomWidthFeetController =
      new TextEditingController(text: "0");
  TextEditingController roomWidthInchesController =
      new TextEditingController(text: "0.00");

  @override
  void initState() {
    super.initState();
    loadDataForScreen();
  }

  addTag(Facility tag) {
    setState(() {
      facilityTag.add(tag);
    });
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    propertyElement = widget.propertyElement;
    widget.roomTypes.forEach((element) {
      if (element.issub == 1) {
        subRoomTypes.add(element);
      } else {
        roomTypes.add(element);
      }
    });
    facilities = await FacilityService.getFacilities();
    facilities2 = await FacilityService.getFacilities();
    facilityDropDownValue =
        facilities.firstWhere((element) => element.facilityId == 84);
    rooms = await RoomService.getRoomByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    allRoomTypes = widget.roomTypes;
    List<PropertyRoom> newRoomList = [];
    for (int i = 0; i < rooms.length; i++) {
      for (int j = 0; j < allRoomTypes.length; j++) {
        if (rooms[i].roomId == allRoomTypes[j].roomId) {
          newRoomList.add(allRoomTypes[j]);
        }
      }
    }
    setState(() {
      roomTypes = newRoomList ?? [];
    });
    roomTypeDropDownValue = roomTypes.length > 0 ? roomTypes[0] : null;
    subRoomTypeDropDownValue = subRoomTypes.length > 0 ? subRoomTypes[0] : null;
    setState(() {
      isLoading = false;
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
          title: Text(
            'Add Sub-Room',
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? circularProgressWidget()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: UIConstants.fitToHeight(16, context)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Text('Fill the Details',
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(0xff314B8C),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          roomTypeDropDownValue = value;
                                        });
                                      },
                                      items: roomTypes
                                          .map<DropdownMenuItem>((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.roomName),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(
                                        height: UIConstants.fitToHeight(
                                            16, context)),
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(0xff314B8C),
                                      ),
                                      onChanged: (value) {
                                        facilities.clear();
                                        facilityTag.clear();
                                        facilities2.forEach((element) {
                                          if (element.roomId
                                              .split(",")
                                              .contains(
                                                  value.roomId.toString())) {
                                            facilities.add(element);
                                          }
                                        });
                                        facilityDropDownValue = facilities[0];
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
                                        height: UIConstants.fitToHeight(
                                            16, context)),
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
                                        height: UIConstants.fitToHeight(
                                            4, context)),
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
                                        height: UIConstants.fitToHeight(
                                            8, context)),
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
                                        height: UIConstants.fitToHeight(
                                            4, context)),
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
                                        height: UIConstants.fitToHeight(
                                            16, context)),
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(0xff314B8C),
                                      ),
                                      onChanged: (value) {
                                        if (value.facilityId == 84) {
                                          setState(() {
                                            facilityDropDownValue = value;
                                          });
                                          showInSnackBar(
                                              context,
                                              "Please Choose a valid article",
                                              800);
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
                                      items: facilities
                                          .map<DropdownMenuItem>((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value.facilityName),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(
                                        height: UIConstants.fitToHeight(
                                            16, context)),
                                    Visibility(
                                      visible: facilityTag.length > 0,
                                      child: ListView.builder(
                                          itemCount: facilityTag.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                showConfirm(index);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Container(
                                                  height: 32,
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff314B8C),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Text(
                                                    facilityTag[index]
                                                        .facilityName,
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .primaryTextTheme
                                                        .headline6
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    SizedBox(
                                        height: UIConstants.fitToHeight(
                                            8, context)),
                                    buttonWidget(context),
                                    SizedBox(
                                        height: UIConstants.fitToHeight(
                                            32, context)),
                                  ],
                                ),
                              ),
                            ),
                          ))
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
                  facilityTag
                      .sort((a, b) => a.facilityName.compareTo(b.facilityName));
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
              SubRoomElement subRoom = SubRoomElement(
                propertyId: propertyElement.tableproperty.propertyId,
                roomId: roomTypeDropDownValue.roomId,
                subRoomId: subRoomTypeDropDownValue.roomId,
                roomSize1: roomLength,
                roomSize2: roomWidth,
                facility: modelFacilty.join(','),
              );
              print(subRoom.toJson());
              setState(() {
                loader = true;
              });
              bool result = await SubRoomService.createSubRoom(
                  jsonEncode(subRoom.toJson()));
              setState(() {
                loader = false;
              });
              if (result) {
                showInSnackBar(context, 'Sub-Room Added', 2500);
              } else {
                showInSnackBar(
                    context, 'Sub-Room Addition request failed!', 2500);
              }
              Navigator.of(context).pop(true);
            },
            child: Text("Create Sub-Room",
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
