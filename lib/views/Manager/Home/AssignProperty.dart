import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/config.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyAsignmnet.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/PropertyAssignment.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';

class AssignProperty extends StatefulWidget {
  final PropertyElement propertyElement;
  const AssignProperty({this.propertyElement});

  @override
  _AssignPropertyState createState() => _AssignPropertyState();
}

class _AssignPropertyState extends State<AssignProperty> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool loading = false;
  User user0;
  User user1;
  User temp;
  List<User> userList = [];
  getData() async {
    setState(() {
      loading = true;
    });
    int id0 = await PropertyAssignment.getTempUserIDFromProperty0(
      widget.propertyElement.tableproperty.propertyId,
    );
    int id1 = await PropertyAssignment.getTempUserIDFromProperty(
      widget.propertyElement.tableproperty.propertyId,
    );
    User user = await UserService.getUser();
    userList = await UserService.getAllUserUnderManger(user.userId);
    List<User> tempUsers3 = [];
    for (int i = 0; i < userList.length; i++) {
      if (userList[i].userType == "manager") {
        List<User> tempUsers =
            await UserService.getAllUserUnderManger(userList[i].userId);
        tempUsers3.addAll(tempUsers);    
      }
    }
    setState(() {
      userList.addAll(tempUsers3);
    });
    user0 = await UserService.getUserById(id0);
    userList.removeWhere((element) => element.cid != user0.cid);
    if (id1 != 0) {
      user1 = await UserService.getUserById(id1);
      temp = user1;
    }
    setState(() {
      loading = false;
    });
  }

  TextEditingController _user = TextEditingController();

  bool showForm = false;

  User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Property Assignment",
          style: TextStyle(color: Color(0xff314B8C)),
        ),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: circularProgressWidget(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Actually Assigned:",
                      style: TextStyle(
                          color: Color(0xff314B8C),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    UserCard(user0),
                    SizedBox(
                      height: 16,
                    ),
                    user1 != null
                        ? Text(
                            "Temporarily Assigned:",
                            style: TextStyle(
                                color: Color(0xff314B8C),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        : SizedBox(),
                    user1 != null
                        ? Text(
                            "(Tap to reselect temp assigne)",
                            style: TextStyle(
                                color: Color(0xff314B8C),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        : SizedBox(),
                    user1 != null
                        ? SizedBox(
                            height: 8,
                          )
                        : SizedBox(),
                    user1 != null
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                showForm = true;
                                user1 = null;
                              });
                            },
                            child: UserCard(user1),
                          )
                        : SizedBox(),
                    user1 != null
                        ? SizedBox(
                            height: 16,
                          )
                        : SizedBox(),
                    
                    temp == user1 && user1 != null
                        ? MaterialButton(
                            minWidth: 250,
                            height: 50,
                            color: Color(0xff314B8C),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("Remove Temp Assign Property",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle1),
                            ),
                            onPressed: () async {
                              if (temp == user1) {
                                PropertyAssignmentModel res =
                                    await PropertyAssignment
                                        .getTempAssignRowByUserId(user1.userId);
                                List<String> res2 = res.propertyId.split(",");
                                res2.removeWhere(
                                  (element) =>
                                      element ==
                                      widget.propertyElement.tableproperty
                                          .propertyId
                                          .toString(),
                                );

                                bool res3 = await PropertyAssignment
                                    .updateTempAssignment(
                                        res2, res.userToPropertyId);
                                if (res3) {
                                  showInSnackBar(context,
                                      "Assigne succesfully removed", 800);
                                  setState(() {
                                    showForm = true;
                                    user1 = null;
                                  });
                                } else {
                                  showInSnackBar(
                                      context, "Assigne removal failed2", 800);
                                }
                              }
                            },
                          )
                        : SizedBox(),
                    user1 != null
                        ? SizedBox(
                            height: 16,
                          )
                        : SizedBox(),
                    showForm
                        ? SizedBox()
                        : MaterialButton(
                            minWidth: 250,
                            height: 50,
                            color: Color(0xff314B8C),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("Temp Assign Property",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle1),
                            ),
                            onPressed: () async {
                              if (temp != user1) {
                                var res = await PropertyAssignment
                                    .getTempAssignRowByUserId(user1.userId);
                                if (res == 0) {
                                  bool res = await PropertyAssignment
                                      .createTempAssignment({
                                    "user_id": user1.userId,
                                    "property_id": widget.propertyElement
                                        .tableproperty.propertyId
                                  });
                                  if (res) {
                                    showInSnackBar(context,
                                        "Property succesfully assigned", 800);
                                  } else {
                                    showInSnackBar(context,
                                        "Property assignment failed1", 800);
                                  }
                                } else {
                                  if (res.propertyId == "") {
                                    res.propertyId = widget.propertyElement
                                        .tableproperty.propertyId
                                        .toString();
                                  } else {
                                    res.propertyId = res.propertyId +
                                        "," +
                                        widget.propertyElement.tableproperty
                                            .propertyId
                                            .toString();
                                  }
                                  bool res2 = await PropertyAssignment
                                      .updateTempAssignment(
                                          res, res.userToPropertyId);
                                  if (res2) {
                                    showInSnackBar(context,
                                        "Property succesfully assigned", 800);
                                  } else {
                                    showInSnackBar(context,
                                        "Property assignment failed2", 800);
                                  }
                                }
                              } else {
                                setState(() {
                                  showForm = true;
                                });
                              }
                            },
                          ),
                    showForm
                        ? Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Employee: ",
                                    style: GoogleFonts.nunito(
                                        color: Color(0xff314B8C),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    height: 60,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Color(0xff314B8C).withOpacity(0.12),
                                    ),
                                    child: TypeAheadFormField(
                                      textFieldConfiguration:
                                          TextFieldConfiguration(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                        controller: this._user,
                                      ),
                                      suggestionsCallback: (pattern) {
                                        List<User> matches = [];
                                        matches.addAll(userList);
                                        matches.retainWhere((s) => s.name
                                            .toLowerCase()
                                            .contains(pattern.toLowerCase()));
                                        return matches;
                                      },
                                      itemBuilder: (context, User user) {
                                        return ListTile(
                                          title: Text(user.name),
                                          subtitle: Text(user.designation),
                                        );
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Type to find executive!',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontSize: 18.0),
                                            ),
                                          ),
                                        );
                                      },
                                      transitionBuilder: (context,
                                          suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        this._user.text =
                                            suggestion.name.toString();
                                        setState(() {
                                          user1 = suggestion;
                                          showForm = false;
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            setState(() {
                                              _user.clear();
                                            });
                                          });
                                        });
                                      },
                                      validator: (value) => value.isEmpty
                                          ? 'Please select a user'
                                          : null,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    showForm
                        ? MaterialButton(
                            minWidth: 250,
                            height: 50,
                            color: Color(0xff314B8C),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("Select User",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .subtitle1),
                            ),
                            onPressed: () async {
                              setState(() {
                                showForm = false;
                              });
                            },
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
    );
  }

  // ignore: non_constant_identifier_names
  UserCard(User cardUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(0.0, 0.0),
                blurRadius: 2.5,
                spreadRadius: 0.0,
              ),
              BoxShadow(
                color: Colors.grey,
                offset: const Offset(0.0, 0.0),
                blurRadius: 2.5,
                spreadRadius: 0.0,
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: ClipOval(
                      child: FadeInImage.assetNetwork(
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                        placeholder: "assets/loader.gif",
                        image:
                            "${Config.STORAGE_ENDPOINT}${cardUser.userId}.jpeg",
                        imageErrorBuilder: (BuildContext context,
                            Object exception, StackTrace stackTrace) {
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15,
                            backgroundImage: AssetImage(
                              "assets/dummy.png",
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cardUser.name,
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "+91 " + cardUser.officialNumber.toString(),
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          cardUser.officialEmail,
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
