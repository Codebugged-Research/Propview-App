import 'dart:convert';

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
import 'package:propview/services/BillTypeService.dart';
import 'package:propview/services/regulationInspectionRowService.dart';
import 'package:propview/services/regulationInspectionService.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/Inspection/RegularInspection/regularInspectionHistoryScreen.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegularInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<RegularInspectionRow> regularInspectionRowList;
  final List<double> newBillAmounts;

  const RegularInspectionScreen({
    this.newBillAmounts,
    this.propertyElement,
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
  List<TextEditingController> _billControllers = [];

  List<RegularInspectionRow> regularInspectionRowList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  loadDataForScreen() async {
    setState(() {
      loader = true;
      propertyElement = widget.propertyElement;
    });
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
        newBillAmounts.add(0.0);
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

  bool saveLoader = false;

  getRoomName(id) {
    PropertyRoom room = roomTypes.data.propertyRoom
        .where((element) => element.roomId == id)
        .first;
    return room.roomName;
  }

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
                setState(() {
                  saveLoader = true;
                });
                var fullInspectionCacheData = json.encode({
                  "newBillAmounts": newBillAmounts,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    _billControllers.add(TextEditingController(
                                      text: newBillAmounts[index].toString(),
                                    ));
                                    return billCard(index);
                                  }),
                            ),
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
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      regularInspectionRowList.length > 0
                          ? buttonWidget(context)
                          : Container(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
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
    return Container(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Termite Issue:',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            SizedBox(
              height: 4,
            ),
            TextFormField(
              initialValue: regularInspectionRowList[index].termiteCheck,
              onChanged: (value) {
                setState(() {
                  regularInspectionRowList[index].termiteCheck = value;
                });
              },
              decoration: decoration,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'Seepage Check:',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            SizedBox(
              height: 4,
            ),
            TextFormField(
              initialValue: regularInspectionRowList[index].seepageCheck,
              onChanged: (value) {
                setState(() {
                  regularInspectionRowList[index].seepageCheck = value;
                });
              },
              decoration: decoration,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'General Cleanliness:',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            SizedBox(
              height: 4,
            ),
            TextFormField(
              initialValue: regularInspectionRowList[index].generalCleanliness,
              onChanged: (value) {
                setState(() {
                  regularInspectionRowList[index].generalCleanliness = value;
                });
              },
              decoration: decoration,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              'Other Issues:',
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            SizedBox(
              height: 4,
            ),
            TextFormField(
              initialValue: regularInspectionRowList[index].otherIssue,
              onChanged: (value) {
                setState(() {
                  regularInspectionRowList[index].otherIssue = value;
                });
              },
              decoration: decoration,
            ),
            SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
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
                                Navigator.of(_scaffoldKey.currentContext).pop();
                                Navigator.of(_scaffoldKey.currentContext).pop();
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
            },
            child: Text(
              "Submit Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          );
  }
}
