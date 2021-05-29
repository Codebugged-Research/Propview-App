import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/services/propertyService.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({Key key, this.propertyId}) : super(key: key);

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
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
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 56.0, left: 24, right: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Property Details',
                          style: Theme.of(context).primaryTextTheme.headline6,
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Divider(
                          color: Color(0xff314B8C),
                          thickness: 2.5,
                          indent: 100,
                          endIndent: 100,
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(context, 'Name: ',
                        '${property.tblSociety.socname} ${property.tblLocality.locname} ${property.tableproperty.unitNo}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(context, 'For: ',
                        '${property.tableproperty.propertyFor}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(context, 'Type: ',
                        '${property.tableproperty.propertyType}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(
                        context, 'BHK Type: ', '${property.tableproperty.bhk}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(context, 'Demand Rent: ',
                        '${property.tableproperty.demand}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(context, 'Demand Sale: ',
                        '${property.tableproperty.demandSale}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(
                        context,
                        'Maintenance (${property.tableproperty.maintenanceType}): ',
                        '${property.tableproperty.maintenance}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(context, 'Security Deposit: ',
                        '${property.tableproperty.securityDeposit}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(context, 'Super Area: ',
                        '${property.tableproperty.superArea}'),
                  ],
                ),
              ),
            ),
    );
  }

  Widget titleWidget(BuildContext context, String label, String data) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).primaryTextTheme.headline6.copyWith(
            color: Color(0xff314B8C),
            fontWeight: FontWeight.w700,
            fontSize: 20),
        children: <TextSpan>[
          TextSpan(
            text: data,
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                color: Color(0xff141414),
                fontWeight: FontWeight.w600,
                fontSize: 18),
          )
        ],
      ),
    );
  }
}
