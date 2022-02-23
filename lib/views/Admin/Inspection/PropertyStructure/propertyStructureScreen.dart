import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Room.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/roomType.dart';
import 'package:propview/services/roomService.dart';
import 'package:propview/services/roomTypeService.dart';
import 'package:propview/services/subRoomService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/Room/AddRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/Room/EditRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/SubRoom/AddSubRoomScreen.dart';
import 'package:propview/views/Admin/Inspection/PropertyStructure/SubRoom/EditSubRoomScreen.dart';
import 'package:propview/views/Admin/widgets/propertyStructureAlertWidget.dart';
import 'package:propview/views/Admin/widgets/roomCard.dart';
import 'package:propview/views/Admin/widgets/subRoomCard.dart';

class PropertyStructureScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  PropertyStructureScreen({this.propertyElement});

  @override
  _PropertyStructureScreenState createState() =>
      _PropertyStructureScreenState();
}

class _PropertyStructureScreenState extends State<PropertyStructureScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;

  PropertyElement propertyElement;

  List<RoomsToPropertyModel> rooms = [];
  List<SubRoomElement> subRooms = [];

  RoomType roomType;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    loadData();
  }

  loadData() async {
    setState(() {
      isLoading = true;
      rooms.clear();
      subRooms.clear();
    });
    roomType = await RoomTypeService.getRoomTypes();
    propertyElement = widget.propertyElement;
    rooms = await RoomService.getRoomByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    subRooms = await SubRoomService.getSubRoomByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    if (propertyElement.tableproperty.freeze == 1) {
      showDialog(
          context: context,
          builder: (_) {
            return PropertyStructureAlertWidget(
              title: 'Property Structure already defined!',
              body: 'Do you want to edit the Property Structure?',
            );
          });
    }
    setState(() {
      isLoading = false;
    });
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Property Structure',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 4.0,
        bottom: TabBar(
            onTap: (ind) {
              setState(() {
                index = ind;
              });
            },
            controller: tabController,
            indicatorColor: Color(0xff314B8C),
            labelStyle: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            unselectedLabelStyle: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
            tabs: [
              Tab(text: 'Rooms'),
              Tab(text: 'Sub Rooms'),
            ]),
      ),
      body: isLoading
          ? circularProgressWidget()
          : TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                rooms.length == 0
                    ? RefreshIndicator(
                        onRefresh: () {
                          loadData();
                          return;
                        },
                        child: Center(
                            child: Text('No Rooms are available!',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1
                                    .copyWith(color: Colors.black))),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          loadData();
                          return;
                        },
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: rooms.length,
                            itemBuilder: (context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  bool response =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditRoomScreen(
                                        room: rooms[index],
                                        propertyElement: propertyElement,
                                        roomTypes: roomType.data.propertyRoom,
                                      ),
                                    ),
                                  );
                                  if (response) {
                                    loadData();
                                  }
                                },
                                child: RoomCard(
                                  room: rooms[index],
                                  propertyElement: propertyElement,
                                  roomTypes: roomType.data.propertyRoom,
                                ),
                              );
                            }),
                      ),
                subRooms.length == 0
                    ? RefreshIndicator(
                        onRefresh: () {
                          loadData();
                          return;
                        },
                        child: Center(
                            child: Text('No Sub-Rooms are available!',
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle1
                                    .copyWith(color: Colors.black))),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          loadData();
                          return;
                        },
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: subRooms.length,
                            itemBuilder: (context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  bool response =
                                      await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditSubRoomScreen(
                                        subRoom: subRooms[index],
                                        propertyElement: propertyElement,
                                        roomTypes: roomType.data.propertyRoom,
                                      ),
                                    ),
                                  );
                                  if (response) {
                                    loadData();
                                  }
                                },
                                child: SubRoomCard(
                                  subRoom: subRooms[index],
                                  propertyElement: propertyElement,
                                  roomTypes: roomType.data.propertyRoom,
                                ),
                              );
                            }),
                      ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: index == 0
            ? () async {
                bool response = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddRoomScreen(
                      propertyElement: propertyElement,
                      roomTypes: roomType.data.propertyRoom
                          .where((element) =>
                              rooms
                                  .where((element2) =>
                                      element2.roomId == element.roomId)
                                  .length ==
                              0)
                          .toList(),
                    ),
                  ),
                );
                if (response) {
                  loadData();
                }
              }
            : () async {
                bool response = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddSubRoomScreen(
                      rooms: rooms,
                      propertyElement: propertyElement,
                      roomTypes: roomType.data.propertyRoom
                          .where((element) =>
                              rooms
                                  .where((element2) =>
                                      element2.roomId == element.roomId ||
                                      element.issub == 1)
                                  .length >
                              0)
                          .toList(),
                    ),
                  ),
                );
                if (response) {
                  // tabController.animateTo(1);
                  // loadData();
                  Navigator.of(context).pop();
                }
              },
        child: Icon(Icons.add),
      ),
    );
  }
}
