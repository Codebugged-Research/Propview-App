import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:propview/config.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Facility.dart';
import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/Tenant.dart';
import 'package:propview/models/TenantFamily.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/customRoomSubRoom.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/billPropertyService.dart';
import 'package:propview/services/facilityService.dart';
import 'package:propview/services/inspectionService.dart';
import 'package:propview/services/issueService.dart';
import 'package:propview/services/issueTableService.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/services/tenantService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/Inspection/MoveOutInspection/MoveOutInspectionHistory.dart';
import 'package:propview/views/Admin/Inspection/MoveOutInspection/captureScreenMoveOut.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';
import 'package:propview/views/Admin/widgets/fullInspectionCard.dart';
import 'package:propview/views/Admin/widgets/moveOutInspectionCard.dart';
import 'package:propview/views/Admin/widgets/tenantWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoveOutInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<List<Issue>> rows;
  final List<IssueTableData> issueTableList;
  final List<List<List<String>>> imageList;
  final List<BillToProperty> bills;

  MoveOutInspectionScreen({
    this.bills,
    this.propertyElement,
    this.rows,
    this.issueTableList,
    this.imageList,
  });

  @override
  _MoveOutInspectionScreenState createState() =>
      _MoveOutInspectionScreenState();
}

class _MoveOutInspectionScreenState extends State<MoveOutInspectionScreen> {
  bool isLoading = false;

  PropertyElement propertyElement;
  SharedPreferences prefs;
  Inspection inspection;
  RoomType roomTypes;

