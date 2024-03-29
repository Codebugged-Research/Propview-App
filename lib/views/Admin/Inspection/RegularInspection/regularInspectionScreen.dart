import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:propview/config.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/models/RegularInspectionRow.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/Tenant.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/customRoomSubRoom.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/billPropertyService.dart';
import 'package:propview/services/BillTypeService.dart';
import 'package:propview/services/regulationInspectionRowService.dart';
import 'package:propview/services/regulationInspectionService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/services/tenantService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/Inspection/FullInspection/CaptureFullInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/RegularInspection/regularInspectionHistoryScreen.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';
import 'package:propview/views/Admin/widgets/tenantWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegularInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<RegularInspectionRow> regularInspectionRowList;
  final List<double> newBillAmounts;
  final String summary;

  const RegularInspectionScreen({
    this.newBillAmounts,
    this.propertyElement,
    this.summary,
    this.regularInspectionRowList,
  });

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

  List<RoomsToPropertyModel> rooms = [];
  List<SubRoomElement> subRooms = [];
  List<CustomRoomSubRoom> roomsAvailable = [];
  List<CustomRoomSubRoom> roomsAvailable2 = [];
  CustomRoomSubRoom selectedRoomSubRoom;
  TextEditingController billDuesController;
  TextEditingController termiteCheckController;
  TextEditingController seePageController;
  TextEditingController generalCleanlinessController;
  TextEditingController otherIssueController;
  List<BillToProperty> bills = [];
  List<double> newBillAmounts = [];
  TextEditingController _summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialiseSharedPreference();
    loadDataForScreen();
  }

  SharedPreferences prefs;

  initialiseSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
    print("exit");
  }

  List<String> billTypeList = [];
  List billTypes = [];
  List<Tenant> tenants = [];
  List<TextEditingController> _billControllers = [];

  List<RegularInspectionRow> regularInspectionRowList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  loadDataForScreen() async {
    setState(() {
      loader = true;
      propertyElement = widget.propertyElement;
    });
    _summaryController.text = widget.summary ?? "";
    billTypes = await BillTypeService.getAllBillTypes();
    bills = await BillPropertyService.getBillsByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    if (widget.newBillAmounts != null) {
      newBillAmounts = widget.newBillAmounts;
    } else {
      newBillAmounts = [];
    }
    for (int i = 0; i < bills.length; i++) {
      var type = billTypes
          .firstWhere(
            (element) => element.billTypeId == bills[i].billTypeId,
          )
          .billName;
      billTypeList.add(type);
      if (newBillAmounts.length <= bills.length) {
        newBillAmounts.add(0.00);
      }
    }
    regularInspectionRowList = widget.regularInspectionRowList ?? [];
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
        },
      );
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
                getRoomName(subRooms[i].roomId),
          ));
        });
      }
    }
    List<String> tenantList =
        propertyElement.tableproperty.tenantId.split(",").toList();
    for (var tenantId in tenantList) {
      Tenant tenant = await TenantService.getTenant(tenantId);
      setState(() {
        tenants.add(tenant);
      });
    }
    setState(() {
      roomsAvailable2.addAll(roomsAvailable);
      loader = false;
    });
  }

  bool saveLoader = false;
  bool showSummary = false;

  getRoomName(id) {
    PropertyRoom room = roomTypes.data.propertyRoom
        .where((element) => element.roomId == id)
        .first;
    return room.roomName;
  }

  saveData() async {
    setState(() {
      saveLoader = true;
    });
    var fullInspectionCacheData = json.encode({
      "newBillAmounts": newBillAmounts,
      "summary": _summaryController.text,
      "regularInspectionRowList": regularInspectionRowList
    }).toString();
    bool success = await prefs.setString(
        "regular-${propertyElement.tableproperty.propertyId}",
        fullInspectionCacheData);
    if (success) {
      showInSnackBar(context, "Regular Inspection Saved", 1600);
    } else {
      showInSnackBar(context, "Error Saving Regular Inspection", 1600);
    }
    setState(() {
      saveLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await saveData();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Regular Inspection",
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
                await saveData();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
                    builder: (context) => RegularInspectionHistoryScreen(
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
                                  "Pending Bills (${bills.length})",
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    _billControllers.add(TextEditingController(
                                      text: newBillAmounts[index] == 0
                                          ? ""
                                          : newBillAmounts[index]
                                              .toStringAsFixed(2),
                                    ));
                                    return billCard(index);
                                  }),
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
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
                                    tenant: tenants[index], index: index);
                              }),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ListView.builder(
                        itemCount: regularInspectionRowList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return inspectionCard(index);
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      regularInspectionRowList.length >= roomsAvailable2.length
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
                      showSummary
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Summary',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6
                                    .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                              ),
                            )
                          : SizedBox.shrink(),
                      showSummary
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            )
                          : SizedBox.shrink(),
                      showSummary
                          ? Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff314B8C).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    minLines: 5,
                                    maxLines: 8,
                                    controller: _summaryController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter Summary',
                                      hintStyle: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle2
                                          .copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                      regularInspectionRowList.length >= roomsAvailable2.length
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            )
                          : SizedBox(),
                      regularInspectionRowList.length >= roomsAvailable2.length
                          ? buttonWidget(context)
                          : SizedBox(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
      ),
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
                  'Bill Authority: ',
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
                  'Bill ID: ',
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
                  'Amount Due: ',
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Text(
                  bills[index].amount.toStringAsFixed(2),
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
                  'Last Updated: ',
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
              'Amount: ',
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

  Widget inspectionCard(int tableindex) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleWidget(context,
              regularInspectionRowList[tableindex].roomsubroomName, tableindex),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: 350,
            child: inspectionRowCard(tableindex),
          ),
        ],
      ),
    );
  }

  inspectionRowCard(int index) {
    return ListView(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
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
              children: [
                Text(
                  'Termite Issue:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  minLines: 14,
                  maxLines: 15,
                  initialValue: regularInspectionRowList[index].termiteCheck,
                  onChanged: (value) {
                    setState(() {
                      regularInspectionRowList[index].termiteCheck = value;
                    });
                  },
                  decoration: decoration,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
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
              children: [
                Text(
                  'Seepage Check:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  minLines: 14,
                  maxLines: 15,
                  initialValue: regularInspectionRowList[index].seepageCheck,
                  onChanged: (value) {
                    setState(() {
                      regularInspectionRowList[index].seepageCheck = value;
                    });
                  },
                  decoration: decoration,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
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
              children: [
                Text(
                  'General Cleanliness:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  minLines: 14,
                  maxLines: 15,
                  initialValue:
                      regularInspectionRowList[index].generalCleanliness,
                  onChanged: (value) {
                    setState(() {
                      regularInspectionRowList[index].generalCleanliness =
                          value;
                    });
                  },
                  decoration: decoration,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
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
              children: [
                Text(
                  'Other Issues:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  minLines: 14,
                  maxLines: 15,
                  initialValue: regularInspectionRowList[index].otherIssue,
                  onChanged: (value) {
                    setState(() {
                      regularInspectionRowList[index].otherIssue = value;
                    });
                  },
                  decoration: decoration,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.85,
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
              children: [
                Text(
                  'Photo:',
                  style: Theme.of(context).primaryTextTheme.headline5.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                SizedBox(
                  height: 4,
                ),
                photoPick(regularInspectionRowList[index].photo, index),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration decoration = InputDecoration(
    filled: true,
    hintText: 'Enter review',
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
  );

  showRoomSelect() {
    FocusScope.of(context).unfocus();
    roomsAvailable.clear();
    roomsAvailable.addAll(roomsAvailable2);
    regularInspectionRowList.forEach((elementx) {
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Color(0xFFFFFFFF),
      builder: (BuildContext context) {
        return Padding(
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
                    if (newValue.roomSubRoomName == "Choose Room/Subroom") {
                      Routing.makeRouting(context, routeMethod: 'pop');
                      showInSnackBar(
                          context, "Please choose a valid Room/SubRoom!", 1400);
                    } else {
                      setState(() {
                        selectedRoomSubRoom = newValue;
                        regularInspectionRowList.add(RegularInspectionRow(
                          id: 0,
                          termiteCheck: "",
                          seepageCheck: "",
                          generalCleanliness: "",
                          otherIssue: "",
                          photo: [],
                          issub: selectedRoomSubRoom.isSubroom == true ? 1 : 0,
                          roomsubroomId:
                              selectedRoomSubRoom.propertyRoomSubRoomId,
                          roomsubroomName: selectedRoomSubRoom.roomSubRoomName,
                          createdAt: DateTime.now(),
                        ));
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
      },
    );
  }

  Widget photoPick(List<String> list, int index1) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length + 1,
          itemBuilder: (context, index) {
            return index == list.length
                ? InkWell(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
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
                          content: Text(
                              'Are you sure you want to delete this image?'),
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
                        regularInspectionRowList.removeAt(index);
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

  bool loading = false;
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

  Widget buttonWidget(BuildContext context) {
    return loading
        ? circularProgressWidget()
        : MaterialButton(
            minWidth: 360,
            height: 55,
            color: Color(0xff314B8C),
            onPressed: () async {
              await saveData();
              int checker = 0;
              FocusScope.of(context).unfocus();
              for (int i = 0; i < regularInspectionRowList.length; i++) {
                if (regularInspectionRowList[i].termiteCheck != "" &&
                    regularInspectionRowList[i].seepageCheck != "" &&
                    regularInspectionRowList[i].generalCleanliness != "" &&
                    regularInspectionRowList[i].otherIssue != "") {
                  checker++;
                }
              }
              if (checker < roomsAvailable2.length &&
                  checker < regularInspectionRowList.length) {
                ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  content: new Text("Not all fields are filled properly"),
                  duration: Duration(milliseconds: 4000),
                  backgroundColor: Colors.red,
                ));
              } else if (!showSummary) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      content: Text(
                        "Do you want to add summary?",
                      ),
                      actions: [
                        MaterialButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              setState(() {
                                showSummary = true;
                              });
                              Navigator.of(context).pop();
                            }),
                        MaterialButton(
                          child: Text("No"),
                          onPressed: () async {
                            Navigator.of(context).pop();
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
                                    actions: <Widget>[
                                      MaterialButton(
                                        child: Text("Yes"),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            loading = true;
                                          });
                                          User user =
                                              await UserService.getUser();
                                          RegularInspection regularInspection =
                                              RegularInspection(
                                            id: 0,
                                            rowList: "",
                                            propertyId: widget.propertyElement
                                                .tableproperty.propertyId,
                                            employeeId: user.userId,
                                            summary: _summaryController.text,
                                            createdAt: DateTime.now(),
                                            updatedAt: DateTime.now(),
                                          );
                                          List rowIdist = [];
                                          for (int i = 0;
                                              i <
                                                  regularInspectionRowList
                                                      .length;
                                              i++) {
                                            List<String> finalPhotoList = [];
                                            for (int k = 0;
                                                k <
                                                    regularInspectionRowList[i]
                                                        .photo
                                                        .length;
                                                k++) {
                                              String tempUrl = await upload(
                                                  regularInspectionRowList[i]
                                                      .photo[k],
                                                  widget.propertyElement
                                                      .tableproperty.propertyId
                                                      .toString());
                                              finalPhotoList.add(tempUrl);
                                            }
                                            var payload = {
                                              "termite_check":
                                                  regularInspectionRowList[i]
                                                      .termiteCheck,
                                              "seepage_check":
                                                  regularInspectionRowList[i]
                                                      .seepageCheck,
                                              "general_cleanliness":
                                                  regularInspectionRowList[i]
                                                      .generalCleanliness,
                                              "other_issue":
                                                  regularInspectionRowList[i]
                                                      .otherIssue,
                                              "photo": finalPhotoList.join(","),
                                              "issub":
                                                  regularInspectionRowList[i]
                                                      .issub,
                                              "roomsubroom_id":
                                                  regularInspectionRowList[i]
                                                      .roomsubroomId,
                                              "roomsubroom_name":
                                                  regularInspectionRowList[i]
                                                      .roomsubroomName,
                                              "created_at": DateTime.now()
                                                  .toIso8601String(),
                                            };
                                            String id =
                                                await RegularInspectionRowService
                                                    .createRegularInspection(
                                              jsonEncode(
                                                payload,
                                              ),
                                            );
                                            rowIdist.add(id);
                                          }
                                          regularInspection.rowList =
                                              rowIdist.join(",");
                                          bool result =
                                              await RegularInspectionService
                                                  .createRegularInspection(
                                            jsonEncode(
                                              regularInspection.toJson(),
                                            ),
                                          );
                                          for (int i = 0;
                                              i < bills.length;
                                              i++) {
                                            if (newBillAmounts[i] !=
                                                double.parse(
                                                  bills[i]
                                                      .amount
                                                      .toString()
                                                      .replaceAll(",", ""),
                                                )) {
                                              bills[i].lastUpdate =
                                                  DateTime.now();
                                              await BillPropertyService
                                                  .updateBillProperty(
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
                                                "regular-${propertyElement.tableproperty.propertyId}");
                                            showInSnackBar(
                                                _scaffoldKey.currentContext,
                                                "Regular Inspection added successfully!",
                                                500);
                                            Future.delayed(
                                                Duration(milliseconds: 800),
                                                () {
                                              Navigator.of(_scaffoldKey
                                                      .currentContext)
                                                  .pop();
                                              Navigator.of(_scaffoldKey
                                                      .currentContext)
                                                  .pop();
                                            });
                                          } else {
                                            showInSnackBar(
                                                _scaffoldKey.currentContext,
                                                "Regular Inspection addition failed!",
                                                500);
                                          }
                                        },
                                      ),
                                      MaterialButton(
                                        child: Text("No"),
                                        onPressed: () async {
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
                        ),
                      ],
                    );
                  },
                );
              } else {
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
                        actions: <Widget>[
                          MaterialButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              setState(() {
                                loading = true;
                              });
                              User user = await UserService.getUser();
                              RegularInspection regularInspection =
                                  RegularInspection(
                                id: 0,
                                rowList: "",
                                propertyId: widget
                                    .propertyElement.tableproperty.propertyId,
                                employeeId: user.userId,
                                summary: _summaryController.text,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );
                              List rowIdist = [];
                              for (int i = 0;
                                  i < regularInspectionRowList.length;
                                  i++) {
                                String id = await RegularInspectionRowService
                                    .createRegularInspection(
                                  jsonEncode(
                                    regularInspectionRowList[i].toJson(),
                                  ),
                                );
                                rowIdist.add(id);
                              }
                              regularInspection.rowList = rowIdist.join(",");
                              bool result = await RegularInspectionService
                                  .createRegularInspection(
                                jsonEncode(
                                  regularInspection.toJson(),
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
                                    "regular-${propertyElement.tableproperty.propertyId}");
                                showInSnackBar(
                                    _scaffoldKey.currentContext,
                                    "Regular Inspection added successfully!",
                                    500);
                                Future.delayed(Duration(milliseconds: 800), () {
                                  Navigator.of(_scaffoldKey.currentContext)
                                      .pop();
                                  Navigator.of(_scaffoldKey.currentContext)
                                      .pop();
                                });
                              } else {
                                showInSnackBar(_scaffoldKey.currentContext,
                                    "Regular Inspection addition failed!", 500);
                              }
                            },
                          ),
                          MaterialButton(
                            child: Text("No"),
                            onPressed: () async {
                              setState(() {
                                loading = false;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            child: Text(
              "Submit Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          );
  }
}
