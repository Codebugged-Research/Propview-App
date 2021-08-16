import 'dart:io';

import 'package:flutter/material.dart';
import 'package:propview/config.dart';
import 'package:propview/models/Inspection.dart';
import 'package:propview/models/Issue.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/issueTable.dart';
import 'package:propview/services/issueService.dart';
import 'package:propview/services/issueTableService.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/utils/progressBar.dart';

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

  Inspection inspection;
  PropertyElement propertyElement;
  List<IssueTable> issueTables = [];
  List<List<Issue>> issues = [];

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
    //todo: remove this its already in previous screen
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

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return Scaffold(
            appBar: AppBar(),
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
                            RichText(
                                text: TextSpan(
                                    text: "Inspection\n",
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
                                          .copyWith(
                                              fontWeight: FontWeight.normal))
                                ])),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02),
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

  Widget issueCard(constraints, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        titleWidget(context, issueTables[index].data.first.roomsubroomName),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.minWidth),
            child: DataTable(
              dataRowHeight: 80,
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
              rows: issues[index]
                  .asMap()
                  .entries
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e.value.issueName.toString())),
                        DataCell(Text(e.value.status.toString())),
                        DataCell(
                          Text(e.value.remarks.toString()),
                        ),
                        e.value.photo.isEmpty
                            ? DataCell(Text('No Pics!'))
                            : DataCell(photoPick(e.value.photo)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget photoPick(
    List<String> list,
  ) {
    return Container(
      width: 300,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Image.network(
            Config.INSPECTION_STORAGE_ENDPOINT + list[index].trim(),
            height: 60,
            width: 60,
          );
        },
      ),
    );
  }
}
