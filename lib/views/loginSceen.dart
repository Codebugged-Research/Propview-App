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
import 'package:propview/views/landingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  String email;
  String password;

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
    prefs.setString('device_token', fcmToken);
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
      try {
        bool isAuthenticated = await AuthService.authenticate(email, password);
        if (isAuthenticated) {
          getUserAndSaveToken();
          NotificationSettings settings = await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
          if (settings.authorizationStatus.toString() ==
              "AuthorizationStatus.authorized") {
            showInSnackBar(context, 'Logged In Successfully !!', 2500);
            var id = await NotificationService.genTokenID();
            await NotificationService.sendPushToOne(
                "Welcome", "You are successfully logged in into PropView", id);

            Routing.makeRouting(context,
                routeMethod: 'pushReplacement',
                newWidget: LandingScreen(selectedIndex: 0));
          } else {
            showInSnackBar(context, 'Check notification settings', 2500);
            AuthService.clearAuth();
          }
        } else {
          showInSnackBar(context, 'Authentication Denied!', 2500);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        showInSnackBar(context, 'Something went wrong!', 2500);
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
    User user = await UserService.getUser();
    String deviceToken = await getDeviceToken();
    setState(() {
      user.deviceToken = deviceToken;
    });
    bool isUpdated = await UserService.updateUser(json.encode(user.toJson()));
    print(isUpdated);
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
