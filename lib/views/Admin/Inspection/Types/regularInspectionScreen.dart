import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/models/RegularInspectionRow.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/customRoomSubRoom.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
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
                Text(
                  "RoomWise Inspection",
                  style: Theme.of(context).primaryTextTheme.headline4.copyWith(
                      fontWeight: FontWeight.w700, color: Colors.black),
                ),
                ListView.builder(
                    itemCount: count,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return inspectionCard(index);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  inspectionCard(index) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleWidget(context, regularInspectionRowList[index].roomsubroomName),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        titleWidget(context, 'Bill Dues'),
        inputWidget(object),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        titleWidget(context, 'Termite Check'),
        inputWidget(object),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        titleWidget(context, 'See-Page Check'),
        inputWidget(object),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        titleWidget(context, 'General Clealiness'),
        inputWidget(object),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        titleWidget(context, 'Other Issues'),
        inputWidget(object),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        buttonWidget(context),
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
                    count++;
                    regularInspectionRowList.add(RegularInspectionRow(
                      id: 0,
                      billDues: "",
                      termiteCheck: "",
                      seepageCheck: "",
                      generalCleanliness: "",
                      otherIssue: "",
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
              // User user = await UserService.getUser();
              // inspection = Inspection(
              //   inspectionId: 0,
              //   inspectType: "Full Inspection",
              //   maintenanceCharges: double.parse(maintainanceController.text),
              //   commonAreaElectricity: double.parse(commonAreaController.text),
              //   electricitySociety:
              //       double.parse(electricitySocietyController.text),
              //   electricityAuthority:
              //       double.parse(electricityAuthorityController.text),
              //   powerBackup: double.parse(powerController.text),
              //   pngLgp: double.parse(pngController.text),
              //   club: double.parse(clubController.text),
              //   water: double.parse(waterController.text),
              //   propertyTax: double.parse(propertyTaxController.text),
              //   anyOther: double.parse(anyOtherController.text),
              //   propertyId: widget.propertyElement.tableproperty.propertyId,
              //   employeeId: user.userId,
              //   createdAt: DateTime.now(),
              //   updatedAt: DateTime.now(),
              // );
              // // print(inspection.toJson());
              // List tempIssueTableList = [];
              // for (int i = 0; i < rows.length; i++) {
              //   List issueRowList = [];
              //   for (int j = 0; j < rows[i].length; j++) {
              //     List<String> finalPhotoList = [];
              //     for (int k = 0; k < rows[i][j].photo.length; k++) {
              //       String tempUrl = await upload(
              //           rows[i][j].photo[k],
              //           widget.propertyElement.tableproperty.propertyId
              //               .toString());
              //       finalPhotoList.add(tempUrl);
              //     }
              //     var payload = {
              //       "issue_id": 0,
              //       "issue_name": rows[i][j].issueName,
              //       "status": rows[i][j].status,
              //       "remarks": rows[i][j].remarks,
              //       "photo": finalPhotoList.join(","),
              //       "createdAt": DateTime.now().toString(),
              //       "updatedAt": DateTime.now().toString(),
              //     };
              //     // print(payload);
              //     var result =
              //         await IssueService.createIssue(jsonEncode(payload));
              //     issueRowList.add(result);
              //   }
              //   var payload1 = {
              //     "id": 0,
              //     "roomsubroom_id": issueTableList[i].roomsubroomId,
              //     "roomsubroom_name": issueTableList[i].roomsubroomName,
              //     "issub": issueTableList[i].issub,
              //     "issue_row_id": issueRowList.join(","),
              //     "property_id":
              //         widget.propertyElement.tableproperty.propertyId,
              //     "created_at": DateTime.now().toString(),
              //     "updated_at": DateTime.now().toString(),
              //   };
              //   var result = await IssueTableService.createIssueTable(
              //       jsonEncode(payload1));
              //   tempIssueTableList.add(result);
              // }
              // inspection.issueIdList = tempIssueTableList.join(",");
              // print(inspection.toJson());
              // bool result = await InspectionService.createInspection(
              //     jsonEncode(inspection.toJson(),),);
              setState(() {
                loading = false;
              });
              // if (result) {
              //   Navigator.of(context).pop();
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text("Full Inspection added"),
              //     ),
              //   );
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text("Full Inspection addition failed!"),
              //     ),
              //   );
              // }
            },
            child: Text(
              "Add Regular Inspection",
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          );
  }
}
