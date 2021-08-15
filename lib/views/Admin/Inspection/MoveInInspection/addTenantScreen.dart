import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/City.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/State.dart';
import 'package:propview/services/cityService.dart';
import 'package:propview/services/stateService.dart';
import 'package:propview/services/tenantService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/landingPage.dart';

class AddTenantScreen extends StatefulWidget {
  final PropertyElement propertyElement;

  AddTenantScreen({this.propertyElement});

  @override
  _AddTenantScreenState createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends State<AddTenantScreen> {
  bool isLoading = false;
  bool isRequested = false;

  String isFamily = 'Yes';
  List<String> familyChoice = ['Yes', 'No'];

  List<City> cities = [];
  List<CStates> cstates = [];

  City selectedCity;
  CStates selectedState;

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
  TextEditingController panController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController citizenshipController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();
  TextEditingController caddressController = new TextEditingController();
  TextEditingController designationController = new TextEditingController();
  TextEditingController totalMembersController = new TextEditingController();
  TextEditingController planlordController = new TextEditingController();
  TextEditingController planlordNumberController = new TextEditingController();
  TextEditingController spouseNameController = new TextEditingController();
  TextEditingController spouseEmailController = new TextEditingController();
  TextEditingController spouseNumberController = new TextEditingController();

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
    cstates = await StateService.getStates();
    cities = await CityService.getCities();
    selectedState = cstates[0];
    selectedCity = cities[0];
    setState(() {
      isLoading = false;
    });
  }

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      isRequested = false;
    });
    return false;
  }

  createTenantRequest() async {
    try {
      if (checkFields()) {
        setState(() {
          isRequested = true;
        });
        var payload = json.encode({
          "name": nameController.text,
          "password": passwordController.text,
          "pemail": pemailController.text,
          "semail": semailController.text,
          "pmobile": pmobileController.text,
          "smobile": smobileController.text,
          "hphone": hphoneController.text,
          "ophone": ophoneController.text,
          "isFamily": isFamilyController.text == 'Yes' ? 1 : 0,
          "paddress": paddressController.text,
          "city": int.parse(selectedCity.ccid.toString()),
          "state": int.parse(selectedState.sid.toString()),
          "pan": panController.text,
          "aadhar": aadharController.text,
          "citizenship": "Indian",
          "company": companyController.text,
          "caddress": caddressController.text,
          "designation": designationController.text,
          "totalmembers": int.parse(totalMembersController.text),
          "plandlord": planlordController.text,
          "plandlord_number": planlordNumberController.text,
          "spouse_name": spouseNameController.text,
          "spouse_email": spouseEmailController.text,
          "spouse_mobile": spouseNumberController.text,
          "status": 1,
          "billing": 0
        });
        bool isCreated = await TenantService.createTenant(
            payload, propertyElement.tableproperty.propertyId);
        if (isCreated) {
          setState(() {
            isRequested = false;
          });
          showInSnackBar(context, 'Tenant added successfully!', 2500);
          Timer(Duration(milliseconds: 2510), () {
            Routing.makeRouting(context,
                routeMethod: 'pushAndRemoveUntil',
                newWidget: LandingScreen(selectedIndex: 0));
          });
        } else {
          setState(() {
            isRequested = false;
          });
          showInSnackBar(
              context, 'Failed to create a Tenant! Try again.', 2500);
        }
      } else {
        setState(() {
          isRequested = false;
        });
        showInSnackBar(context, 'Fill all the details! Try again.', 2500);
      }
    } catch (err) {
      setState(() {
        isRequested = false;
      });
      showInSnackBar(context, 'Check your Network! Try again.', 2500);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: isLoading
            ? circularProgressWidget()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        headerWidget(context),
                        SizedBox(height: UIConstants.fitToHeight(12, context)),
                        formWidget(context),
                        SizedBox(height: UIConstants.fitToHeight(16, context)),
                        buttonWidget(context),
                        SizedBox(height: UIConstants.fitToHeight(36, context)),
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

  Widget titleWidget(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: Theme.of(context)
            .primaryTextTheme
            .subtitle1
            .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
      ),
    );
  }

  Widget formWidget(BuildContext context) {
    return Container(
      child: Form(
        key: formkey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Name'),
              inputWidget(nameController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Password'),
              inputWidget(passwordController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Primary Email'),
              inputWidget(pemailController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Secondary Email'),
              inputWidget(semailController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Primary Mobile Number'),
              inputWidget(pmobileController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Secondary Mobile Number'),
              inputWidget(smobileController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Home Mobile Number'),
              inputWidget(hphoneController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Office Mobile Number'),
              inputWidget(ophoneController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Family'),
              DropdownButton(
                isExpanded: true,
                value: isFamily,
                elevation: 8,
                underline: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff314B8C),
                ),
                onChanged: (value) {
                  setState(() {
                    isFamily = value;
                    isFamilyController.text = isFamily;
                  });
                },
                items: familyChoice.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Primary Address'),
              inputWidget(paddressController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Primary Address'),
              inputWidget(paddressController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'State'),
              DropdownButton(
                isExpanded: true,
                value: selectedState,
                elevation: 8,
                underline: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff314B8C),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedState = value;
                  });
                },
                items: cstates.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.sname),
                  );
                }).toList(),
              ),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'City'),
              DropdownButton(
                isExpanded: true,
                value: selectedCity,
                elevation: 8,
                underline: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff314B8C),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                  });
                },
                items: cities.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.ccname),
                  );
                }).toList(),
              ),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'PAN Card Number'),
              inputWidget(panController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Aadhar Card Address'),
              inputWidget(aadharController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Primary Address'),
              inputWidget(paddressController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Company'),
              inputWidget(companyController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Company Address'),
              inputWidget(caddressController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Designation'),
              inputWidget(designationController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Total Members'),
              inputWidget(totalMembersController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Lanlord Name'),
              inputWidget(planlordController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Landlord Number'),
              inputWidget(planlordNumberController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Spouse Name'),
              inputWidget(spouseNameController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Spouse Email'),
              inputWidget(spouseEmailController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Spouse Mobile'),
              inputWidget(spouseNumberController),
              //TODO: Status and Billing
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
    return isRequested
        ? circularProgressWidget()
        : MaterialButton(
            minWidth: 360,
            height: 55,
            color: Color(0xff314B8C),
            onPressed: () async {
              createTenantRequest();
            },
            child: Text("Create Tenant",
                style: Theme.of(context).primaryTextTheme.subtitle1),
          );
  }
}
