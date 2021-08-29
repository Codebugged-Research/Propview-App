import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Subroom.dart';
import 'package:propview/models/roomType.dart';

class SubRoomCard extends StatelessWidget {
  final SubRoomElement subRoom;
  final PropertyElement propertyElement;
  final List<PropertyRoom> roomTypes;
  SubRoomCard({this.subRoom, this.propertyElement, this.roomTypes});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Container(
        width: UIConstants.fitToWidth(330, context),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.15)),
              BoxShadow(
                  offset: Offset(-2, 2),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.15))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${roomTypes.where((element) {
                          return element.roomId.toString() ==
                              subRoom.subRoomId.toString();
                        }).first.roomName} - ${roomTypes.where((element) {
                          return element.roomId.toString() ==
                              subRoom.roomId.toString();
                        }).first.roomName}',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  Text('(${subRoom.roomSize2} X ${subRoom.roomSize1}) ft',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.w500))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
