import "package:flutter/material.dart";
import 'package:propview/models/User.dart';
import 'package:propview/services/userService.dart';

class AttendanceHome extends StatefulWidget {
  const AttendanceHome();

  @override
  _AttendanceHomeState createState() => _AttendanceHomeState();
}

class _AttendanceHomeState extends State<AttendanceHome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool loading = false;
  User user;

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
