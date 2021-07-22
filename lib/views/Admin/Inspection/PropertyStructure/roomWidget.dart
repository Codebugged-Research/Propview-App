import 'dart:io';

import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/propertyFunctions.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/tagWidget.dart';
import 'package:propview/views/Admin/widgets/CaptureScreen.dart';

class RoomWidget extends StatefulWidget {
  final List<Room> rooms;
  final List<Facility> facilities;
  final List<String> imageList;
  RoomWidget({this.rooms, this.facilities, this.imageList});
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
  List<String> facilityTag = [];
  List<String> flooringType = [];
  List<String> imageList;

  final formkey = new GlobalKey<FormState>();

  TextEditingController roomSizeOneController = new TextEditingController();
  TextEditingController roomSizeTwoController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    rooms = widget.rooms;
    facilities = widget.facilities;
    facilitiesName = PropertyFunctions.getFacilityName(facilities);
    flooringType = PropertyFunctions.getFlooringType();
    facilityDropDownValue = facilities[0].facilityName;
    marbelTypeDropDownValue = flooringType[0];
    imageList = widget.imageList;
  }

  addTag(String tag) {
    setState(() {
      facilityTag.add(tag);
    });
  }

  removeTag(String tag) {
    setState(() {
      facilityTag.remove(tag);
    });
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
          addRoomModalSheet(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  addRoomModalSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (_) => StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) =>
                  Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: UIConstants.fitToHeight(16, context)),
                      Text(
                        'Add a Room',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                                color: Color(0xff314B8C),
                                fontWeight: FontWeight.bold),
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
                                    inputWidget(
                                        roomSizeOneController,
                                        'Please enter Room Size One.',
                                        true,
                                        'Room Size One',
                                        'Room Size One', (value) {
                                      print(value);
                                    }, stateSetter),
                                    SizedBox(
                                        height: UIConstants.fitToHeight(
                                            8, context)),
                                    inputWidget(
                                        roomSizeTwoController,
                                        'Please enter Room Size Two.',
                                        true,
                                        'Room Size Two',
                                        'Room Size Two', (value) {
                                      print(value);
                                    }, stateSetter),
                                    SizedBox(
                                        height: UIConstants.fitToHeight(
                                            8, context)),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Facilities',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400)),
                                    ),
                                    DropdownButton<String>(
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
                                        stateSetter(() {
                                          addTag(value);
                                          facilityDropDownValue = value;
                                        });
                                      },
                                      items: facilitiesName
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    Visibility(
                                        visible: facilityTag.length > 0,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 100,
                                          width: 100,
                                          child: TagWidget(
                                            tagList: facilityTag,
                                            stateSetter: stateSetter,
                                          ),
                                        )),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Flooring Type',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400)),
                                    ),
                                    DropdownButton<String>(
                                      isExpanded: true,
                                      value: marbelTypeDropDownValue,
                                      elevation: 8,
                                      underline: Container(
                                        height: 2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Color(0xff314B8C),
                                      ),
                                      onChanged: (value) {
                                        stateSetter(() {
                                          marbelTypeDropDownValue = value;
                                        });
                                      },
                                      items: flooringType
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    CheckboxListTile(
                                      value: isBath,
                                      title: Text('Bathroom',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle1
                                              .copyWith(color: Colors.black)),
                                      onChanged: (bool value) {
                                        stateSetter(() {
                                          isBath = value;
                                        });
                                      },
                                    ),
                                    CheckboxListTile(
                                      value: isBalcony,
                                      title: Text('Balcony',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle1
                                              .copyWith(color: Colors.black)),
                                      onChanged: (bool value) {
                                        stateSetter(() {
                                          isBalcony = value;
                                        });
                                      },
                                    ),
                                    CheckboxListTile(
                                      value: isWardrobe,
                                      title: Text(
                                        'Wardrobe',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1
                                            .copyWith(color: Colors.black),
                                      ),
                                      onChanged: (bool value) {
                                        stateSetter(() {
                                          isWardrobe = value;
                                        });
                                      },
                                    ),
                                    Text('Images',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle1
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400)),
                                    Visibility(
                                        visible: imageList.length != 3,
                                        child: IconButton(
                                            onPressed: () {
                                              Routing.makeRouting(context,
                                                  routeMethod: 'push',
                                                  newWidget: CameraScreen(
                                                      imageList: imageList));
                                            },
                                            icon: Icon(Icons.add_a_photo))),
                                    Visibility(
                                        visible: imageList.length <= 0,
                                        child: Text('No Image is captured')),
                                    Visibility(
                                      visible: imageList.length > 0,
                                      child: ListView.builder(
                                          itemCount: imageList.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.file(
                                                File(imageList[index]),
                                                height: UIConstants.fitToHeight(
                                                    100, context),
                                                fit: BoxFit.contain,
                                              ),
                                            );
                                          }),
                                    ),
                                    SizedBox(
                                        height: UIConstants.fitToHeight(
                                            16, context)),
                                  ],
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
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
