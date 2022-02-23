import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/models/RegularInspectionRow.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/regulationInspectionRowService.dart';
import 'package:propview/services/regulationInspectionService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/Inspection/inspectionWebView2.dart';
import 'package:url_launcher/url_launcher.dart';

class RegularInspectionDetailsScreen extends StatefulWidget {
  final RegularInspection regularInspection;

  RegularInspectionDetailsScreen({this.regularInspection});

  @override
  _RegularInspectionDetailsScreenState createState() =>
      _RegularInspectionDetailsScreenState();
}

class _RegularInspectionDetailsScreenState
    extends State<RegularInspectionDetailsScreen> {
  bool isLoading = false;

  RegularInspection regularInspection;
  User user;
  PropertyElement propertyElement;
  List<RegularInspectionRow> regularInspectionRowList = [];

  @override
  void initState() {
    super.initState();
    regularInspection = widget.regularInspection;
    loadDataForScreen();
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    user =
        await UserService.getUserById(regularInspection.employeeId.toString());
    propertyElement = await PropertyService.getPropertyById(
        regularInspection.propertyId.toString());
    List rowList = regularInspection.rowList.split(",").toList();
    if (regularInspection.rowList != "") {
      for (int i = 0; i < rowList.length; i++) {
        regularInspectionRowList.add(
            await RegularInspectionRowService.getRegularInspectionRowById(
                rowList[i]));
      }
    } else {
      regularInspectionRowList = [];
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Regular Inspection Details",
            style: Theme.of(context)
                .primaryTextTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("View PDF"),
                  value: 1,
                ),
              ],
              onSelected: (value) async {
                if (value == 1) {
                  Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InspectionWebView2(
                            url:
                                "https://api.propdial.co.in/pdf/regular/${regularInspection.id}",
                          ),
                        ),
                      );
                } 
              },
            ),
          ],
        ),
        body: isLoading
            ? circularProgressWidget()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Regular Inspection\n",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headline4
                                  .copyWith(fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                                text: "History",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .headline3
                                    .copyWith(fontWeight: FontWeight.normal))
                          ])),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      // titleWidget(context, 'Inspection Type'),
                      // subHeadingWidget(context, 'Regular Inspection'),
                      // SizedBox(
                      //     height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Property ID'),
                      subHeadingWidget(
                          context, '${regularInspection.propertyId}'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Property Name'),
                      subHeadingWidget(context,
                          '${propertyElement.tblSociety.socname} ,  ${propertyElement.tableproperty.unitNo}'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Created By'),
                      subHeadingWidget(context, '${user.name}'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return inspectionCard(constraints, index);
                        },
                        itemCount: regularInspectionRowList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
      );
    });
  }

  inspectionCard(constraints, index) {
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
                .headline5
                .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.minWidth),
              child:
                  DataTable(dataRowHeight: 80, dividerThickness: 2, columns: [
                DataColumn(
                    label: Text("Termite Issue",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle2
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                DataColumn(
                    label: Text("Seepage Check",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle2
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                DataColumn(
                    label: Text("General Cleanliness",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle2
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                DataColumn(
                    label: Text("Other Issues",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle2
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
              ], rows: [
                DataRow(
                  cells: [
                    DataCell(
                        Text(regularInspectionRowList[index].termiteCheck)),
                    DataCell(
                        Text(regularInspectionRowList[index].seepageCheck)),
                    DataCell(Text(
                        regularInspectionRowList[index].generalCleanliness)),
                    DataCell(Text(regularInspectionRowList[index].otherIssue)),
                  ],
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .headline6
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }

  Widget subHeadingWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
    );
  }
}
