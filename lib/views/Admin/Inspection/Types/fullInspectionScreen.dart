import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/formModels/tempFullInscpectionModel.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/views/Admin/widgets/photoCaptureScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  FullInspectionScreen({this.propertyElement});
  @override
  _FullInspectionScreenState createState() => _FullInspectionScreenState();
}

class _FullInspectionScreenState extends State<FullInspectionScreen> {
  PropertyElement propertyElement;

  TextEditingController maintainanceController = TextEditingController();
  TextEditingController commonAreaController = TextEditingController();
  TextEditingController electricitySocietyController = TextEditingController();
  TextEditingController electricityAuthorityController =
      TextEditingController();
  TextEditingController powerController = TextEditingController();
  TextEditingController pngController = TextEditingController();
  TextEditingController clubController = TextEditingController();
  TextEditingController waterController = TextEditingController();
  TextEditingController propertyTaxController = TextEditingController();
  TextEditingController anyOtherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    propertyElement = widget.propertyElement;
  }

  RoomType roomTypes;

  bool loader = false;
  getData() async {
    setState(() {
      loader = true;
    });
    roomTypes = await RoomTypeService.getRoomTypes();
    prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRoom = roomTypes.data.propertyRoom[0];
      loader = false;
    });
  }

  PropertyRoom selectedRoom;

  getRoomName(id) {
    PropertyRoom room = roomTypes.data.propertyRoom
        .where((element) => element.roomId == id)
        .first;
    return room.roomName;
  }

  SharedPreferences prefs;

  List<List<DataRow>> rows = [[]];
  List headings = [];
  int count = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: loader
          ? CircularProgressIndicator()
          : LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Full\n",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                                text: "Inspection",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.normal))
                          ])),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Maintenance Charges or CAM'),
                      inputWidget(maintainanceController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Common Area Electricity (CAE)'),
                      inputWidget(commonAreaController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Electricity (Society)'),
                      inputWidget(electricitySocietyController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Electricity (Authority)'),
                      inputWidget(electricityAuthorityController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Power Back-Up'),
                      inputWidget(powerController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'PNG/LPG'),
                      inputWidget(pngController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Club'),
                      inputWidget(clubController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Water'),
                      inputWidget(waterController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Property Tax'),
                      inputWidget(propertyTaxController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Any other'),
                      inputWidget(anyOtherController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleWidget(context, 'Issues'),
                          InkWell(
                            child: Icon(Icons.add),
                            onTap: () {
                              showRoomSelect();
                            },
                          )
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ListView.builder(
                        itemBuilder: (context, index) =>
                            issueCard(constraints, index),
                        itemCount: count,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  showRoomSelect() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Color(0xFFFFFFFF),
      builder: (BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Choose Room',
                    style: Theme.of(context).primaryTextTheme.headline6,
                  )),
              Align(
                  alignment: Alignment.center,
                  child: Divider(
                    color: Color(0xff314B8C),
                    thickness: 2.5,
                    indent: 100,
                    endIndent: 100,
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              DropdownButtonFormField(
                decoration: new InputDecoration(
                    icon: Icon(Icons.language)), //, color: Colors.white10
                value: selectedRoom,
                items: roomTypes.data.propertyRoom
                    .map<DropdownMenuItem<PropertyRoom>>(
                        (PropertyRoom country) {
                  return DropdownMenuItem<PropertyRoom>(
                    value: country,
                    child: Text(country.roomName,
                        style:
                            TextStyle(color: Color.fromRGBO(58, 66, 46, .9))),
                  );
                }).toList(),

                onChanged: (PropertyRoom newValue) {
                  setState(() {
                    selectedRoom = newValue;
                    count++;
                    headings.add(selectedRoom.roomName.toString());
                  });
                  print(newValue.roomName);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  List<List<Widget>> photo = [[]];

  photoPick(list, name) {
    return Container(
      width: 100,
      height: 50,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          print(name);
          return index == list.length
              ? InkWell(
                  onTap: () {
                    
                  },
                  child: Icon(Icons.add),
                )
              : list[index];
        },
      ),
    );
  }

  issueCard(constraints, index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        titleWidget(context, headings[index].toString()),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.minWidth),
            child: DataTable(
                dataRowHeight: 50,
                dividerThickness: 2,
                columns: [
                  DataColumn(
                      label: Text("Item/Issue Name",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle2
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                  DataColumn(
                      label: Text("Status",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle2
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                  DataColumn(
                      label: Text("Remarks",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle2
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                  DataColumn(
                      label: Text("Photos",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle2
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                ],
                rows: rows[index]),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              color: Colors.blueAccent,
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  rows[index].add(DataRow(cells: [
                    DataCell(TextFormField()),
                    DataCell(TextFormField()),
                    DataCell(TextFormField()),
                    DataCell(
                      photoPick(photo[index], headings[index].toString()),
                    ),
                  ]));
                });
              },
            ),
            IconButton(
              color: Colors.redAccent,
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  rows[index].removeLast();
                });
              },
            ),
            IconButton(
              color: Colors.green,
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  rows[index].clear();
                });
              },
            ),
          ],
        )
      ],
    );
  }



  Widget titleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }

  Widget inputWidget(TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          labelStyle: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }
}
