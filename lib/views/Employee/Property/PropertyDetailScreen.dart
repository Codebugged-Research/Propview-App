import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';

class PropertyDetailScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  const PropertyDetailScreen({Key key, this.propertyElement}) : super(key: key);

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  '${widget.propertyElement.socid} ${widget.propertyElement.locid} ${widget.propertyElement.unitNo}'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              titleWidget(
                  context, 'For: ', '${widget.propertyElement.propertyFor}'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              titleWidget(
                  context, 'Type: ', '${widget.propertyElement.propertyType}'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              titleWidget(
                  context, 'BHK Type: ', '${widget.propertyElement.bhk}'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              titleWidget(
                  context, 'Demand Rent: ', '${widget.propertyElement.demand}'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              titleWidget(context, 'Demand Sale: ',
                  '${widget.propertyElement.demandSale}'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              titleWidget(
                  context,
                  'Maintenance (${widget.propertyElement.maintenanceType}): ',
                  '${widget.propertyElement.maintenance}'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              titleWidget(context, 'Security Deposit: ',
                  '${widget.propertyElement.securityDeposit}'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              titleWidget(context, 'Super Area: ',
                  '${widget.propertyElement.superArea}'),
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
        style: Theme.of(context)
            .primaryTextTheme
            .headline6
            .copyWith(color: Color(0xff314B8C), fontWeight: FontWeight.w700, fontSize: 20),
        children: <TextSpan>[
          TextSpan(
            text: data,
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                  color: Color(0xff141414),
                  fontWeight: FontWeight.w600,
              fontSize: 18
                ),
          )
        ],
      ),
    );
  }
}
