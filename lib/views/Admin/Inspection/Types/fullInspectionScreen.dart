import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/formModels/tempFullInscpectionModel.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:propview/views/Admin/widgets/photoCaptureScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  FullInspectionScreen({this.propertyElement});
  @override
  _FullInspectionScreenState createState() => _FullInspectionScreenState();
}

class _FullInspectionScreenState extends State<FullInspectionScreen> {
  PropertyElement propertyElement;

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
    getData();
    propertyElement = widget.propertyElement;
  }

  bool loader = false;
  getData() async {
    setState(() {
      loader = true;
    });
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loader = false;
    });
  }

  SharedPreferences prefs;
  List<Room> rooms = [
    Room(roomId: 1, roomName: "Room1"),
    Room(roomId: 2, roomName: "Room2"),
    Room(roomId: 3, roomName: "Room3"),
    Room(roomId: 4, roomName: "Room4"),
    Room(roomId: 5, roomName: "Room5"),
    Room(roomId: 6, roomName: "Room6"),
  ];
  List subRooms = [
    SubRoom(roomId: 1, subRoomId: 1, subRoomName: "room1sub1"),
    SubRoom(roomId: 1, subRoomId: 2, subRoomName: "room1sub2"),
    SubRoom(roomId: 2, subRoomId: 1, subRoomName: "room2sub1"),
    SubRoom(roomId: 3, subRoomId: 1, subRoomName: "room3sub1"),
    SubRoom(roomId: 3, subRoomId: 2, subRoomName: "room3sub2"),
    SubRoom(roomId: 4, subRoomId: 1, subRoomName: "room4sub1"),
    SubRoom(roomId: 6, subRoomId: 1, subRoomName: "room6sub1")
  ];

  List<List<DataRow>> rows = [[]];
  List headings = [];
  int count = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return loader
        ? CircularProgressIndicator()
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(),
            body: LayoutBuilder(
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
                      titleWidget(context, 'Maintenance Charges or CAM'),
                      inputWidget(maintainanceController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Common Area Electricity (CAE)'),
                      inputWidget(commonAreaController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Electricity (Society)'),
                      inputWidget(electricitySocietyController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Electricity (Authority)'),
                      inputWidget(electricityAuthorityController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Power Back-Up'),
                      inputWidget(powerController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'PNG/LPG'),
                      inputWidget(pngController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Club'),
                      inputWidget(clubController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Water'),
                      inputWidget(waterController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Property Tax'),
                      inputWidget(propertyTaxController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Any other'),
                      inputWidget(anyOtherController),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          titleWidget(context, 'Issues'),
                          InkWell(
                            child: Icon(Icons.add),
                            onTap: () {
                              showPicker(context);
                            },
                          )
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ListView.builder(
                        itemBuilder: (context, index) =>
                            issueCard(constraints, index),
                        itemCount: count,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                      // issueCard(constraints),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  List<List<Widget>> photo = [[]];

  photoPick(list, name) {
    return Container(
      width: 100,
      height: 50,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: list.length + 1,
        itemBuilder: (context, index) {
          print(name);
          return index == list.length
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CameraScreen(name: name)));
                  },
                  child: Icon(Icons.add),
                )
              : list[index];
        },
      ),
    );
  }

  issueCard(constraints, index) {
    photo[index].clear();
    List<String> pathList = prefs.getStringList(headings[index].toString());
    pathList = pathList == null ? [] : pathList;
    print(pathList.length);
    for (int i = 0; i < pathList.length; i++) {
      photo[index].add(
        Container(
          child: Image.file(
            File(
              pathList[i],
            ),
          ),
          height:30,
          width:30,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        titleWidget(context, headings[index].toString()),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.minWidth),
            child: DataTable(
                dataRowHeight: 50,
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
                rows: rows[index]),
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
                  rows[index].add(DataRow(cells: [
                    DataCell(TextFormField()),
                    DataCell(TextFormField()),
                    DataCell(TextFormField()),
                    DataCell(
                      photoPick(photo[index], headings[index].toString()),
                    ),
                  ]));
                });
              },
            ),
            IconButton(
              color: Colors.redAccent,
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  rows[index].removeLast();
                });
              },
            ),
            IconButton(
              color: Colors.green,
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  rows[index].clear();
                });
              },
            ),
          ],
        )
      ],
    );
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
        height: 180,
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerData), isArray: false),
        changeToFirst: true,
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            count++;
            headings.add(picker.getSelectedValues().join(""));
          });
        });
    picker.show(_scaffoldKey.currentState);
  }

  static const PickerData = '''
[
    {
        "room1": [
             "room1SubRoom1",
             "room1SubRoom2",
             "room1SubRoom3"
        ]
    },
    {
        "room2": [
             "room2SubRoom1",
             "room3SubRoom2",
             "room4SubRoom3"
        ]
    },
    {
        "room3": [
            "noSubRooms"
        ]
    },
    {
        "room4": [
             "room4SubRoom1"
        ]
    }
]
    ''';

  Widget titleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }

  Widget inputWidget(TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
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
