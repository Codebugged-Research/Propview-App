import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/widgets/propertyCard.dart';

import 'package:propview/config.dart';
import 'package:propview/views/Employee/Profile/ProfileScreen.dart';
import 'package:propview/views/Manager/Home/searchScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;
  Property property;
  bool loading = false;
  bool loading2 = false;

  int page = 0;
  ScrollController _sc = new ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    property = await PropertyService.getAllPropertiesByUserId(user.userId);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? circularProgressWidget()
        : Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 64, 12, 12),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    leading: ClipOval(
                      child: FadeInImage.assetNetwork(
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        placeholder: "assets/loader.gif",
                        image: "${Config.STORAGE_ENDPOINT}${user.userId}.jpeg",
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            backgroundImage: AssetImage(
                              "assets/dummy.png",
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headline5
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Employee",
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle2
                          .copyWith(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(
                                  property: property,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[200],
                                    offset: const Offset(
                                      0.0,
                                      0.0,
                                    ),
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                  ),
                                ]),
                            child: Icon(
                              Icons.search,
                              color: Color(0xff314B8C),
                              size: 24,
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 16,
                        // ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    child: Text(
                      "Properties",
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _sc,
                    padding: EdgeInsets.only(top: 0, left: 8, right: 8),
                    itemCount: property.data.property.length + 1,
                    itemBuilder: (context, index) {
                      return index == property.data.property.length
                          ? Center(
                              child: loading2
                                  ? circularProgressWidget()
                                  : Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text("No more Properties"),
                                    ))
                          : PropertyCard(
                              propertyElement: property.data.property[index],
                            );
                    },
                  ),
                )
              ],
            ),
          );
  }
}
