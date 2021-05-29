import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/utils/progressBar.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({Key key, this.propertyId}) : super(key: key);

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool loading = false;
  PropertyElement property;

  getData() async {
    setState(() {
      loading = true;
    });
    property = await PropertyService.getPropertyById(
      widget.propertyId,
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: loading
          ? circularProgressWidget()
          : Container(
              height: UIConstants.fitToHeight(640, context),
              width: UIConstants.fitToWidth(360, context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      headerWidget(context),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      profileSectionWidget(
                          context,
                          'Name',
                          '${property.tblSociety.socname} ${property.tblLocality.locname} ${property.tableproperty.unitNo}',
                          Icons.home),
                      profileSectionWidget(context, 'City',
                          '${property.tblCity.ccname}', Icons.home),
                      profileSectionWidget(context, 'State',
                          '${property.tblState.sname}', Icons.home),
                      profileSectionWidget(context, 'Country',
                          '${property.tblCountry.cname}', Icons.home),
                      profileSectionWidget(
                          context,
                          'Property For',
                          '${property.tableproperty.propertyFor.replaceFirst(property.tableproperty.propertyFor.substring(0, 1), property.tableproperty.propertyFor.substring(0, 1).toUpperCase())}',
                          Icons.home),
                      profileSectionWidget(
                          context,
                          'Property Kind',
                          '${property.tableproperty.propertyKind.replaceFirst(property.tableproperty.propertyKind.substring(0, 1), property.tableproperty.propertyKind.substring(0, 1).toUpperCase())}',
                          Icons.home),
                      profileSectionWidget(context, 'Property Type',
                          '${property.tableproperty.propertyType}', Icons.home),
                      profileSectionWidget(context, 'BHK',
                          '${property.tableproperty.bhk}', Icons.home),
                      profileSectionWidget(
                          context,
                          'Bedrooms',
                          '${property.tableproperty.bedrooms} Rooms',
                          Icons.home),
                      profileSectionWidget(
                          context,
                          'Bathrooms',
                          '${property.tableproperty.bathrooms} Rooms',
                          Icons.home),
                      profileSectionWidget(
                          context,
                          'Balcony',
                          '${property.tableproperty.balcony} Balcony',
                          Icons.home),
                      profileSectionWidget(
                          context,
                          'Super Area',
                          '${property.tableproperty.superArea} ${property.tableproperty.superPrefix}',
                          Icons.home),
                      profileSectionWidget(context, 'Furnshing',
                          '${property.tableproperty.furnishing}', Icons.home),
                      profileSectionWidget(context, 'Ownership',
                          '${property.tableproperty.ownership}', Icons.home),
                      profileSectionWidget(context, 'Flats Floor',
                          '${property.tableproperty.flatsFloor}', Icons.home),
                      profileSectionWidget(context, 'Demand',
                          '₹${property.tableproperty.demand}', Icons.home),
                      profileSectionWidget(context, 'Demand Sale',
                          '₹${property.tableproperty.demandSale}', Icons.home),
                      profileSectionWidget(context, 'Maintainance',
                          '₹${property.tableproperty.maintenance}', Icons.home),
                      profileSectionWidget(
                          context,
                          'Maintainance Type',
                          '${property.tableproperty.maintenanceType}',
                          Icons.home),
                      profileSectionWidget(
                          context,
                          'Security Deposit',
                          '₹${property.tableproperty.securityDeposit}',
                          Icons.home),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [textWidget(context), imageWidget(context)]);
  }

  Widget textWidget(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: "Property\n",
            style: Theme.of(context)
                .primaryTextTheme
                .headline3
                .copyWith(fontSize: 42, fontWeight: FontWeight.bold),
            children: [
          TextSpan(
              text: 'Details',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.normal))
        ]));
  }

  Widget imageWidget(BuildContext context) {
    return Image.asset(
      "assets/house.png",
      height: UIConstants.fitToHeight(75, context),
      width: UIConstants.fitToWidth(75, context),
    );
  }

  Widget profileSectionWidget(
      BuildContext context, String heading, String body, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                iconData,
                color: Color(0xff314B8C),
              ),
              SizedBox(width: UIConstants.fitToWidth(16, context)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                  Container(
                      width: UIConstants.fitToHeight(210, context),
                      child: Text(
                        body,
                        // overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle2
                            .copyWith(color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
