import 'dart:io';

import 'package:flutter/material.dart';
import 'package:propview/config.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/User.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/services/billPropertyService.dart';
import 'package:propview/services/issueService.dart';
import 'package:propview/services/issueTableService.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/widgets/fullInspectionCard.dart';
import 'package:url_launcher/url_launcher.dart';

class InspectionHistoryDetailsScreen extends StatefulWidget {
  final Inspection inspection;

  InspectionHistoryDetailsScreen({this.inspection});

  @override
  _InspectionHistoryDetailsScreenState createState() =>
      _InspectionHistoryDetailsScreenState();
}

class _InspectionHistoryDetailsScreenState
    extends State<InspectionHistoryDetailsScreen> {
  bool isLoading = false;

  User user;
  Inspection inspection;
  PropertyElement propertyElement;
  List<IssueTable> issueTables = [];
  List<List<Issue>> issues = [];
  List<BillToProperty> bills = [];

  @override
  void initState() {
    super.initState();
    inspection = widget.inspection;
    loadDataForScreen();
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    user = await UserService.getUserById(inspection.employeeId.toString());
    propertyElement =
        await PropertyService.getPropertyById(inspection.propertyId.toString());
    List issueIdList = inspection.issueIdList.split(",").toList();
    if (inspection.issueIdList != "") {
      for (int i = 0; i < issueIdList.length; i++) {
        issues.add([]);
        issueTables
            .add(await IssueTableService.getIssueTableById(issueIdList[i]));
        List tempRowList = issueTables[i].data.first.issueRowId.split(",");
        if (issueTables[i].data.first.issueRowId != "") {
          for (int j = 0; j < tempRowList.length; j++) {
            issues[i].add(await IssueService.getIssueById(tempRowList[j]));
          }
        } else {
          issues[i] = [];
        }
      }
    } else {
      issueTables = [];
    }
    bills = await BillPropertyService.getBillsByPropertyId(
        propertyElement.tableproperty.propertyId.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                "Inspection History Details",
                style: Theme.of(context)
                    .primaryTextTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    onTap: () {
                      launch(
                          "https://api.propdial.co.in/pdf/${inspection.inspectionId}");
                    },
                  ),
                )
              ],
            ),
            body: isLoading
                ? circularProgressWidget()
                : Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleWidget(context, 'Inspection Type'),
                            subHeadingWidget(
                                context, '${inspection.inspectType}'),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            titleWidget(context, 'Property ID'),
                            subHeadingWidget(
                                context, '${inspection.propertyId}'),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            titleWidget(context, 'Property Name'),
                            subHeadingWidget(context,
                                '${propertyElement.tblSociety.socname} ,  ${propertyElement.tableproperty.unitNo}'),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            titleWidget(context, 'Created By'),
                            subHeadingWidget(context, '${user.name}'),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            titleWidget(context, 'Created On'),
                            subHeadingWidget(context,
                                '${dateChange(inspection.createdAt.toLocal())}'),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            bills.length != 0
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xff314B8C)
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                    ),
                                  )
                                : SizedBox(),
                            bills.length == 0
                                ? SizedBox()
                                : Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    height: 260,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: bills.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return FullInspectionCard(
                                          propertyElement: propertyElement,
                                          billToProperty: bills[index],
                                          editable: false,
                                        );
                                      },
                                    ),
                                  ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
                            ListView.builder(
                              itemBuilder: (context, index) {
                                return issueCard(constraints, index);
                              },
                              itemCount: issueTables.length,
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
                  ));
      },
    );
  }

  dateChange(DateTime date) {
    return date.day.toString().padLeft(2, "0") +
        "-" +
        date.month.toString().padLeft(2, "0") +
        "-" +
        date.year.toString();
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

  Widget issueCard(constraints, int tableindex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        titleWidget(
            context, issueTables[tableindex].data.first.roomsubroomName),
        SizedBox(
          height: 8,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: issues[tableindex].length,
            itemBuilder: (context, index) {
              return issueRowCard(index, tableindex);
            },
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget issueRowCard(int index, int tableindex) {
    print(issues[tableindex][index].photo);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 220,
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Issue: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  Flexible(
                    child: Text(
                      issues[tableindex][index].issueName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Status: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  Flexible(
                    child: Text(
                      issues[tableindex][index].status,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style:
                          Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remarks: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  Flexible(
                    child: Text(
                      issues[tableindex][index].remarks,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style:
                          Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Photo: ',
                    style:
                        Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  issues[tableindex][index].photo.length == 0
                      ? Text('No Pics!')
                      : photoPick(issues[tableindex][index].photo),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget photoPick(
    List<String> list,
  ) {
    return Container(
      width: 150,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Image.network(
            Config.INSPECTION_STORAGE_ENDPOINT + list[index].trim(),
            height: 60,
            width: 45,
          );
        },
      ),
    );
  }
}
