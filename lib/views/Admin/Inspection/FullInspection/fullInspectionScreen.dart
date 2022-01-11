// ignore_for_file: missing_required_param

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:propview/models/BillType.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Facility.dart';
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
import 'package:propview/services/BillTypeService.dart';
import 'package:propview/services/facilityService.dart';
import 'package:propview/services/inspectionService.dart';
import 'package:propview/services/issueService.dart';
import 'package:propview/services/issueTableService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/Inspection/FullInspection/CaptureFullInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/FullInspection/FullInspectionHistory.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';

import 'package:propview/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class FullInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<List<Issue>> rows;
  final List<IssueTableData> issueTableList;
  final List<double> newBillAmounts;

  FullInspectionScreen({
    this.newBillAmounts,
    this.propertyElement,
    this.rows,
    this.issueTableList,
  });

  @override
  _FullInspectionScreenState createState() => _FullInspectionScreenState();
}

class _FullInspectionScreenState extends State<FullInspectionScreen> {
  Inspection inspection;
  SharedPreferences prefs;
  PropertyElement propertyElement;
  List<RoomsToPropertyModel> rooms = [];
  List<SubRoomElement> subRooms = [];
  List<CustomRoomSubRoom> roomsAvailable = [];
  List<CustomRoomSubRoom> roomsAvailable2 = [];
  CustomRoomSubRoom selectedRoomSubRoom;
  List<List<Issue>> rows = [];
  List<IssueTableData> issueTableList = [];
  List<Facility> facilityList = [];
  List<BillToProperty> bills = [];
  List<double> newBillAmounts = [];
  RoomType roomTypes;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    initialiseSharedPreference();
    getData();
  }

  initialiseSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  List<String> billTypeList = [];
  List<BillType> billTypes = [];
  List<TextEditingController> _billControllers = [];

  getData() async {
    setState(() {
      loader = true;
      propertyElement = widget.propertyElement;
    });
    billTypes = await BillTypeService.getAllBillTypes();
    if (widget.newBillAmounts != null) {
      newBillAmounts = widget.newBillAmounts;
    } else {
      newBillAmounts = [];
    }
    bills = await BillPropertyService.getBillsByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    for (int i = 0; i < bills.length; i++) {
      var type = billTypes
          .firstWhere(
            (element) => element.billTypeId == bills[i].billTypeId,
          )
          .billName;
      billTypeList.add(type);
      if (newBillAmounts.length <= bills.length) {
        newBillAmounts.add(0.0);
      }
    }
    facilityList = await FacilityService.getFacilities();
    rows = widget.rows != null ? widget.rows : [];
    issueTableList = widget.issueTableList != null ? widget.issueTableList : [];
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
                " of " +
                getRoomName(rooms[i].roomId),
          ));
        });
      }
    }
    setState(() {
      roomsAvailable2.addAll(roomsAvailable);
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
  bool saveLoader = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Full Inspection",
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                color: Color(0xff314b8c),
              ),
              onPressed: () async {
                setState(() {
                  saveLoader = true;
                });
                var fullInspectionCacheData = json.encode({
                  "rows": rows,
                  "newBillAmounts": newBillAmounts,
                  "issueTableList": issueTableList,
                }).toString();
                bool success = await prefs.setString(
                    "full-${propertyElement.tableproperty.propertyId}",
                    fullInspectionCacheData);
                if (success) {
                  showInSnackBar(context, "Full Inspection Saved", 1600);
                } else {
                  showInSnackBar(context, "Error Saving Full Inspection", 1600);
                }
                setState(() {
                  saveLoader = false;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.history_outlined,
                color: Color(0xff314b8c),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullInspectionHistoryScreen(
                      propertyElement: widget.propertyElement,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: loader
            ? circularProgressWidget()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      bills.length != 0
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff314B8C).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                  "Pending Bills",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline6
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                ),
                              ),
                            )
                          : SizedBox(),
                      bills.length == 0
                          ? SizedBox()
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.95,
                              height: 310,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: bills.length,
                                itemBuilder: (BuildContext context, int index) {
                                  _billControllers.add(TextEditingController(
                                    text: newBillAmounts[index].toString(),
                                  ));
                                  return billCard(index);
                                },
                              ),
                            ),
                      ListView.builder(
                        itemCount: issueTableList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return issueCard(index);
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      issueTableList.length >= roomsAvailable2.length
                          ? SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select Room',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline6
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black),
                                ),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color(0xff314b8c),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    showRoomSelect();
                                  },
                                )
                              ],
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      issueTableList.length > 0
                          ? buttonWidget(context)
                          : SizedBox(),
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

  Widget billCard(int index) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.15)),
            BoxShadow(
                offset: Offset(-2, 2),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.15))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Bill Type:  ',
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Flexible(
                  child: Text(
                    billTypeList[index],
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle1
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bill Authority:  ',
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Flexible(
                  child: Text(
                    bills[index].authorityName,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle1
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bill No:  ',
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Flexible(
                  child: Text(
                    bills[index].billId,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle1
                        .copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Row(
              children: [
                Text(
                  'Added On:  ',
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Text(
                  dateChange(bills[index].dateAdded.toLocal()),
                  style: Theme.of(context)
                      .primaryTextTheme
                      .subtitle1
                      .copyWith(color: Colors.black),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Row(
              children: [
                Text(
                  'Last Amount:  ',
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Text(
                  bills[index].amount.toString(),
                  style: Theme.of(context)
                      .primaryTextTheme
                      .subtitle1
                      .copyWith(color: Colors.black),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Row(
              children: [
                Text(
                  'Last Update On:  ',
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Text(
                  dateChange(bills[index].lastUpdate.toLocal()),
                  style: Theme.of(context)
                      .primaryTextTheme
                      .subtitle1
                      .copyWith(color: Colors.black),
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Text(
              'Amount',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.005),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _billControllers[index],
                onChanged: (value) {
                  newBillAmounts[index] = double.parse(value);
                },
                obscureText: false,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  filled: true,
                  prefix: Text("₹"),
                  hintText: 'Enter Amount',
                  fillColor: Colors.grey[300],
                  labelStyle:
                      TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
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
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ],
        ),
      ),
    );
  }

  dateChange(DateTime date) {
    return date.day.toString().padLeft(2, "0") +
        "-" +
        date.month.toString().padLeft(2, "0") +
        "-" +
        date.year.toString();
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
              FocusScope.of(context).unfocus();
              await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      content: Text(
                        "Are you sure you want to submit the inspection?",
                      ),
                      actions: [
                        MaterialButton(
                          child: Text("Yes"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            setState(() {
                              loading = true;
                            });
                            User user = await UserService.getUser();
                            inspection = Inspection(
                              inspectionId: 0,
                              inspectType: "Full Inspection",
                              propertyId: widget
                                  .propertyElement.tableproperty.propertyId,
                              employeeId: user.userId,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );
                            List tempIssueTableList = [];
                            for (int i = 0; i < rows.length; i++) {
                              List issueRowList = [];
                              for (int j = 0; j < rows[i].length; j++) {
                                List<String> finalPhotoList = [];
                                for (int k = 0;
                                    k < rows[i][j].photo.length;
                                    k++) {
                                  String tempUrl = await upload(
                                      rows[i][j].photo[k],
                                      widget.propertyElement.tableproperty
                                          .propertyId
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
                                var result = await IssueService.createIssue(
                                    jsonEncode(payload));
                                issueRowList.add(result);
                              }
                              var payload1 = {
                                "id": 0,
                                "roomsubroom_id":
                                    issueTableList[i].roomsubroomId,
                                "roomsubroom_name":
                                    issueTableList[i].roomsubroomName,
                                "issub": issueTableList[i].issub,
                                "issue_row_id": issueRowList.join(","),
                                "property_id": widget
                                    .propertyElement.tableproperty.propertyId,
                                "created_at": DateTime.now().toString(),
                                "updated_at": DateTime.now().toString(),
                              };
                              var result =
                                  await IssueTableService.createIssueTable(
                                      jsonEncode(payload1));
                              tempIssueTableList.add(result);
                            }
                            inspection.issueIdList =
                                tempIssueTableList.join(",");
                            bool result =
                                await InspectionService.createInspection(
                              jsonEncode(
                                inspection.toJson(),
                              ),
                            );
                            for (int i = 0; i < bills.length; i++) {
                              if (newBillAmounts[i] !=
                                  double.parse(
                                    bills[i]
                                        .amount
                                        .toString()
                                        .replaceAll(",", ""),
                                  )) {
                                bills[i].lastUpdate = DateTime.now();
                                await BillPropertyService.updateBillProperty(
                                  bills[i].id.toString(),
                                  jsonEncode(
                                    bills[i].toJson(),
                                  ),
                                );
                              }
                            }
                            setState(() {
                              loading = false;
                            });
                            if (result) {
                              await prefs.remove(
                                  "full-${propertyElement.tableproperty.propertyId}");
                              showInSnackBar(_scaffoldKey.currentContext,
                                  "Inspection Added Succesfully!", 500);
                              Future.delayed(Duration(milliseconds: 800), () {
                                Navigator.of(_scaffoldKey.currentContext).pop();
                                Navigator.of(_scaffoldKey.currentContext).pop();
                              });
                            } else {
                              showInSnackBar(_scaffoldKey.currentContext,
                                  "Inspection Addition unsuccessfull! ", 500);
                            }
                          },
                        ),
                        MaterialButton(
                          child: Text("No"),
                          onPressed: () {
                            setState(() {
                              loading = false;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Text(
              "Submit Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          );
  }

  showRoomSelect() {
    roomsAvailable.clear();
    roomsAvailable.addAll(roomsAvailable2);
    issueTableList.forEach((elementx) {
      roomsAvailable.removeWhere(
          (element) => element.propertyRoomSubRoomId == elementx.roomsubroomId);
    });
    roomsAvailable.add(
      CustomRoomSubRoom(
        isSubroom: false,
        propertyRoomSubRoomId: 9999999999999,
        roomSubRoomName: "Choose Room/Subroom",
      ),
    );
    selectedRoomSubRoom = roomsAvailable.last;
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Color(0xFFFFFFFF),
        builder: (BuildContext context) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
                      if (newValue.roomSubRoomName == "Choose Room/Subroom") {
                        Routing.makeRouting(context, routeMethod: 'pop');
                        showInSnackBar(context,
                            "Please choose a valid Room/SubRoom!", 1400);
                      } else {
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
                        });
                        Routing.makeRouting(context, routeMethod: 'pop');
                      }
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
            ),
          );
        });
  }

  showCardEdit(Issue issue, List<int> intList, int tableindex) {
    List<Facility> facilityList2 = [];
    facilityList.forEach((element) {
      if (intList.contains(element.facilityId)) {
        facilityList2.add(element);
      }
    });
    rows[tableindex].forEach((elementx) {
      facilityList2
          .removeWhere((element) => element.facilityName == elementx.issueName);
    });
    facilityList2.add(
      Facility(facilityId: 84, facilityName: "Not Selected"),
    );
    return showModalBottomSheet(
        context: context,
        // isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Color(0xFFFFFFFF),
        builder: (BuildContext context) {
          bool errorloading = false;
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Edit Issue Entry',
                            style: Theme.of(context).primaryTextTheme.headline6,
                          )),
                      errorloading
                          ? Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Choose atlest one Particular and one valid Status',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ))
                          : SizedBox(),
                      Align(
                          alignment: Alignment.center,
                          child: Divider(
                            color: Color(0xff314B8C),
                            thickness: 2.5,
                            indent: 100,
                            endIndent: 100,
                          )),
                      SizedBox(height: 4),
                      Text(
                        'Particular: ',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle1
                            .copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      DropdownButtonFormField(
                        decoration: new InputDecoration(
                          icon: Icon(Icons.hvac),
                        ), //, color: Colors.white10
                        value: issue.issueName == ""
                            ? "Not Selected"
                            : issue.issueName,
                        items: facilityList2
                            .map<DropdownMenuItem>((Facility value) {
                          return DropdownMenuItem(
                            value: value.facilityName,
                            child: Text(value.facilityName),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          this.setState(() {
                            issue.issueName = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Status: ',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle1
                            .copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      DropdownButtonFormField(
                        decoration: new InputDecoration(
                          icon: Icon(Icons.hvac),
                        ), //, color: Colors.white10
                        value: issue.status,
                        items: [
                          "Average",
                          "Clean",
                          "Dirty",
                          "Not Selected",
                          "Not Working",
                          "Working"
                        ].map<DropdownMenuItem>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          this.setState(() {
                            issue.status = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Remarks: ',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle1
                            .copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
                          minLines: 5,
                          maxLines: 8,
                          initialValue: issue.remarks,
                          onChanged: (value) {
                            this.setState(() {
                              issue.remarks = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 4),
                      Align(
                        alignment: Alignment.center,
                        child: MaterialButton(
                          onPressed: () {
                            if (issue.issueName == "Not Selected" ||
                                issue.status == "Not Selected") {
                              setState(() {
                                errorloading = true;
                              });
                              Future.delayed(Duration(milliseconds: 3200), () {
                                setState(() {
                                  errorloading = false;
                                });
                              });
                            } else {
                              Navigator.pop(context);
                              FocusScope.of(context).unfocus();
                            }
                          },
                          color: Color(0xFF314B8C),
                          child: Text(
                            'Submit',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  issueCard(int tableindex) {
    List<int> lint = [];
    if (issueTableList[tableindex].issub == 1) {
      SubRoomElement subRoom = subRooms.firstWhere((element) =>
          element.propertySubRoomId ==
          issueTableList[tableindex].roomsubroomId);
      List<String> lstring = subRoom.facility.split(",");
      lint = lstring.map(int.parse).toList();
    } else {
      RoomsToPropertyModel room = rooms.firstWhere((element) =>
          element.propertyRoomId == issueTableList[tableindex].roomsubroomId);
      List<String> lstring = room.facility.split(",");
      lint = lstring.map(int.parse).toList();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        titleWidget(
            context,
            issueTableList[tableindex].roomsubroomName +
                '(${rows[tableindex].length}/${lint.length})',
            tableindex),
        SizedBox(
          height: 8,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: rows[tableindex].length + 1,
            itemBuilder: (context, index) {
              return index == rows[tableindex].length
                  ? lint.length == index
                      ? SizedBox()
                      : addRowButton(tableindex, index)
                  : issueRowCard(
                      index, tableindex, issueTableList[tableindex], lint);
            },
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget addRowButton(int tableindex, int index) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        color: Colors.blueAccent,
        icon: Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          setState(() {
            rows[tableindex].add(
              Issue(
                issueName: "Not Selected",
                status: "Not Selected",
                remarks: "",
                photo: [],
              ),
            );
          });
        },
      ),
    );
  }

  Widget photoPick(List<String> list, int index1) {
    return Container(
      width: 120,
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          return index == list.length
              ? InkWell(
                  onTap: () async {
                    var tempList = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CaptureFullInspectionScreen(
                          imageList: list,
                        ),
                      ),
                    );
                    setState(() {
                      list = tempList;
                    });
                  },
                  child: Container(
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add),
                  ),
                )
              : InkWell(
                  child: Image.file(
                    File(list[index]),
                    height: 60,
                    width: 45,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete'),
                        content:
                            Text('Are you sure you want to delete this image?'),
                        actions: <Widget>[
                          MaterialButton(
                            child: Text('Yes'),
                            onPressed: () {
                              setState(() {
                                list.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          MaterialButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget titleWidget(BuildContext context, String title, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff314B8C).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            title,
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to delete this issue?'),
                actions: <Widget>[
                  MaterialButton(
                    child: Text('Yes'),
                    onPressed: () {
                      setState(() {
                        issueTableList.removeAt(index);
                        rows.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                  ),
                  MaterialButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget issueRowCard(
    int index,
    int tableindex,
    IssueTableData issueTableData,
    List<int> lint,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.15)),
            BoxShadow(
                offset: Offset(-2, 2),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.15))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      showCardEdit(rows[tableindex][index], lint, tableindex);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Edit",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text(
                              "This will delete the particular issue and all the photos attached to it"),
                          actions: [
                            MaterialButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            MaterialButton(
                              child: Text("Delete"),
                              onPressed: () {
                                setState(() {
                                  rows[tableindex].removeAt(index);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Delete",
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.withOpacity(0.5),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Particular: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  Flexible(
                    child: Text(
                      rows[tableindex][index].issueName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Status: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  Flexible(
                    child: Text(
                      rows[tableindex][index].status,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remarks: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  Flexible(
                    child: Text(
                      rows[tableindex][index].remarks,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Photo: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  photoPick(rows[tableindex][index].photo, index),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
