import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/regularInspectionDetailsScreen.dart';

class RegularInspectionCard extends StatelessWidget {
  final RegularInspection regularInspection;

  RegularInspectionCard({this.regularInspection});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Routing.makeRouting(context,
            routeMethod: 'push',
            newWidget: RegularInspectionDetailsScreen(
                regularInspection: regularInspection));
      },
      child: Padding(
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
                        Text('Inspection ID: ',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                        Text('${regularInspection.id}',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500))
                      ],
                    ),
                    SizedBox(
                      height: UIConstants.fitToHeight(16, context),
                    ),
                    Row(
                      children: [
                        Text('Inspection Type: ',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                        Text('Regular Inspection',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .subtitle1
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
