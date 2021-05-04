import 'package:flutter/material.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/authService.dart';
import 'package:propview/services/userService.dart';

import '../loginSceen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  User user;
  bool loading = false;

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    setState(() {
      loading = false;
    });
  }
  Widget profileInfo(String labelText, String labelValue, IconData icon, Function function) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text('$labelText',
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold)),
      subtitle: Text(
        '$labelValue',
        style: TextStyle(fontSize: 15, color: Colors.black),
      ),
      onTap: function,
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator(),):  Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height:MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color:Color(0xff314B8C),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(27.0),
                      bottomRight: Radius.circular(27.0),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        height: 56),
                    CircleAvatar(
                      backgroundImage: NetworkImage("http://ircmhealth.com/new/wp-content/uploads/2015/08/person-dummy.jpg"),
                      backgroundColor: Colors.white,
                      radius: 80,
                    ),
                    SizedBox(
                        height: 20),
                    Text('${user.name}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.46)),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10,
                          bottom:20),
                      child: InkWell(
                        onTap: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => AddDataScreen()));
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              profileInfo('Name', '${user.name}', Icons.person,(){}),
              profileInfo('Phone Number', '${user.officialNumber}', Icons.call,(){}),
              profileInfo('Email', '${user.officialEmail}', Icons.mail,(){}),
              profileInfo(
                  'Access Level', '${user.userType}', Icons.security,(){}),
              profileInfo(
                  'Logout', '', Icons.exit_to_app_rounded,(){
                    AuthService.clearAuth();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
              }),
              SizedBox(height: 100,),
            ],
          ),
        ))
    ;
  }
}
