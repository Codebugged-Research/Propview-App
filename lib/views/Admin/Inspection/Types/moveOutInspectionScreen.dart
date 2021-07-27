import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Tenant.dart';
import 'package:propview/models/TenantFamily.dart';
import 'package:propview/services/tenantFamilyService.dart';
import 'package:propview/services/tenantService.dart';
import 'package:propview/views/Admin/widgets/tenantFamilyWidget.dart';
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

    if (tenants.length == 1) {
      await getTenantFamilyInSingleTenant();
    } else {
      getTenantFamilyByMultipleTenant();
    }
    setState(() {
      isLoading = false;
    });
  }

  getTenantFamilyInSingleTenant() async {
    tenantFamily =
        await TenantFamilyService.getTenantFamily(tenants[0].tenantId);
    print(tenantFamily);
  }

  getTenantFamilyByMultipleTenant() async {
    //Get All the TenantFamilies by Tenant IDs
    for (var i = 0; i < tenants.length; i++) {
      //TODO: Fetch Multiple Tenants at a time
      print('Yo');
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
                          return TenantWidget(
                              tenant: tenants[index], index: index);
                        }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                // subHeadingWidget(context, 'Tenant FamilyDetails'),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                // tenantFamily.length == 0
                //     ? Center(
                //         child: Text('No Family is found!',
                //             style: Theme.of(context)
                //                 .primaryTextTheme
                //                 .subtitle2
                //                 .copyWith(
                //                     color: Colors.black,
                //                     fontWeight: FontWeight.w600)),
                //       )
                //     : ListView.builder(
                //         shrinkWrap: true,
                //         itemCount: tenants.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           return TenantFamilyWidget(
                //               tenantFamily: tenantFamily[index], index: index);
                //         }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        visible: true,
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
              child: Icon(Icons.group, color: Colors.white),
              backgroundColor: Color(0xff314B8C),
              onTap: () {},
              label: 'Tenant Family',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xff314B8C)),
          SpeedDialChild(
              child: Icon(Icons.person, color: Colors.white),
              backgroundColor: Color(0xff314B8C),
              onTap: () {},
              label: 'Tenant',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.0),
              labelBackgroundColor: Color(0xff314B8C)),
        ],
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
