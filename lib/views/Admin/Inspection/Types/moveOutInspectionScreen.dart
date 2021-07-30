import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Tenant.dart';
import 'package:propview/models/TenantFamily.dart';
import 'package:propview/services/inspectionService.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/tenantService.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/widgets/tenantWidget.dart';

class MoveOutInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  const MoveOutInspectionScreen({this.propertyElement});
  @override
  _MoveOutInspectionScreenState createState() =>
      _MoveOutInspectionScreenState();
}

class _MoveOutInspectionScreenState extends State<MoveOutInspectionScreen> {
  bool isLoading = false;
  bool isRequested = false;

  PropertyElement propertyElement;
  List<Tenant> tenants = [];
  List<TenantFamily> tenantFamily = [];

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
    propertyElement = widget.propertyElement;
    loadDataForScreen();
  }

  loadDataForScreen() async {
    setState(() {
      isLoading = true;
    });
    //Getting Tenant IDs by Property ID
    List<String> tenantList =
        propertyElement.tableproperty.tenantId.split(",").toList();

    //Getting Tenant by Fetching from the Tenant Table
    for (var tenantId in tenantList) {
      Tenant tenant = await TenantService.getTenant(tenantId);
      setState(() {
        //Adding all the Tenants to the List
        tenants.add(tenant);
      });
    }
    print(tenants);
    setState(() {
      isLoading = false;
    });
  }

  moveOutRequest() async {
    try {
      setState(() {
        isRequested = true;
      });
      var payload = json.encode({
        "inspect_type": "Move out Inspection",
        "maintenance_charges": "",
        "common_area_electricity": "",
        "electricity_society": "",
        "electricity_authority": "",
        "power_backup": "",
        "png_lgp": "",
        "club": "",
        "water": "",
        "property_tax": "",
        "any_other": "",
        "property_id": "",
        "employeed_id": "",
        "issue_id_list": "",
        "createdAt": DateTime.now().toString(),
        "updatedAt": DateTime.now().toString(),
      });
      print(payload);
      bool isCreated = await InspectionService.createInspection(payload);
      if (isCreated) {
        setState(() {
          isRequested = false;
        });
        showInSnackBar(
            context, 'Move Out Inspection created Successfully!', 2500);
      } else {
        setState(() {
          isRequested = false;
        });
        showInSnackBar(context, 'Move Out Inspection failed! Try again.', 2500);
      }
    } catch (err) {
      setState(() {
        isRequested = false;
      });
      showInSnackBar(context, 'Something went wrong! Try again.', 2500);
    }
  }

  removeTenantFromProperty(String tenantId) async {
    try {
      List<String> tenantList =
          propertyElement.tableproperty.tenantId.split(",").toList();
      tenantList.remove(tenantId);
      propertyElement.tableproperty.tenantId = tenantList.join(",");
      var payload = json.encode(propertyElement.toJson());
      bool isUpdated = await PropertyService.updateProperty(
          payload, propertyElement.tableproperty.propertyId);
      if (isUpdated) {
        showInSnackBar(context, 'Tenant removed successfully!', 2500);
        Routing.makeRouting(context, routeMethod: 'pop');
      } else {
        showInSnackBar(context, 'Tenant deletion failed! Try again.', 2500);
      }
    } catch (err) {
      showInSnackBar(context, 'Something went wrong! Try again.', 2500);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Move out\n",
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Maintenance Charges or CAM'),
                inputWidget(maintainanceController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Common Area Electricity (CAE)'),
                inputWidget(commonAreaController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Electricity (Society)'),
                inputWidget(electricitySocietyController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Electricity (Authority)'),
                inputWidget(electricityAuthorityController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Power Back-Up'),
                inputWidget(powerController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'PNG/LPG'),
                inputWidget(pngController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Club'),
                inputWidget(clubController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Water'),
                inputWidget(waterController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Property Tax'),
                inputWidget(propertyTaxController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                titleWidget(context, 'Any other'),
                inputWidget(anyOtherController),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                subHeadingWidget(context, 'Tenant Details'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                tenants.length == 0
                    ? Center(
                        child: Text('No Tenant is found!',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .subtitle2
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: tenants.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onLongPress: () async {
                              await removeTenantFromProperty(
                                  tenants[index].tenantId.toString());
                            },
                            child: TenantWidget(
                                tenant: tenants[index], index: index),
                          );
                        }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }

  Widget subHeadingWidget(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .primaryTextTheme
          .headline6
          .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
    );
  }

  Widget inputWidget(TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
        textCapitalization: TextCapitalization.words,
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
