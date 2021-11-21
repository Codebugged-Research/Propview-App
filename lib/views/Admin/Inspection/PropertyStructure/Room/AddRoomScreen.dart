import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:propview/config.dart';
import 'package:propview/constants/uiConstants.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/Room/CaptureRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/tagWidget.dart';

class AddRoomScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<Facility> facilities;
  final List<String> imageList;
  final List<bool> roomBoolList;
  final List<bool> flooringLIst;
  final List<String> flooringType;
  final List roomList;
  final List<Facility> facilityTag;
  final double roomLengthFeet;
  final int roomLengthInches;
  final double roomWidthFeet;
  final int roomWidthInches;
  final bool isBath;
  final String marbelTypeDropDownValue;
  final bool isBalcony;
  final bool isWardrobe;
  PropertyRoom roomTypeDropDownValue;

  AddRoomScreen({
    this.propertyElement,
    this.facilities,
    this.imageList,
    this.roomBoolList,
    this.flooringLIst,
    this.marbelTypeDropDownValue,
    this.flooringType,
    this.facilityTag,
    this.roomLengthFeet = 0.00,
    this.roomLengthInches = 0,
    this.roomWidthFeet = 0.00,
    this.roomWidthInches = 0,
    this.isBath = false,
    this.isBalcony = false,
    this.isWardrobe = false,
    this.roomList,
    this.roomTypeDropDownValue,
  });

  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  bool isBath = false;
  bool isBalcony = false;
  bool isWardrobe = false;

  Facility facilityDropDownValue;
  String marbelTypeDropDownValue;
  PropertyRoom roomTypeDropDownValue;

  List<bool> _floorSelections = List.generate(3, (_) => false);
  List<bool> _roomSelection = List.generate(3, (_) => false);

  List<Facility> facilities = [];
  List<Facility> facilityTag = [];
  List<String> flooringType = [];
  List<String> imageList;

  PropertyElement propertyElement;

  final formkey = new GlobalKey<FormState>();

  TextEditingController roomLengthFeetController =
      new TextEditingController(text: "0.00");
  TextEditingController roomLengthInchesController =
      new TextEditingController(text: "0");
  TextEditingController roomWidthFeetController =
      new TextEditingController(text: "0.00");
  TextEditingController roomWidthInchesController =
      new TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
    widget.marbelTypeDropDownValue == null
        ? marbelTypeDropDownValue = widget.flooringType[0]
        : marbelTypeDropDownValue = widget.marbelTypeDropDownValue;
    propertyElement = widget.propertyElement;
    facilities = widget.facilities;
    flooringType = widget.flooringType;
    imageList = widget.imageList;
    _floorSelections = widget.flooringLIst ?? List.generate(3, (_) => false);
    _roomSelection = widget.roomBoolList ?? List.generate(3, (_) => false);
    facilityDropDownValue = facilities[0];
    roomLengthFeetController.text = widget.roomLengthFeet.toString();
    roomLengthInchesController.text = widget.roomLengthInches.toString();
    roomWidthFeetController.text = widget.roomWidthFeet.toString();
    roomWidthInchesController.text = widget.roomWidthInches.toString();
    isBath = widget.isBath;
    isWardrobe = widget.isWardrobe;
    isBalcony = widget.isBalcony;
    widget.facilityTag == null
        ? facilityTag = []
        : facilityTag = widget.facilityTag;
    widget.roomList.removeWhere((element) => element.issub == 1);
    roomTypeDropDownValue = widget.roomTypeDropDownValue == null
        ? widget.roomList[0]
        : widget.roomTypeDropDownValue;
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
                            items:
                                widget.roomList.map<DropdownMenuItem>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.roomName),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                              height: UIConstants.fitToHeight(16, context)),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Room Length',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle1
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700))),
                          SizedBox(height: UIConstants.fitToHeight(4, context)),
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
                          SizedBox(height: UIConstants.fitToHeight(8, context)),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Room Breadth',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle1
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700))),
                          SizedBox(height: UIConstants.fitToHeight(4, context)),
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
                              height: UIConstants.fitToHeight(16, context)),
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
                              height: UIConstants.fitToHeight(16, context)),
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
                                _roomSelection[index] = !_roomSelection[index];
                              });
                            },
                          ),
                          SizedBox(height: UIConstants.fitToHeight(8, context)),
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
                              height: UIConstants.fitToHeight(16, context)),
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
                              _floorSelections = List.generate(3, (_) => false);
                              setState(() {
                                _floorSelections[index] =
                                    !_floorSelections[index];
                              });
                            },
                          ),
                          SizedBox(height: UIConstants.fitToHeight(8, context)),
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
                            items: facilities.map<DropdownMenuItem>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.facilityName),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: UIConstants.fitToHeight(8, context)),
                          Visibility(
                            visible: facilityTag.length > 0,
                            child: TagWidget(tagList: facilityTag),
                          ),
                          SizedBox(height: UIConstants.fitToHeight(24, context)),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text('Images',
                          //       style: Theme.of(context)
                          //           .primaryTextTheme
                          //           .subtitle1
                          //           .copyWith(
                          //               color: Colors.black,
                          //               fontWeight: FontWeight.w700)),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 36.0),
                          //   child: Visibility(
                          //       visible: imageList.length <= 0,
                          //       child: Center(
                          //           child: Text(
                          //         'No Image is captured!',
                          //         style: Theme.of(context)
                          //             .primaryTextTheme
                          //             .subtitle2
                          //             .copyWith(
                          //                 color: Colors.black,
                          //                 fontWeight: FontWeight.w600),
                          //       ))),
                          // ),
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 16.0),
                          //   child: Visibility(
                          //     visible: imageList.length > 0,
                          //     child: ListView.builder(
                          //         itemCount: imageList.length,
                          //         shrinkWrap: true,
                          //         scrollDirection: Axis.vertical,
                          //         physics: BouncingScrollPhysics(),
                          //         itemBuilder:
                          //             (BuildContext context, int index) {
                          //           return InkWell(
                          //             onTap: () {
                          //               setState(() {
                          //                 imageList.removeAt(index);
                          //               });
                          //             },
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(8.0),
                          //               child: Image.file(
                          //                 File(imageList[index]),
                          //                 height: UIConstants.fitToHeight(
                          //                     200, context),
                          //                 fit: BoxFit.contain,
                          //               ),
                          //             ),
                          //           );
                          //         }),
                          //   ),
                          // ),
                          // SizedBox(
                          //     height: UIConstants.fitToHeight(24, context)),
                          buttonWidget(context),
                          SizedBox(
                              height: UIConstants.fitToHeight(24, context)),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: 
        // imageList.length < 3 ? 
        () {
                Routing.makeRouting(context,
                    routeMethod: 'pushReplacement',
                    newWidget: CaptureRoomScreen(
                      propertyElement: propertyElement,
                      facilities: facilities,
                      // imageList: imageList,
                      facilityTag: facilityTag,
                      flooringType: flooringType,
                      marbelTypeDropDownValue: marbelTypeDropDownValue,
                      roomLengthFeet:
                          double.parse(roomLengthFeetController.text),
                      roomLengthInches:
                          double.parse(roomLengthInchesController.text),
                      roomWidthFeet: double.parse(roomWidthFeetController.text),
                      roomWidthInches:
                          double.parse(roomWidthInchesController.text),
                      isBath: isBath,
                      roomTypes: widget.roomList,
                      isBalcony: isBalcony,
                      isWardrobe: isWardrobe,
                      roomTypeDropDownValue: roomTypeDropDownValue,
                      roomBoolList: _roomSelection,
                      flooringLIst: _floorSelections,
                    ));
              },
            // : () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text("Cannot add more than 3 photos !"),
            //       ),
            //     );
            //   },
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
            modelFacilty =
                modelFacilty.substring(0, modelFacilty.length - 1);
            double roomLength =
                double.parse(roomLengthFeetController.text) +
                    (double.parse(roomLengthInchesController.text) / 12.0);
            double roomWidth = double.parse(roomWidthFeetController.text) +
                (double.parse(roomWidthInchesController.text) / 12.0);
            roomLength = double.parse(roomLength.toStringAsFixed(2));
            roomWidth = double.parse(roomWidth.toStringAsFixed(2));
            // ignore: missing_required_param
            RoomsToPropertyModel room = RoomsToPropertyModel(
              propertyId: propertyElement.tableproperty.propertyId,
              roomId: roomTypeDropDownValue.roomId,
              // create drop down for this
              roomSize1: roomLength,
              roomSize2: roomWidth,
              bath: _roomSelection[0] == true ? 1 : 0,
              balcony: _roomSelection[1] == true ? 1 : 0,
              wardrobe: _roomSelection[2] == true ? 1 : 0,
              facility: modelFacilty,
              flooring: flooringType[_floorSelections
                  .indexWhere((element) => element == true)],
              // image1: img1,
              // image2: img2,
              // image3: img3,
            );
            print(room.toJson());
            setState(() {
              loader = true;
            });
            bool result = await RoomService.createRoomByPropertyId(
                jsonEncode(room.toJson()));
            setState(() {
              loader = false;
            });
            if (result) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Room added!"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Room addition failed!"),
                ),
              );
            }
            Navigator.of(context).pop();
          },
          child: Text("Create Room",
              style: Theme.of(context).primaryTextTheme.subtitle1),
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
}
