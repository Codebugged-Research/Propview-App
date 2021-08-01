import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/models/RegularInspectionRow.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/customRoomSubRoom.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/widgets/alertWidget.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showRoomSelect();
        },
        child: Icon(Icons.add),
      ),
      body: Container(
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
                ListView.builder(
                    itemCount: regularInspectionRowList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return inspectionCard(index);
                    }),
                buttonWidget(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  inspectionCard(index) {
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
                  .headline4
                  .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            titleWidget(context, 'Bill Dues'),
            inputWidget(regularInspectionRowList[index].billDues),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            titleWidget(context, 'Termite Check'),
            inputWidget(regularInspectionRowList[index].termiteCheck),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            titleWidget(context, 'See-Page Check'),
            inputWidget(regularInspectionRowList[index].seepageCheck),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            titleWidget(context, 'General Clealiness'),
            inputWidget(regularInspectionRowList[index].generalCleanliness),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            titleWidget(context, 'Other Issues'),
            inputWidget(regularInspectionRowList[index].otherIssue),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          ],
        ));
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
                      billDues: "",
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

  Widget inputWidget(object) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            object = value;
          });
        },
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
                print(regularInspectionRowList[i].toJson());
                //TODO: regularInspectionRowList[i] createapi for regularInspectionRow and get the id of the
                // rowIdist.add(id);
              }
              regularInspection.rowList = rowIdist.join(",");
              // TODO: regularInspection create api and return boolean bellow
              bool result = true;
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
              "Add Regular Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          );
  }
}
