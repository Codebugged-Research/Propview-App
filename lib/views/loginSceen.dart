import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  TextField(),
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
                  )
                ],
              ),
              MaterialButton(
                minWidth: 360,
                height: 55,
                color: Color(0xff314B8C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onPressed: () {},
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
