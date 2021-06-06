import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/authService.dart';
import 'package:propview/services/notificationService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/routing.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/landingPage.dart' as ad;
import 'package:propview/views/Manager/landingPage.dart' as man;
import 'package:propview/views/Employee/landingPage.dart' as emp;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  String email;
  String password;
  User tempUser;

  final formkey = new GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        email = emailController.text;
      });
    });

    passwordController.addListener(() {
      setState(() {
        password = passwordController.text;
      });
    });
  }

  getDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fcmToken = await messaging.getToken();
    prefs.setString('deviceToken', fcmToken);
    return fcmToken;
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

  login() async {
    setState(() {
      isLoading = true;
    });
    if (checkFields()) {
      bool isAuthenticated = await AuthService.authenticate(email, password);
      if (isAuthenticated) {
        await getUserAndSaveToken();
        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        print(settings.authorizationStatus.toString());
        if (settings.authorizationStatus.toString() ==
            "AuthorizationStatus.authorized") {
          showInSnackBar(context, 'Logged In Successfully !!', 2500);
          setState(() {
            isLoading = false;
          });
          if (tempUser.userType == "admin" ||
              tempUser.userType == "super_admin") {
            Routing.makeRouting(context,
                routeMethod: 'pushReplacement',
                newWidget: ad.LandingScreen(selectedIndex: 0));
          } else if (tempUser.userType == "manager") {
            Routing.makeRouting(context,
                routeMethod: 'pushReplacement',
                newWidget: man.LandingScreen(selectedIndex: 0));
          } else if (tempUser.userType == "employee") {
            Routing.makeRouting(context,
                routeMethod: 'pushReplacement',
                newWidget: emp.LandingScreen(selectedIndex: 0));
          } else {
            Routing.makeRouting(context,
                routeMethod: 'pushReplacement',
                newWidget: emp.LandingScreen(selectedIndex: 0));
          }
        } else {
          showInSnackBar(context, 'Check notification settings', 2500);
        }
      } else {
        showInSnackBar(context, 'Authentication Denied!', 2500);
        AuthService.clearAuth();
      }
    } else {
      setState(() {
        isLoading = false;
      });
      showInSnackBar(context, 'Fill all the fields!', 2500);
    }
    setState(() {
      isLoading = false;
    });
  }

  getUserAndSaveToken() async {
    tempUser = await UserService.getUser();
    String deviceToken = await getDeviceToken();
    print(deviceToken);
    setState(() {
      tempUser.deviceToken = deviceToken;
    });
    bool isUpdated =
        await UserService.updateUser(json.encode(tempUser.toJson()));
    return isUpdated;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: UIConstants.fitToHeight(640, context),
        width: UIConstants.fitToWidth(360, context),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 48.0, left: 32.0, right: 32.0, bottom: 32.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                headingWidget(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                logoWidget(context),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                formWidget(context),
                SizedBox(height: UIConstants.fitToHeight(16, context)),
                (!isLoading) ? buttonWidget(context) : circularProgressWidget(),
                SizedBox(height: UIConstants.fitToHeight(24, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget headingWidget(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PropView",
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(fontSize: 28)),
          Text("Login to continue",
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(fontSize: 18, color: Color(0xffA09898))),
        ]);
  }

  Widget logoWidget(BuildContext context) {
    return Align(
        alignment: Alignment.center, child: Image.asset(UIConstants.logo));
  }

  Widget buttonWidget(BuildContext context) {
    return MaterialButton(
      minWidth: 360,
      height: 55,
      color: Color(0xff314B8C),
      onPressed: () async {
        await login();
      },
      child: Text("Login", style: Theme.of(context).primaryTextTheme.subtitle1),
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
              formheaderWidget(context, 'Email/Username'),
              inputWidget(emailController, "Please Enter your Email", false,
                  (value) {
                email = value;
              }),
              SizedBox(
                height: UIConstants.fitToHeight(18, context),
              ),
              formheaderWidget(context, 'Password'),
              inputWidget(
                  passwordController, "Please Enter your Password", true,
                  (value) {
                password = value;
              }),
            ],
          )),
    );
  }

  Widget formheaderWidget(BuildContext context, String text) {
    return Text(
      text,
      style: GoogleFonts.nunito(
          color: Color(0xffA09898), fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget inputWidget(TextEditingController textEditingController,
      String validation, bool, save) {
    return TextFormField(
      controller: textEditingController,
      obscureText: bool,
      validator: (value) => value.isEmpty ? validation : null,
      onSaved: save,
    );
  }
}
