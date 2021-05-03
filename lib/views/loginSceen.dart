import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:propview/services/baseService.dart';
import 'package:propview/views/landingPage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "PropView",
                      style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Login to continue",
                      style: GoogleFonts.nunito(
                          color: Color(0xffA09898),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Image.asset("assets/login.png"),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Email / Username",
                      style: GoogleFonts.nunito(
                          color: Color(0xffA09898),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Password",
                      style: GoogleFonts.nunito(
                          color: Color(0xffA09898),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    controller: _passwordController,
                  )
                ],
              ),
              MaterialButton(
                minWidth: 360,
                height: 55,
                color: Color(0xff314B8C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () async {
                  var response = await BaseService.makeUnauthenticatedRequest(
                      BaseService.BASE_URI + "api/signin",
                      body: jsonEncode({
                        "email": _emailController.text,
                        "password": _passwordController.text
                      }));
                  if(response.statusCode == 200){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LandingPage()));
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed !!!")));
                  }
                  print(response.statusCode);
                  print(jsonDecode(response.body)["token"].toString());
                },
                child: Text(
                  "Login",
                  style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
