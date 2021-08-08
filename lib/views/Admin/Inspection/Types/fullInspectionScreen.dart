import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:propview/models/BIllType.dart';
import 'package:propview/models/BillToProperty.dart';

import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/customRoomSubRoom.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/billPropertyService.dart';
import 'package:propview/services/billTypeService.dart';
import 'package:propview/services/inspectionService.dart';
import 'package:propview/services/issueService.dart';
import 'package:propview/services/issueTableService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/FullInspection/CaptureFullInspectionScreen.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';
import 'package:propview/views/Admin/widgets/fullInspectionCard.dart';

import '../../../../config.dart';

class FullInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<List<Issue>> rows;
  final List<IssueTableData> issueTableList;
  final List<String> imageList;
  final int index1;
  final int index2;
  final Inspection inspection;
  FullInspectionScreen({
    this.inspection,
    this.propertyElement,
    this.rows,
    this.issueTableList,
    this.index1,
    this.index2,
    this.imageList,
  });
  @override
  _FullInspectionScreenState createState() => _FullInspectionScreenState();
}

class _FullInspectionScreenState extends State<FullInspectionScreen> {
  Inspection inspection;

  TextEditingController maintainanceController;
  TextEditingController commonAreaController;
  TextEditingController electricitySocietyController;
  TextEditingController electricityAuthorityController;
  TextEditingController powerController;
  TextEditingController pngController;
  TextEditingController clubController;
  TextEditingController waterController;
  TextEditingController propertyTaxController;
  TextEditingController anyOtherController;

  PropertyElement propertyElement;
  List<RoomsToPropertyModel> rooms = [];
  List<SubRoomElement> subRooms = [];
  List<CustomRoomSubRoom> roomsAvailable = [];
  CustomRoomSubRoom selectedRoomSubRoom;
  List<List<Issue>> rows = [];
  List<IssueTableData> issueTableList = [];
  List<List<String>> photoList = [];

  List<BillToProperty> bills = [];

  RoomType roomTypes;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  String dummyDouble = (0.0).toString();

