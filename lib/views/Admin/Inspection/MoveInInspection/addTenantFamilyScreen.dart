import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Tenant.dart';

class AddTenantFamilyScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<Tenant> tenants;
  AddTenantFamilyScreen({this.propertyElement, this.tenants});
  @override
  _AddTenantFamilyScreenState createState() => _AddTenantFamilyScreenState();
}

class _AddTenantFamilyScreenState extends State<AddTenantFamilyScreen> {
  PropertyElement propertyElement;
  List<Tenant> tenants;

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
    tenants = widget.tenants;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [headerWidget(context)],
              ),
            ),
          ),
        ));
  }

  Widget headerWidget(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [textWidget(context), imageWidget(context)]);
  }

  Widget textWidget(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: "Add\n",
            style: Theme.of(context)
                .primaryTextTheme
                .headline3
                .copyWith(fontSize: 42, fontWeight: FontWeight.bold),
            children: [
          TextSpan(
              text: 'Tenant-Family',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.normal))
        ]));
  }

  Widget imageWidget(BuildContext context) {
    return Image.asset(
      'assets/tenant/tenant.png',
      height: UIConstants.fitToHeight(75, context),
      width: UIConstants.fitToWidth(75, context),
    );
  }
}
