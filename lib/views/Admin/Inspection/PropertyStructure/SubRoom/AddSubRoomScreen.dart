import 'dart:io';

import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/SubRoom/CaptureSubRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/tagWidget.dart';

class AddSubRoomScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<Facility> facilities;
  final List<String> imageList;
  final List<String> facilitiesName;
  AddSubRoomScreen(
      {this.propertyElement,
      this.facilities,
      this.imageList,
      this.facilitiesName});
  @override
  _AddSubRoomScreenState createState() => _AddSubRoomScreenState();
}

class _AddSubRoomScreenState extends State<AddSubRoomScreen> {
  String facilityDropDownValue;

  List<Facility> facilities = [];
  List<String> facilitiesName = [];
  List<String> facilityTag = [];
  List<String> imageList;

  PropertyElement propertyElement;

  final formkey = new GlobalKey<FormState>();

  TextEditingController roomSizeOneController = new TextEditingController();
  TextEditingController roomSizeTwoController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    facilities = widget.facilities;
    facilitiesName = widget.facilitiesName;
    imageList = widget.imageList;
    facilityDropDownValue = facilities[0].facilityName;
  }

  addTag(String tag) {
    setState(() {
      facilityTag.add(tag);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Room'),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              child: Column(children: [
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
                            color: Colors.black, fontWeight: FontWeight.w700)),
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
                          inputWidget(
                              roomSizeOneController,
                              'Please enter Room Size One.',
                              true,
                              'Room Size One',
                              'Room Size One', (value) {
                            print(value);
                          }),
                          SizedBox(height: UIConstants.fitToHeight(8, context)),
                          inputWidget(
                              roomSizeTwoController,
                              'Please enter Room Size Two.',
                              true,
                              'Room Size Two',
                              'Room Size Two', (value) {
                            print(value);
                          }),
                          SizedBox(
                              height: UIConstants.fitToHeight(16, context)),
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
                              width: MediaQuery.of(context).size.width,
                              color: Color(0xff314B8C),
                            ),
                            onChanged: (value) {
                              setState(() {
                                addTag(value);
                                facilityDropDownValue = value;
                              });
                            },
                            items: facilitiesName
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                              height: UIConstants.fitToHeight(16, context)),
                          Visibility(
                              visible: facilityTag.length > 0,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                height: 100,
                                width: 100,
                                child: TagWidget(tagList: facilityTag),
                              )),
                          SizedBox(height: UIConstants.fitToHeight(8, context)),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('Images',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 36.0),
                            child: Visibility(
                                visible: imageList.length <= 0,
                                child: Center(
                                    child: Text(
                                  'No Image is captured!',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle2
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                ))),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Visibility(
                              visible: imageList.length > 0,
                              child: ListView.builder(
                                  itemCount: imageList.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        File(imageList[index]),
                                        height: UIConstants.fitToHeight(
                                            200, context),
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                              height: UIConstants.fitToHeight(24, context)),
                          buttonWidget(context),
                        ],
                      ),
                    ),
                  ),
                ))
          ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routing.makeRouting(context,
              routeMethod: 'push',
              newWidget: CaptureSubRoomScreen(
                  propertyElement: widget.propertyElement,
                  facilities: facilities,
                  imageList: imageList,
                  facilitiesName: facilitiesName));
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget buttonWidget(BuildContext context) {
    return MaterialButton(
      minWidth: 360,
      height: 55,
      color: Color(0xff314B8C),
      onPressed: () async {},
      child: Text("Create Sub-Room",
          style: Theme.of(context).primaryTextTheme.subtitle1),
    );
  }

  Widget inputWidget(TextEditingController textEditingController,
      String validation, bool isVisible, String label, String hint, save) {
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
