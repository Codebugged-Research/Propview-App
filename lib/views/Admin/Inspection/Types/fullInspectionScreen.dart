import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
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
import 'package:propview/views/Admin/Inspection/FullInspection/FullInspectionHistory.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';
import 'package:propview/views/Admin/widgets/fullInspectionCard.dart';

import 'package:propview/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class FullInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<List<Issue>> rows;
  final List<IssueTableData> issueTableList;
  final List<String> imageList;
  final int index1;
  final int index2;
  List<BillToProperty> bills;

  FullInspectionScreen({
    this.bills,
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
  SharedPreferences prefs;

  // TextEditingController maintainanceController;

  PropertyElement propertyElement;
  List<RoomsToPropertyModel> rooms = [];
  List<SubRoomElement> subRooms = [];
  List<CustomRoomSubRoom> roomsAvailable = [];
  CustomRoomSubRoom selectedRoomSubRoom;
  List<List<Issue>> rows = [];
  List<IssueTableData> issueTableList = [];
  List<List<List<String>>> photoList = [];

  List<BillToProperty> bills = [];

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

  String dummyDouble = (0.0).toString();

  getData() async {
    setState(() {
      loader = true;
      propertyElement = widget.propertyElement;
    });
    if (widget.bills != null) {
      bills = widget.bills;
    } else {
      bills = await BillPropertyService.getBillsByPropertyId(
          propertyElement.tableproperty.propertyId.toString());
    }
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
    roomsAvailable.length > 0 ? selectedRoomSubRoom = roomsAvailable[0] : null;
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.save,
                color: Color(0xff314b8c),
              ),
              onPressed: () {
                inspection = Inspection(
                  inspectType: "Full Inspection",
                );
                var fullInspectionCacheData = json.encode({
                  "imageList": photoList,
                  "bills": bills,
                  "rows": rows,
                  "issueTableList": issueTableList
                }).toString();
                prefs.setString(
                    "full-${propertyElement.tableproperty.propertyId}",
                    fullInspectionCacheData);
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
        body: loader
            ? circularProgressWidget()
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      bills.length != 0
                          ? Container(
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
                            )
                          : SizedBox(),
                      bills.length != 0
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01)
                          : SizedBox(),
                      bills.length == 0
                          ? SizedBox()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: bills.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return FullInspectionCard(
                                  propertyElement: propertyElement,
                                  billToProperty: bills[index],
                                );
                              },
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ListView.builder(
                        itemCount: issueTableList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return issueCard(index);
                        },
                      ),
                      issueTableList.length >= roomsAvailable.length
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
                        height: MediaQuery.of(context).size.height * 0.02,
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
                propertyId: widget.propertyElement.tableproperty.propertyId,
                employeeId: user.userId,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
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

  showCardEdit(Issue issue) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Color(0xFFFFFFFF),
        builder: (BuildContext context) {
          return  StatefulBuilder(
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
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6,
                              )),
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
                            'Issue: ',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          TextFormField(
                            initialValue: issue.issueName,
                            onChanged: (value) {
                              this.setState(() {
                                issue.issueName = value;
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
                            items: ["Excelent", "Good", "Bad", "Broken"]
                                .map<DropdownMenuItem>((String value) {
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
                          TextFormField(
                            initialValue: issue.issueName,
                            onChanged: (value) {
                              this.setState(() {
                                issue.issueName = value;
                              });
                            },
                          ),
                          SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                });
        });
  }

  Widget issueCard(int tableindex) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleWidget(
              context, issueTableList[tableindex].roomsubroomName, tableindex),
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
                    ? addRowButton(tableindex, index)
                    : issueRowCard(index, tableindex);
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
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
            photoList[tableindex].add([]);
            rows[tableindex].add(
              Issue(
                  issueName: "dsaaa dsa dsad sa sad dsa dsa d",
                  status: "Excelent",
                  remarks: "dsa a sdsa das d asda sdsa d sad asd sad",
                  photo: photoList[tableindex][index]),
            );
          });
        },
      ),
    );
  }

  Widget photoPick(List<String> list, int index1) {
    return Container(
      width: 120,
      height: 50,
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
                  child: Icon(Icons.add),
                )
              : InkWell(
                  child: Image.file(
                    File(list[index]),
                    height: 60,
                    width: 45,
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
            setState(() {
              issueTableList.removeAt(index);
              rows.removeAt(index);
              photoList.removeAt(index);
            });
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        )
      ],
    );
  }

  Widget issueRowCard(int index, int tableindex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 220,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      showCardEdit(rows[tableindex][index]);
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        rows[tableindex].removeAt(index);
                        photoList.remove(tableindex);
                      });
                      print(rows[tableindex][index].toJson());
                      print(photoList[tableindex].toString());
                      print(index);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Issue: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  Flexible(
                    child: Text(
                      "$tableindex - $index" +
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
                      maxLines: 2,
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
                  photoPick(photoList[tableindex][index], index),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class EditModalSheet extends StatefulWidget {
  Issue issue;
  EditModalSheet({Key key, @required this.issue}) : super(key: key);

  @override
  _EditModalSheetState createState() => _EditModalSheetState();
}

class _EditModalSheetState extends State<EditModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
              'Item: ',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            TextFormField(
              initialValue: widget.issue.issueName,
              onChanged: (value) {
                setState(() {
                  widget.issue.issueName = value;
                });
              },
            ),
            SizedBox(height: 4),
            Text(
              'Status: ',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            DropdownButtonFormField(
              decoration: new InputDecoration(
                icon: Icon(Icons.hvac),
              ), //, color: Colors.white10
              value: widget.issue.status,
              items: ["Excelent", "Good", "Bad", "Broken"]
                  .map<DropdownMenuItem>((String value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  widget.issue.status = newValue;
                });
              },
            ),
            SizedBox(height: 4),
            Text(
              'Remarks: ',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            TextFormField(
              initialValue: widget.issue.issueName,
              onChanged: (value) {
                setState(() {
                  widget.issue.issueName = value;
                });
              },
            ),
            SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