  getData() async {
    setState(() {
      loader = true;
      propertyElement = widget.propertyElement;
    });
    bills = await BillPropertyService.getBillsByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    print(bills.length);
    maintainanceController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.maintenanceCharges.toString()
            : dummyDouble);
    commonAreaController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.commonAreaElectricity.toString()
            : dummyDouble);
    electricitySocietyController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.electricityAuthority.toString()
            : dummyDouble);
    electricityAuthorityController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.electricityAuthority.toString()
            : dummyDouble);
    powerController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.powerBackup.toString()
            : dummyDouble);
    pngController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.pngLgp.toString()
            : dummyDouble);
    clubController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.club.toString()
            : dummyDouble);
    waterController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.water.toString()
            : dummyDouble);
    propertyTaxController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.propertyTax.toString()
            : dummyDouble);
    anyOtherController = TextEditingController(
        text: widget.inspection != null
            ? widget.inspection.anyOther.toString()
            : dummyDouble);
    if (widget.index1 != null) {
      rows = widget.rows != null ? widget.rows : [[]];
      issueTableList =
          widget.issueTableList != null ? widget.issueTableList : [];
      rows[widget.index1][widget.index2].photo = widget.imageList;
    }
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
    setState(() {
      selectedRoomSubRoom = roomsAvailable[0];
      loader = false;
    });
  }

  getRoomName(id) {
    PropertyRoom room = roomTypes.data.propertyRoom
        .where((element) => element.roomId == id)
        .first;
    return room.roomName;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: loader
          ? circularProgressWidget()
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
                      titleWidget(context, 'Inspection'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      // bills.length == 0
                      //     ? Center(
                      //         child: Text('Nothing to Inspect!!', style: Theme.of(context).primaryTextTheme.subtitle2,),
                      //       )
                      //     :
                      ListView.builder(
                          shrinkWrap: true,
                          // itemCount: bills.length,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return FullInspectionCard(
                              // propertyElement: propertyElement,
                              // billToProperty: bills[index],
                            );
                          }),
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
                        itemBuilder: (context, index) {
                          return issueCard(constraints, index);
                        },
                        itemCount: issueTableList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      buttonWidget(context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
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
          'POST', Uri.parse(Config.UPLOAD_INSPECTION_ENDPOINT));
      request.files.add(
        await http.MultipartFile.fromPath('upload', img.path),
      );
      http.StreamedResponse res = await request.send();
      if (res.statusCode == 200) {
        return target;
      }
    }
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
              inspection = Inspection(
                inspectionId: 0,
                inspectType: "Full Inspection",
                maintenanceCharges: double.parse(maintainanceController.text),
                commonAreaElectricity: double.parse(commonAreaController.text),
                electricitySociety:
                    double.parse(electricitySocietyController.text),
                electricityAuthority:
                    double.parse(electricityAuthorityController.text),
                powerBackup: double.parse(powerController.text),
                pngLgp: double.parse(pngController.text),
                club: double.parse(clubController.text),
                water: double.parse(waterController.text),
                propertyTax: double.parse(propertyTaxController.text),
                anyOther: double.parse(anyOtherController.text),
                propertyId: widget.propertyElement.tableproperty.propertyId,
                employeeId: user.userId,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              // print(inspection.toJson());
              List tempIssueTableList = [];
              for (int i = 0; i < rows.length; i++) {
                List issueRowList = [];
                for (int j = 0; j < rows[i].length; j++) {
                  List<String> finalPhotoList = [];
                  for (int k = 0; k < rows[i][j].photo.length; k++) {
                    String tempUrl = await upload(
                        rows[i][j].photo[k],
                        widget.propertyElement.tableproperty.propertyId
                            .toString());
                    finalPhotoList.add(tempUrl);
                  }
                  var payload = {
                    "issue_id": 0,
                    "issue_name": rows[i][j].issueName,
                    "status": rows[i][j].status,
                    "remarks": rows[i][j].remarks,
                    "photo": finalPhotoList.join(","),
                    "createdAt": DateTime.now().toString(),
                    "updatedAt": DateTime.now().toString(),
                  };
                  // print(payload);
                  var result =
                      await IssueService.createIssue(jsonEncode(payload));
                  issueRowList.add(result);
                }
                var payload1 = {
                  "id": 0,
                  "roomsubroom_id": issueTableList[i].roomsubroomId,
                  "roomsubroom_name": issueTableList[i].roomsubroomName,
                  "issub": issueTableList[i].issub,
                  "issue_row_id": issueRowList.join(","),
                  "property_id":
                      widget.propertyElement.tableproperty.propertyId,
                  "created_at": DateTime.now().toString(),
                  "updated_at": DateTime.now().toString(),
                };
                var result = await IssueTableService.createIssueTable(
                    jsonEncode(payload1));
                tempIssueTableList.add(result);
              }
              inspection.issueIdList = tempIssueTableList.join(",");
              print(inspection.toJson());
              bool result = await InspectionService.createInspection(
                jsonEncode(
                  inspection.toJson(),
                ),
              );
              setState(() {
                loading = false;
              });
              if (result) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Full Inspection added"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Full Inspection addition failed!"),
                  ),
                );
              }
            },
            child: Text(
              "Add Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
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
                    issueTableList.add(IssueTableData(
                      roomsubroomId: newValue.propertyRoomSubRoomId,
                      roomsubroomName: newValue.roomSubRoomName,
                      issub: newValue.isSubroom == true ? 1 : 0,
                      issueRowId: "",
                      propertyId:
                          widget.propertyElement.tableproperty.propertyId,
                    ));
                    rows.add([]);
                    photoList.add([]);
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

  Widget issueCard(constraints, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        titleWidget(context, issueTableList[index].roomsubroomName),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.minWidth),
            child: DataTable(
              dataRowHeight: 80,
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
              rows: rows[index]
                  .asMap()
                  .entries
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(TextFormField(
                          initialValue: e.value.issueName,
                          onChanged: (value) {
                            setState(() {
                              e.value.issueName = value;
                            });
                          },
                        )),
                        DataCell(TextFormField(
                          initialValue: e.value.status,
                          onChanged: (value) {
                            setState(() {
                              e.value.status = value;
                            });
                          },
                        )),
                        DataCell(
                          TextFormField(
                            initialValue: e.value.remarks,
                            onChanged: (value) {
                              setState(() {
                                e.value.remarks = value;
                              });
                            },
                          ),
                        ),
                        DataCell(
                          photoPick(e.value.photo, index, e.key),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
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
                  photoList.add([]);
                  rows[index].add(
                    Issue(
                      issueName: "",
                      status: "",
                      remarks: "",
                      photo: photoList[index],
                    ),
                  );
                });
              },
            ),
            IconButton(
              color: Colors.redAccent,
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  rows[index].removeLast();
                  photoList[index].removeLast();
                });
              },
            ),
            IconButton(
              color: Colors.green,
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  rows[index].clear();
                  photoList[index].clear();
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Widget photoPick(List<String> list, int index1, int index2) {
    return Container(
      width: 300,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          return index == list.length
              ? InkWell(
                  onTap: () {
                    inspection = Inspection(
                      inspectType: "Full Inspection",
                      maintenanceCharges:
                          double.parse(maintainanceController.text),
                      commonAreaElectricity:
                          double.parse(commonAreaController.text),
                      electricitySociety:
                          double.parse(electricitySocietyController.text),
                      electricityAuthority:
                          double.parse(electricityAuthorityController.text),
                      powerBackup: double.parse(powerController.text),
                      pngLgp: double.parse(pngController.text),
                      club: double.parse(clubController.text),
                      water: double.parse(waterController.text),
                      propertyTax: double.parse(propertyTaxController.text),
                      anyOther: double.parse(anyOtherController.text),
                    );
                    Routing.makeRouting(
                      context,
                      routeMethod: 'pushReplacement',
                      newWidget: CaptureFullInspectionScreen(
                        imageList: list,
                        index1: index1,
                        index2: index2,
                        inspection: inspection,
                        propertyElement: widget.propertyElement,
                        rows: rows,
                        issueTableList: issueTableList,
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                )
              : InkWell(
                  child: Image.file(
                    File(list[index]),
                    height: 60,
                    width: 60,
                  ),
                  onTap: () {
                    setState(() {
                      list.removeAt(index);
                    });
                  },
                );
        },
      ),
    );
  }

  Widget titleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .headline6
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }

  Widget inputWidget(TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
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
