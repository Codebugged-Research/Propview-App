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

  final formkey = new GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController sexController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController relationshipController = new TextEditingController();

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
                children: [
                  headerWidget(context),
                  formWidget(context),
                  SizedBox(height: UIConstants.fitToHeight(16, context)),
                  buttonWidget(context)
                ],
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

  Widget formWidget(BuildContext context) {
    return Container(
      child: Form(
        key: formkey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              inputWidget(nameController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              inputWidget(sexController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              inputWidget(ageController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              inputWidget(phoneController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              inputWidget(emailController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              inputWidget(relationshipController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
            ]),
      ),
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

  Widget buttonWidget(BuildContext context) {
    return MaterialButton(
      minWidth: 360,
      height: 55,
      color: Color(0xff314B8C),
      onPressed: () async {},
      child: Text("Login", style: Theme.of(context).primaryTextTheme.subtitle1),
    );
  }
}
