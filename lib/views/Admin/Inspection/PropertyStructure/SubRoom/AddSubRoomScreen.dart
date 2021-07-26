import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/SubRoom/CaptureSubRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/tagWidget.dart';

import '../../../../../config.dart';

class AddSubRoomScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<Facility> facilities;
  final List<Facility> facilityTag;
  final List<String> imageList;
  final List<PropertyRoom> roomTypes;
  final PropertyRoom roomTypeDropDownValue;
  final PropertyRoom subRoomTypeDropDownValue;
  final double roomSizeOne;
  final double roomSizeTwo;
  AddSubRoomScreen({
    this.propertyElement,
    this.facilities,
    this.imageList,
    this.roomTypes,
    this.facilityTag,
    this.roomSizeOne = 0.0,
    this.roomSizeTwo = 0.0,
    this.roomTypeDropDownValue,
    this.subRoomTypeDropDownValue,
  });
  @override
  _AddSubRoomScreenState createState() => _AddSubRoomScreenState();
}

class _AddSubRoomScreenState extends State<AddSubRoomScreen> {
  Facility facilityDropDownValue;
  PropertyRoom roomTypeDropDownValue;
  PropertyRoom subRoomTypeDropDownValue;

  List<Facility> facilities = [];
  List<Facility> facilityTag = [];
  List<String> imageList;

  List<PropertyRoom> roomTypes = [];
  List<PropertyRoom> subRoomTypes = [];

  PropertyElement propertyElement;

  final formkey = new GlobalKey<FormState>();

  TextEditingController roomSizeOneController = new TextEditingController();
  TextEditingController roomSizeTwoController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    facilities = widget.facilities;
    imageList = widget.imageList;
    facilityDropDownValue = facilities[0];
    roomSizeOneController.text = widget.roomSizeOne.toString();
    roomSizeTwoController.text = widget.roomSizeTwo.toString();
    widget.facilityTag == null
        ? facilityTag = []
        : facilityTag = widget.facilityTag;
    widget.roomTypes.forEach((element) {
      if (element.issub == 1) {
        subRoomTypes.add(element);
      } else {
        roomTypes.add(element);
      }
    });
    roomTypeDropDownValue = widget.roomTypeDropDownValue == null
        ? roomTypes[0]
        : widget.roomTypeDropDownValue;
    subRoomTypeDropDownValue =
        widget.subRoomTypeDropDownValue == null
            ? subRoomTypes[0]
            : widget.subRoomTypeDropDownValue;
  }

  addTag(Facility tag) {
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
                          SizedBox(
                              height: UIConstants.fitToHeight(16, context)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Room Type',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
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
                            items: roomTypes.map<DropdownMenuItem>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.roomName),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                              height: UIConstants.fitToHeight(16, context)),
                          SizedBox(
                              height: UIConstants.fitToHeight(16, context)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('SubRoom Type',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1
                                    .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
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
                            items: subRoomTypes.map<DropdownMenuItem>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.roomName),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                              height: UIConstants.fitToHeight(16, context)),
                          inputWidget(
                              roomSizeOneController,
                              'Please enter Room Size One.',
                              false,
                              'Room Size One',
                              'Room Size One', (value) {
                            print(value);
                          }),
                          SizedBox(height: UIConstants.fitToHeight(8, context)),
                          inputWidget(
                              roomSizeTwoController,
                              'Please enter Room Size Two.',
                              false,
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
                            items: facilities.map<DropdownMenuItem>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.facilityName),
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
                            child: Text(
                              'Images',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .subtitle1
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
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
                                ),
                              ),
                            ),
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
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          imageList.removeAt(index);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.file(
                                          File(imageList[index]),
                                          height: UIConstants.fitToHeight(
                                              200, context),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                              height: UIConstants.fitToHeight(24, context)),
                          buttonWidget(context),
                          SizedBox(
                              height: UIConstants.fitToHeight(24, context)),
                        ],
                      ),
                    ),
                  ),
                ))
          ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: imageList.length < 3
            ? () {
                Routing.makeRouting(context,
                    routeMethod: 'pushReplacement',
                    newWidget: CaptureSubRoomScreen(
                      propertyElement: propertyElement,
                      facilities: facilities,
                      imageList: imageList,
                      facilityTag: facilityTag,
                      roomTypes: widget.roomTypes,
                      roomSizeOne: double.parse(roomSizeOneController.text),
                      roomSizeTwo: double.parse(roomSizeTwoController.text),
                      roomTypeDropDownValue: roomTypeDropDownValue,
                      subRoomTypeDropDownValue: subRoomTypeDropDownValue,
                    ));
              }
            : () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Cannot add more than 3 photos !"),
                  ),
                );
              },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future compress(img, id) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    final result = await FlutterImageCompress.compressAndGetFile(
      img.path,
      path.join(dir, id),
      format: CompressFormat.jpeg,
      quality: 40,
    );
    return result;
  }

  Future upload(pic, propertyId) async {
    final pickedFile = File(pic);
    String target = propertyId +
        "-" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".jpeg";
    if (pickedFile != null) {
      File img = await compress(pickedFile, target);
      var request = http.MultipartRequest(
          'POST', Uri.parse(Config.UPLOAD_PROPERTY_ENDPOINT));
      request.files.add(
        await http.MultipartFile.fromPath('upload', img.path),
      );
      http.StreamedResponse res = await request.send();
      if (res.statusCode == 200) {
        return target;
      }
    }
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
              String modelFacilty = "";
              facilityTag.forEach((e) {
                modelFacilty += e.facilityId.toString();
                modelFacilty += ",";
              });
              modelFacilty = modelFacilty.substring(0, modelFacilty.length - 1);
              String img1 = "";
              String img2 = "";
              String img3 = "";
              if (imageList.length > 0) {
                img1 = await upload(imageList[0],
                    propertyElement.tableproperty.propertyId.toString());
              } else if (imageList.length > 1) {
                img2 = await upload(imageList[1],
                    propertyElement.tableproperty.propertyId.toString());
              } else if (imageList.length > 2) {
                img3 = await upload(imageList[2],
                    propertyElement.tableproperty.propertyId.toString());
              }
              SubRoomElement subRoom = SubRoomElement(
                propertyId: propertyElement.tableproperty.propertyId,
                roomId: roomTypeDropDownValue.roomId,
                subRoomId: subRoomTypeDropDownValue.roomId,
                roomSize1: double.parse(roomSizeOneController.text),
                roomSize2: double.parse(roomSizeTwoController.text),
                facility: modelFacilty,
                image1: img1,
                image2: img2,
                image3: img3,
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("SubRoom added!"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("SubRoom addition failed!"),
                  ),
                );
              }
              Navigator.of(context).pop();
            },
            child: Text("Create Sub-Room",
                style: Theme.of(context).primaryTextTheme.subtitle1),
          );
  }

  Widget inputWidget(TextEditingController textEditingController,
      String validation, bool isVisible, String label, String hint, save) {
    return TextFormField(
      style: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
      controller: textEditingController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
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
