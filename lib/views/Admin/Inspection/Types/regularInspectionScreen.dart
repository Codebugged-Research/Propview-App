import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/models/RegularInspectionRow.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/customRoomSubRoom.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/billPropertyService.dart';
import 'package:propview/services/regulationInspectionRowService.dart';
import 'package:propview/services/regulationInspectionService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';
import 'package:propview/views/Admin/widgets/fullInspectionCard.dart';

class RegularInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  const RegularInspectionScreen({this.propertyElement});

  @override
  _RegularInspectionScreenState createState() =>
      _RegularInspectionScreenState();
}

class _RegularInspectionScreenState extends State<RegularInspectionScreen> {
  PropertyElement propertyElement;
  RoomType roomTypes;

  bool loader = false;
  String object = "";
  int count = 0;
  String dummyDouble = (0.0).toString();

  List<RoomsToPropertyModel> rooms = [];
  List<SubRoomElement> subRooms = [];
  List<CustomRoomSubRoom> roomsAvailable = [];
  CustomRoomSubRoom selectedRoomSubRoom;

  TextEditingController billDuesController;
  TextEditingController termiteCheckController;
  TextEditingController seePageController;
  TextEditingController generalCleanlinessController;
  TextEditingController otherIssueController;
  List<BillToProperty> bills = [];

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    loadDataForScreen();
  }

  List<RegularInspectionRow> regularInspectionRowList = [];

  loadDataForScreen() async {
    setState(() {
      loader = true;
    });

    bills = await BillPropertyService.getBillsByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    roomTypes = await RoomTypeService.getRoomTypes();
    rooms = await RoomService.getRoomByPropertyId(
      propertyElement.tableproperty.propertyId.toString(),
    );
    if (rooms.length == 0) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertWidget(
              title: 'Property Structure is not defined!',
              body:
                  'First you have to determine the property structure to begin with inspection.',
            );
          });
    } else {
      subRooms = await SubRoomService.getSubRoomByPropertyId(
          propertyElement.tableproperty.propertyId.toString());
      for (var i = 0; i < rooms.length; i++) {
        setState(() {
          roomsAvailable.add(CustomRoomSubRoom(
            isSubroom: false,
            propertyRoomSubRoomId: rooms[i].propertyRoomId,
            roomSubRoomName: getRoomName(rooms[i].roomId),
          ));
        });
      }
      for (var i = 0; i < subRooms.length; i++) {
        setState(() {
          roomsAvailable.add(CustomRoomSubRoom(
            isSubroom: true,
            propertyRoomSubRoomId: subRooms[i].propertySubRoomId,
            roomSubRoomName: getRoomName(subRooms[i].subRoomId) +
                "-" +
                getRoomName(rooms[i].roomId),
          ));
        });
      }
    }
    selectedRoomSubRoom = roomsAvailable[0];
    setState(() {
      loader = false;
    });
  }

  getRoomName(id) {
    PropertyRoom room = roomTypes.data.propertyRoom
        .where((element) => element.roomId == id)
        .first;
    return room.roomName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Regular\n",
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
                              .copyWith(
                                fontWeight: FontWeight.normal,
                              ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      titleWidget(context, 'Bills'),
                    ],
                  ),
                  bills.length == 0
                      ? Center(
                          child: Text(
                            'Nothing to Inspect!!',
                            style: Theme.of(context).primaryTextTheme.subtitle2,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: bills.length,
                          itemBuilder: (BuildContext context, int index) {
                            return FullInspectionCard(
                              propertyElement: propertyElement,
                              billToProperty: bills[index],
                            );
                          }),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                  ListView.builder(
                      itemCount: regularInspectionRowList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return inspectionCard(constraints, index);
                      }),
                  regularInspectionRowList.length > 0
                      ? buttonWidget(context)
                      : Container(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  inspectionCard(constraints, index) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Text(
            regularInspectionRowList[index].roomsubroomName,
            style: Theme.of(context)
                .primaryTextTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.minWidth),
              child: DataTable(
                dataRowHeight: 80,
                dividerThickness: 2,
                columns: [
                  DataColumn(
                      label: Text("Termite Issue",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle2
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                  DataColumn(
                      label: Text("Seepage Check",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle2
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                  DataColumn(
                      label: Text("General Cleanliness",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle2
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                  DataColumn(
                      label: Text("Other Issues",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle2
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                ],
                rows: 
                    [DataRow(
                        cells: [
                          DataCell(TextFormField(
                            initialValue: regularInspectionRowList[index].termiteCheck,
                            onChanged: (value) {
                              setState(() {
                                regularInspectionRowList[index].termiteCheck = value;
                              });
                            },
                          )),
                          DataCell(TextFormField(
                            initialValue: regularInspectionRowList[index].seepageCheck,
                            onChanged: (value) {
                              setState(() {
                                regularInspectionRowList[index].seepageCheck = value;
                              });
                            },
                          )),
                          DataCell(
                            TextFormField(
                              initialValue: regularInspectionRowList[index].generalCleanliness,
                              onChanged: (value) {
                                setState(() {
                                  regularInspectionRowList[index].generalCleanliness = value;
                                });
                              },
                            ),
                          ),
                          DataCell(
                            TextFormField(
                              initialValue: regularInspectionRowList[index].otherIssue,
                              onChanged: (value) {
                                setState(() {
                                  regularInspectionRowList[index].otherIssue = value;
                                });
                              },
                            ),
                          ),
                        ],
                      )]
              ),
            ),
          ),
        ],
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
                value: selectedRoomSubRoom,
                items: roomsAvailable
                    .map<DropdownMenuItem>((CustomRoomSubRoom value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.roomSubRoomName),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedRoomSubRoom = newValue;
                    regularInspectionRowList.add(RegularInspectionRow(
                      id: 0,
                      termiteCheck: "",
                      seepageCheck: "",
                      generalCleanliness: "",
                      otherIssue: "",
                      issub: selectedRoomSubRoom.isSubroom == true ? 1 : 0,
                      roomsubroomId: selectedRoomSubRoom.propertyRoomSubRoomId,
                      roomsubroomName: selectedRoomSubRoom.roomSubRoomName,
                      createdAt: DateTime.now(),
                    ));
                  });
                  Routing.makeRouting(context, routeMethod: 'pop');
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ),
      ),
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


  bool loading = false;

  Widget buttonWidget(BuildContext context) {
    return loading
        ? circularProgressWidget()
        : MaterialButton(
            minWidth: 360,
            height: 55,
            color: Color(0xff314B8C),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              User user = await UserService.getUser();
              RegularInspection regularInspection = RegularInspection(
                id: 0,
                rowList: "",
                propertyId: widget.propertyElement.tableproperty.propertyId,
                employeeId: user.userId,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              List rowIdist = [];
              for (int i = 0; i < regularInspectionRowList.length; i++) {
                String id =
                    await RegularInspectionRowService.createRegularInspection(
                  jsonEncode(
                    regularInspectionRowList[i].toJson(),
                  ),
                );
                rowIdist.add(id);
              }
              regularInspection.rowList = rowIdist.join(",");
              bool result =
                  await RegularInspectionService.createRegularInspection(
                      jsonEncode(regularInspection.toJson()));
              for (int i = 0; i < bills.length; i++) {
                // ignore: unused_local_variable
                bool res = await BillPropertyService.updateBillProperty(
                    bills[i].id.toString(), jsonEncode(bills[i].toJson()));
              }
              setState(() {
                loading = false;
              });
              if (result) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Regular Inspection added successfully!"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Regular Inspection addition failed!"),
                  ),
                );
              }
            },
            child: Text(
              "Add Regular Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          );
  }
}
