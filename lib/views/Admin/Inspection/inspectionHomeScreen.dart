import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/views/Admin/Inspection/Types/fullInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/Types/issueInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/Types/moveInInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/Types/moveOutInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/Types/propertyStructureScreen.dart';
import 'package:propview/views/Admin/Inspection/Types/regularInspectionScreen.dart';
import 'package:propview/views/Admin/Inspection/inspectionHistoryScreen.dart';

class InspectionHomeScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  const InspectionHomeScreen({this.propertyElement});

  @override
  _InspectionHomeScreenState createState() => _InspectionHomeScreenState();
}

class _InspectionHomeScreenState extends State<InspectionHomeScreen> {
  PropertyElement propertyElement;

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspection Type'),
        actions: [
          IconButton(
              onPressed: () {
                Routing.makeRouting(context,
                    routeMethod: 'push',
                    newWidget: InspectionHistoryScreen(
                        propertyElement: propertyElement));
              },
              icon: Icon(
                Icons.history,
                color: Color(0xff314B8C),
              ))
        ],
      ),
      body: CustomPaint(
        painter: CurvePainter(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 32,
                    children: [
                      metricCard('property_structure',
                          'Property Structure Determination', onTap: () {
                        Routing.makeRouting(context,
                            routeMethod: 'push',
                            newWidget: PropertyStructureScreen(
                                propertyElement: propertyElement));
                      }),
                      metricCard('full_inspection', 'Full Inspection',
                          onTap: () {
                        Routing.makeRouting(context,
                            routeMethod: 'push',
                            newWidget: FullInspectionScreen(
                                propertyElement: propertyElement));
                      }),
                      metricCard('move_in', 'Move In Inspection', onTap: () {
                        Routing.makeRouting(context,
                            routeMethod: 'push',
                            newWidget: MoveInInspectionScreen(
                                propertyElement: propertyElement));
                      }),
                      metricCard('move_out', 'Move Out Inspection', onTap: () {
                        Routing.makeRouting(context,
                            routeMethod: 'push',
                            newWidget: MoveOutInspectionScreen(
                                propertyElement: propertyElement));
                      }),
                      metricCard('regular_inspection', 'Regular Inspection',
                          onTap: () {
                        Routing.makeRouting(context,
                            routeMethod: 'push',
                            newWidget: RegularInspectionScreen(
                                propertyElement: propertyElement));
                      }),
                      metricCard('issue_inspection', 'Issue Based Inspection',
                          onTap: () {
                        Routing.makeRouting(context,
                            routeMethod: 'push',
                            newWidget: IssueInspectionScreen(
                                propertyElement: propertyElement));
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget metricCard(String asset, String title, {VoidCallback onTap}) {
    onTap ??= () {};
    return Container(
      height: UIConstants.fitToHeight(144, context),
      width: UIConstants.fitToWidth(150, context),
      child: Ink(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 4,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
              BoxShadow(
                offset: Offset(2, 0),
                blurRadius: 5,
                color: Color.fromRGBO(0, 0, 0, 0.25),
              ),
            ]),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          splashColor: Color(0xff686C71),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.only(left: 9.5, right: 9.5, top: 16),
                  child: Image.asset(
                    'assets/inspection/$asset.png',
                    height: UIConstants.fitToHeight(60, context),
                    width: UIConstants.fitToWidth(60, context),
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16),
                child: Text('$title',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .subtitle2
                        .copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color(0xff314B8C);
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9167);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
