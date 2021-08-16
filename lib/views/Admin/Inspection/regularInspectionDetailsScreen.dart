import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/RegularInspection.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';

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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Regular Inspection Details'),
        ),
        body: isLoading
            ? circularProgressWidget()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
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
                                    .copyWith(fontWeight: FontWeight.normal))
                          ])),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      titleWidget(context, 'Inspection Type'),
                      subHeadingWidget(context, 'Regular Inspection'),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
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
                    ],
                  ),
                ),
              ),
      );
    });
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