  List<RoomsToPropertyModel> rooms = [];
  List<SubRoomElement> subRooms = [];
  List<CustomRoomSubRoom> roomsAvailable = [];
  CustomRoomSubRoom selectedRoomSubRoom;
  List<List<Issue>> rows = [];
  List<IssueTableData> issueTableList = [];
  List<List<List<String>>> photoList = [];
  List<Tenant> tenants = [];
  List<TenantFamily> tenantFamily = [];
  List<Facility> facilityList = [];
  List<BillToProperty> bills = [];

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    loadDataForScreen();
    initialiseSharedPreference();
  }

  initialiseSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    if (widget.bills != null) {
      bills = widget.bills;
    } else {
      bills = await BillPropertyService.getBillsByPropertyId(
          propertyElement.tableproperty.propertyId.toString());
    }
    photoList = widget.imageList ?? [];
    facilityList = await FacilityService.getFacilities();
    rows = widget.rows != null ? widget.rows : [];
    for (var i = 0; i < rows.length; i++) {
      photoList.add([]);
      for (var j = 0; j < rows[i].length; j++) {
        photoList[i].add([]);
        photoList[i][j] = rows[i][j].photo;
      }
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
    roomsAvailable.length > 0 ? selectedRoomSubRoom = roomsAvailable[0] : null;
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

  removeTenantFromProperty(String tenantId) async {
    try {
      List<String> tenantList =
          propertyElement.tableproperty.tenantId.split(",").toList();
      tenantList.remove(tenantId);
      propertyElement.tableproperty.tenantId = tenantList.join(",");
      var payload = json.encode(propertyElement.toJson());
      bool isUpdated = await PropertyService.updateProperty(
          payload, propertyElement.tableproperty.propertyId);
      if (isUpdated) {
        showInSnackBar(context, 'Tenant removed successfully!', 2500);
      } else {
        showInSnackBar(context, 'Tenant deletion failed! Try again.', 2500);
      }
    } catch (err) {
      showInSnackBar(context, 'Something went wrong! Try again.', 2500);
    }
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
          title: Text(
            'Move out Inspection',
            style: Theme.of(context)
                .primaryTextTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
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
                for (var i = 0; i < rows.length; i++) {
                  for (var j = 0; j < rows[i].length; j++) {
                    rows[i][j].photo = photoList[i][j];
                  }
                }
                var fullInspectionCacheData = json.encode({
                  "bills": bills,
                  "rows": rows,
                  "issueTableList": issueTableList
                }).toString();
                bool success = await prefs.setString(
                    "moveout-${propertyElement.tableproperty.propertyId}",
                    fullInspectionCacheData);
                if (success) {
                  showInSnackBar(context, "Move-out Inspection Saved", 800);
                } else {
                  showInSnackBar(
                      context, "Error Saving Move-Out Inspection", 800);
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
                    builder: (context) => MoveOutInspectionHistoryScreen(
                      propertyElement: widget.propertyElement,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? circularProgressWidget()
            : SingleChildScrollView(
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
                              height: 260,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: bills.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return FullInspectionCard(
                                    propertyElement: propertyElement,
                                    billToProperty: bills[index],
                                    editable: true,
                                  );
                                },
                              ),
                            ),
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
                                return Row(
                                  children: [
                                    InkWell(
                                      child: Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                      ),
                                      onTap: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  title: Text('Delete Tenant'),
                                                  content: Text(
                                                      'Are you sure you want to delete this tenant?'),
                                                  actions: [
                                                    MaterialButton(
                                                      child: Text('Yes'),
                                                      onPressed: () async {
                                                        await removeTenantFromProperty(
                                                            tenants[index]
                                                                .tenantId
                                                                .toString());
                                                      },
                                                    ),
                                                    MaterialButton(
                                                      child: Text('No'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ]);
                                            });
                                      },
                                    ),
                                    TenantWidget(
                                        tenant: tenants[index], index: index),
                                  ],
                                );
                              }),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return issueCard(index);
                        },
                        itemCount: issueTableList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
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

  Widget subHeadingWidget(BuildContext context, String title) {
    return Container(
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

  Widget issueCard(int tableindex) {
    return Column(
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
                  : issueRowCard(index, tableindex, issueTableList[tableindex]);
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
            photoList[tableindex].add([]);
            rows[tableindex].add(
              Issue(
                  issueName: "",
                  status: "Excelent",
                  remarks: "",
                  photo: photoList[tableindex][index]),
            );
          });
        },
      ),
    );
  }

  Widget issueRowCard(
      int index, int tableindex, IssueTableData issueTableData) {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      List<int> lint = [];
                      if (issueTableData.issub == 1) {
                        SubRoomElement subRoom =
                            await SubRoomService.getSubRoomById(
                                issueTableData.roomsubroomId);
                        print(subRoom.facility);
                        List<String> lstring = subRoom.facility.split(",");
                        lint = lstring.map(int.parse).toList();
                        showCardEdit(rows[tableindex][index], lint);
                      } else {
                        RoomsToPropertyModel room =
                            await RoomService.getRoomById(
                                issueTableData.roomsubroomId);
                        List<String> lstring = room.facility.split(",");
                        lint = lstring.map(int.parse).toList();
                        showCardEdit(rows[tableindex][index], lint);
                      }
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

  showCardEdit(Issue issue, List<int> intList) {
    List<Facility> facilityList2 = [];
    facilityList.forEach((element) {
      if (intList.contains(element.facilityId)) {
        facilityList2.add(element);
      }
    });
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Color(0xFFFFFFFF),
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {},
            builder: (BuildContext context) => StatefulBuilder(
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
                      DropdownButtonFormField(
                        decoration: new InputDecoration(
                          icon: Icon(Icons.hvac),
                        ), //, color: Colors.white10
                        value: issue.issueName == ""
                            ? facilityList2[0].facilityName
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
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: TextFormField(
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
                            Navigator.pop(context);
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
            }),
          );
        });
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
                        builder: (context) => CaptureScreenMoveOut(
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

  bool loading = false;

  Widget buttonWidget(BuildContext context) {
    return loading
        ? circularProgressWidget()
        : MaterialButton(
            minWidth: 360,
            height: 55,
            color: Color(0xff314B8C),
            onPressed: () async {
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
                              inspectType: "Move out Inspection",
                              propertyId: widget
                                  .propertyElement.tableproperty.propertyId,
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
                                // print(payload);
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
                              bills[i].lastUpdate = DateTime.now();
                              await BillPropertyService.updateBillProperty(
                                bills[i].id.toString(),
                                jsonEncode(
                                  bills[i].toJson(),
                                ),
                              );
                            }
                            setState(() {
                              loading = false;
                            });
                            if (result) {
                              await prefs.remove(
                                  "moveout-${propertyElement.tableproperty.propertyId}");
                              showInSnackBar(
                                  _scaffoldKey.currentContext,
                                  "Move Out Inspection added successfully!",
                                  500);
                              Future.delayed(Duration(milliseconds: 800), () {
                                Navigator.of(_scaffoldKey.currentContext).pop();
                                Navigator.of(_scaffoldKey.currentContext).pop();
                              });
                            } else {
                              showInSnackBar(_scaffoldKey.currentContext,
                                  "Move Out Inspection Addition unsuccessfull! ", 500);
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
              "Add Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          );
  }
}