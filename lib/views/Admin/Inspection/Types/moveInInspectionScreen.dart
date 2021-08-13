import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:propview/config.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/City.dart';
import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/State.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/Tenant.dart';
import 'package:propview/models/TenantFamily.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/customRoomSubRoom.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/billPropertyService.dart';
import 'package:propview/services/cityService.dart';
import 'package:propview/services/inspectionService.dart';
import 'package:propview/services/issueService.dart';
import 'package:propview/services/issueTableService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/stateService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/services/tenantService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/MoveInInspection/addTenantFamilyScreen.dart';
import 'package:propview/views/Admin/Inspection/MoveInInspection/addTenantScreen.dart';
import 'package:propview/views/Admin/Inspection/MoveInInspection/captureScreenMoveIn.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';
import 'package:propview/views/Admin/widgets/moveInInspectionCard.dart';
import 'package:propview/views/Admin/widgets/tenantWidget.dart';

class MoveInInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<List<Issue>> rows;
  final List<IssueTableData> issueTableList;
  final List<String> imageList;
  final int index1;
  final int index2;
  final Inspection inspection;
  const MoveInInspectionScreen({
    this.inspection,
    this.propertyElement,
    this.rows,
    this.issueTableList,
    this.index1,
    this.index2,
    this.imageList,
  });
  @override
  _MoveInInspectionScreenState createState() => _MoveInInspectionScreenState();
}

class _MoveInInspectionScreenState extends State<MoveInInspectionScreen> {
  bool isLoading = false;
  String dummyDouble = (0.0).toString();

  Inspection inspection;
  PropertyElement propertyElement;
  RoomType roomTypes;

  List<CStates> cstates = [];
  List<City> cities = [];
  List<Tenant> tenants = [];
  List<TenantFamily> tenantFamily = [];
  List<RoomsToPropertyModel> rooms = [];
  List<SubRoomElement> subRooms = [];
  List<CustomRoomSubRoom> roomsAvailable = [];
  CustomRoomSubRoom selectedRoomSubRoom;
  List<List<Issue>> rows = [];
  List<IssueTableData> issueTableList = [];
  List<List<String>> photoList = [];

  List<BillToProperty> bills = [];

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
    propertyElement = widget.propertyElement;
    loadDataForScreen();
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    cstates = await StateService.getStates();
    cities = await CityService.getCities();
    bills = await BillPropertyService.getBillsByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
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
    //Getting Tenant IDs by Property ID
    List<String> tenantList =
        propertyElement.tableproperty.tenantId.split(",").toList();

    //Getting Tenant by Fetching from the Tenant Table
    for (var tenantId in tenantList) {
      Tenant tenant = await TenantService.getTenant(tenantId);
      setState(() {
        //Adding all the Tenants to the List
        tenants.add(tenant);
      });
    }
    selectedRoomSubRoom = roomsAvailable[0];
    setState(() {
      isLoading = false;
    });
  }

  getRoomName(id) {
    PropertyRoom room = roomTypes.data.propertyRoom
        .where((element) => element.roomId == id)
        .first;
    return room.roomName;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? circularProgressWidget()
          : LayoutBuilder(
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
                                text: "Move In\n",
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
                        bills.length == 0
                            ? Center(
                                child: Text(
                                  'Nothing to Inspect!!',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle2,
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: bills.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return MoveInInspectionCard(
                                    propertyElement: propertyElement,
                                    billToProperty: bills[index],
                                  );
                                }),
                        // titleWidget(context, 'Maintenance Charges or CAM'),
                        // inputWidget(maintainanceController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'Common Area Electricity (CAE)'),
                        // inputWidget(commonAreaController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'Electricity (Society)'),
                        // inputWidget(electricitySocietyController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'Electricity (Authority)'),
                        // inputWidget(electricityAuthorityController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'Power Back-Up'),
                        // inputWidget(powerController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'PNG/LPG'),
                        // inputWidget(pngController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'Club'),
                        // inputWidget(clubController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'Water'),
                        // inputWidget(waterController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'Property Tax'),
                        // inputWidget(propertyTaxController),
                        // SizedBox(
                        //     height: MediaQuery.of(context).size.height * 0.02),
                        // titleWidget(context, 'Any other'),
                        // inputWidget(anyOtherController),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        subHeadingWidget(context, 'Tenant Details'),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        tenants.length == 0
                            ? Center(
                                child: Text('No Tenant is found!',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .subtitle2
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: tenants.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TenantWidget(
                                    tenant: tenants[index],
                                    index: index,
                                    cstates: cstates,
                                    cities: cities,
                                  );
                                }),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subHeadingWidget(context, 'Issues'),
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
                            height: MediaQuery.of(context).size.height * 0.04),
                        buttonWidget(context),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.group, color: Colors.white),
              backgroundColor: Color(0xff314B8C),
              onTap: () {
                Routing.makeRouting(context,
                    routeMethod: 'push',
                    newWidget: AddTenantFamilyScreen(
                        propertyElement: propertyElement, tenants: tenants));
              },
              label: 'Tenant Family',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xff314B8C)),
          SpeedDialChild(
              child: Icon(Icons.person, color: Colors.white),
              backgroundColor: Color(0xff314B8C),
              onTap: () {
                Routing.makeRouting(context,
                    routeMethod: 'push',
                    newWidget:
                        AddTenantScreen(propertyElement: propertyElement));
              },
              label: 'Tenant',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xff314B8C)),
        ],
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

  Widget subHeadingWidget(BuildContext context, String title) {
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
                  .map((e) => DataRow(cells: [
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
                        DataCell(TextFormField(
                          initialValue: e.value.remarks,
                          onChanged: (value) {
                            setState(() {
                              e.value.remarks = value;
                            });
                          },
                        )),
                        DataCell(
                          photoPick(e.value.photo, index, e.key),
                        ),
                      ]))
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
                      inspectType: "Move out Inspection",
                    );
                    Routing.makeRouting(
                      context,
                      routeMethod: 'pushReplacement',
                      newWidget: CaptureScreenMoveIn(
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
                inspectType: "Move in Inspection",
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
                    content: Text("Move In Inspection added successfully!"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Move In Inspection addition failed!"),
                  ),
                );
              }
            },
            child: Text(
              "Move In Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          );
  }
}
