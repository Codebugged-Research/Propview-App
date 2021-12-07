import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:propview/constants/uiConstants.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/Tenant.dart';
import 'package:propview/services/tenantFamilyService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/Inspection/MoveInInspection/moveInInspectionLoaderScreen.dart';
import 'package:propview/views/Admin/Inspection/inspectionHomeScreen.dart';
import 'package:propview/views/Admin/landingPage.dart';

class AddTenantFamilyScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  final List<Tenant> tenants;

  AddTenantFamilyScreen({this.propertyElement, this.tenants});

  @override
  _AddTenantFamilyScreenState createState() => _AddTenantFamilyScreenState();
}

class _AddTenantFamilyScreenState extends State<AddTenantFamilyScreen> {
  bool isLoading = false;
  String genderValue = 'Male';

  PropertyElement propertyElement;
  Tenant selectedTenant;
  List<Tenant> tenants;
  List<String> genderList = ['Male', 'Female'];
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
    selectedTenant = tenants[0];
  }

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    setState(() {
      isLoading = false;
    });
    return false;
  }

  createTenantFamilyRequest() async {
    try {
      if (checkFields()) {
        setState(() {
          isLoading = true;
        });
        var payload = json.encode({
          "tenant_id": selectedTenant.tenantId,
          "name": nameController.text,
          "sex": sexController.text,
          "age": ageController.text,
          "mobile": phoneController.text,
          "email": emailController.text,
          "relationship": relationshipController.text,
        });
        bool isCreated = await TenantFamilyService.createTenantFamily(payload);
        if (isCreated) {
          setState(() {
            isLoading = false;
          });
          showInSnackBar(context, 'Tenant-Family added successfully!', 2500);
          Timer(Duration(milliseconds: 2510), () {
           Routing.makeRouting(
              context,
              routeMethod: 'pushAndRemoveUntil',
              newWidget: LandingScreen(selectedIndex: 2),
            );
            Routing.makeRouting(context,
                routeMethod: 'push',
                newWidget: InspectionHomeScreen(
                  propertyElement: propertyElement,
                ));
            Routing.makeRouting(
              context,
              routeMethod: 'push',
              newWidget: MoveInInspectionLoaderScreen(
                propertyElement: propertyElement,
              ),
            );
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showInSnackBar(
              context, 'Failed to create a Family Member! Try again.', 2500);
        }
      } else {
        setState(() {
          isLoading = false;
        });
        showInSnackBar(context, 'Fill all the details! Try again.', 2500);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showInSnackBar(context, 'Check your Network! Try again.', 2500);
    }
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
              titleWidget(context, 'Select Tenant:'),
              DropdownButton(
                isExpanded: true,
                value: selectedTenant,
                elevation: 8,
                underline: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff314B8C),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedTenant = value;
                  });
                },
                items: tenants.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Name'),
              inputWidget(nameController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Sex'),
              DropdownButton(
                isExpanded: true,
                value: genderValue,
                elevation: 8,
                underline: Container(
                  height: 2,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff314B8C),
                ),
                onChanged: (value) {
                  setState(() {
                    genderValue = value;
                    sexController.text = genderValue;
                  });
                },
                items: genderList.map<DropdownMenuItem>((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Age'),
              inputWidget(ageController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Phone Number'),
              inputWidget(phoneController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Email'),
              inputWidget(emailController),
              SizedBox(height: UIConstants.fitToHeight(12, context)),
              titleWidget(context, 'Relationship'),
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
    return isLoading
        ? circularProgressWidget()
        : MaterialButton(
            minWidth: 360,
            height: 55,
            color: Color(0xff314B8C),
            onPressed: () async {
              await createTenantFamilyRequest();
            },
            child: Text("Create Tenant-Family",
                style: Theme.of(context).primaryTextTheme.subtitle1),
          );
  }
}
