import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Inspection.dart';

class InspectionCard extends StatelessWidget {
  final Inspection inspection;
  InspectionCard({this.inspection});
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
                  Row(
                    children: [
                      // Text('Inspection ID: ',
                      //     style: Theme.of(context)
                      //         .primaryTextTheme
                      //         .subtitle1
                      //         .copyWith(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.w800)),
                      // Text(
                      //     '${roomTypes.where((element) {
                      //           return element.roomId.toString() ==
                      //               room.roomId.toString();
                      //         }).first.roomName}',
                      //     style: Theme.of(context)
                      //         .primaryTextTheme
                      //         .subtitle1
                      //         .copyWith(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.w500))
                    ],
                  ),
                  SizedBox(
                    height: UIConstants.fitToHeight(16, context),
                  ),
                  // Row(
                  //   children: [
                  //     Text('Property ID: ',
                  //         style: Theme.of(context)
                  //             .primaryTextTheme
                  //             .subtitle1
                  //             .copyWith(
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w800)),
                  //     Text('${room.propertyId}',
                  //         style: Theme.of(context)
                  //             .primaryTextTheme
                  //             .subtitle1
                  //             .copyWith(
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w500))
                  //   ],
                  // ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text('Size 1: ',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle1
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                      // Text('${room.roomSize1}',
                      //     style: Theme.of(context)
                      //         .primaryTextTheme
                      //         .subtitle1
                      //         .copyWith(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.w500))
                    ],
                  ),
                  Row(
                    children: [
                      Text('Size 2: ',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .subtitle1
                              .copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                      // Text('${room.roomSize2}',
                      //     style: Theme.of(context)
                      //         .primaryTextTheme
                      //         .subtitle1
                      //         .copyWith(
                      //             color: Colors.black,
                      //             fontWeight: FontWeight.w500))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
