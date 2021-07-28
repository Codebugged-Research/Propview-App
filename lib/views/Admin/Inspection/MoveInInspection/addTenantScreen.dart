import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/Property.dart';

class AddTenantScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  AddTenantScreen({this.propertyElement});
  @override
  _AddTenantScreenState createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  PropertyElement propertyElement;

  final formkey = new GlobalKey<FormState>();

  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController pemailController = new TextEditingController();
  TextEditingController semailController = new TextEditingController();
  TextEditingController pmobileController = new TextEditingController();
  TextEditingController smobileController = new TextEditingController();
  TextEditingController hphoneController = new TextEditingController();
  TextEditingController ophoneController = new TextEditingController();
  TextEditingController isFamilyController = new TextEditingController();
  TextEditingController paddressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController panController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController citizenshipController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController caddressController = new TextEditingController();
  TextEditingController desginationController = new TextEditingController();
  TextEditingController totalMembersController = new TextEditingController();
  TextEditingController planlordController = new TextEditingController();
  TextEditingController planlordNumberController = new TextEditingController();
  TextEditingController spouseNameController = new TextEditingController();
  TextEditingController spouseEmailController = new TextEditingController();
  TextEditingController spouseNumberController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController billingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
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
              text: 'Tenant',
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
