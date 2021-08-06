import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/notificationService.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/taskService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Manager/AssignedPersonDetailScreen.dart';
import 'package:propview/views/Manager/Property/PropertyDetailScreen.dart';
import 'package:propview/views/Manager/Property/PropertyOwnerDetailScreen.dart';
import 'package:propview/views/Manager/TaskManager/SoloCalendar.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  final TaskElement taskElement;
  Function change1;
  Function change2;
  final User currentUser;
  final bool isSelf;
  TaskCard({
    this.taskElement,
    this.currentUser,
    this.isSelf,
    this.change1,
    this.change2,
  });

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  String propName;
  bool loading = false;

  getData() async {
    setState(() {
      loading = true;
    });
    propName = await PropertyService.getSocietyName(
            widget.taskElement.property.socid) +
        " , " +
        widget.taskElement.property.unitNo;
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? circularProgressWidget()
        : GestureDetector(
            onTap: () {
              taskDetailsWidget(context);
            },
            onLongPress: widget.isSelf
                ? () {}
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SoloCalendar(
                          id: widget.taskElement.assignedTo,
                        ),
                      ),
                    );
                  },
            child: Padding(
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
                height: widget.isSelf ? 120 : 142,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                        context,
                        "Property: ",
                        propName,
                      ),
                      textWidget(
                          context, "Task Type: ", widget.taskElement.category),
                      textWidget(
                          context, "Task Name: ", widget.taskElement.taskName),
                      !widget.isSelf
                          ? textWidget(
                              context,
                              "Assigned: ",
                              widget.taskElement.tblUsers.name +
                                  "\n(${widget.taskElement.tblUsers.designation})")
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget textWidget(BuildContext context, String label, String data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Text(
            data,
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  taskDetailsWidget(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Color(0xFFFFFFFF),
        builder: (BuildContext context) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Task Details',
                          style: Theme.of(context).primaryTextTheme.headline6,
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Divider(
                          color: Color(0xff314B8C),
                          thickness: 2.5,
                          indent: 100,
                          endIndent: 100,
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    titleWidget(
                        context, 'Task ID: ', '${widget.taskElement.taskId}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Status: ',
                        '${widget.taskElement.taskStatus}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(
                      context,
                      'Property: ',
                      propName,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Category: ',
                        '${widget.taskElement.category}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task name: ',
                        '${widget.taskElement.taskName.trim()}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Description: ',
                        '${widget.taskElement.taskDesc}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Start Time: ',
                        '${dateTimeFormatter(widget.taskElement.startDateTime.toString())}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task End Time: ',
                        '${dateTimeFormatter(widget.taskElement.endDateTime.toString())}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        widget.taskElement.category == "Propdial Office Work" ||
                                widget.taskElement.category ==
                                    "Other Executive Work"
                            ? Container()
                            : InkWell(
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          "assets/house.png",
                                          height: 35,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Property\ndetails",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PropertyDetailScreen(
                                        propertyId:
                                            widget.taskElement.propertyRef,
                                      ),
                                    ),
                                  );
                                },
                              ),
                        widget.taskElement.category == "Propdial Office Work" ||
                                widget.taskElement.category ==
                                    "Other Executive Work"
                            ? Container()
                            : SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                        widget.taskElement.category == "Propdial Office Work" ||
                                widget.taskElement.category ==
                                    "Other Executive Work"
                            ? Container()
                            : InkWell(
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          "assets/owner.png",
                                          height: 35,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Property\nOwner details",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PropertyOwnerDetailScreen(
                                        propertyOwnerId:
                                            widget.taskElement.propertyOwnerRef,
                                      ),
                                    ),
                                  );
                                },
                              ),
                        widget.taskElement.category == "Propdial Office Work" ||
                                widget.taskElement.category ==
                                    "Other Executive Work"
                            ? Container()
                            : SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.02),
                        InkWell(
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/person.png",
                                    height: 35,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Assigned\nPerson details",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AssignedPersonDetailScreen(
                                  assignedTo: widget.taskElement.assignedTo,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    widget.currentUser.userId.toString() ==
                            widget.taskElement.assignedTo
                        ? widget.taskElement.taskStatus == "Pending" ||
                                widget.taskElement.taskStatus == "Rejected"
                            ? Align(
                                alignment: Alignment.center,
                                child: MaterialButton(
                                  child: Text(
                                    "submit Task",
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .subtitle2
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  color: Color(0xff314B8C),
                                  onPressed: () async {
                                    await showDialog(
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          "Alert !",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline5
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        content: Text(
                                          "Do you want to submit your task ?",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle1
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () async {
                                              setState(() {
                                                widget.taskElement.taskStatus =
                                                    "Unapproved";
                                              });
                                              var response =
                                                  await TaskService.updateTask(
                                                      widget.taskElement.taskId,
                                                      jsonEncode(widget
                                                          .taskElement
                                                          .toJson()));
                                              if (response) {
                                                if (widget.taskElement.tblUsers
                                                        .deviceToken !=
                                                    "") {
                                                  NotificationService
                                                      .sendPushToOne(
                                                    "Task Submitted",
                                                    "Task " +
                                                        widget.taskElement
                                                            .taskName +
                                                        " is submitted by " +
                                                        widget.taskElement
                                                            .tblUsers.name,
                                                    widget.taskElement.tblUsers
                                                        .deviceToken,
                                                  );
                                                  if (widget
                                                              .taskElement
                                                              .tblUsers
                                                              .parentId !=
                                                          "0" &&
                                                      widget
                                                              .taskElement
                                                              .tblUsers
                                                              .parentId !=
                                                          "") {
                                                    for (int i = 0;
                                                        i <
                                                            widget
                                                                .taskElement
                                                                .tblUsers
                                                                .parentId
                                                                .split(",")
                                                                .length;
                                                        i++) {
                                                      var managerToken =
                                                          await UserService
                                                              .getDeviceToken(widget
                                                                  .taskElement
                                                                  .tblUsers
                                                                  .parentId
                                                                  .split(
                                                                      ",")[i]);
                                                      NotificationService
                                                          .sendPushToOne(
                                                        "Task Submitted",
                                                        "Task " +
                                                            widget.taskElement
                                                                .taskName +
                                                            " is submitted by " +
                                                            widget.taskElement
                                                                .tblUsers.name,
                                                        managerToken,
                                                      );
                                                    }
                                                  }
                                                  widget.change1(
                                                      widget.taskElement);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  showInSnackBar(
                                                      context,
                                                      "Task Updation successfull",
                                                      1500);
                                                } else {
                                                  showInSnackBar(
                                                      context,
                                                      "Task Updation failed try agin later",
                                                      800);
                                                  Navigator.of(context).pop();
                                                }
                                              }
                                            },
                                            child: Text(
                                              "Yes",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .subtitle2
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "No",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .subtitle2
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                      context: context,
                                    );
                                  },
                                ),
                              )
                            : Container()
                        : Container(),
                    widget.taskElement.tblUsers.parentId
                            .split(",")
                            .contains(widget.currentUser.userId.toString())
                        // ||
                        //     widget.currentUser.userType == "admin" ||
                        //     widget.currentUser.userType == "super_admin"
                        ? widget.taskElement.taskStatus == "Unapproved"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: MaterialButton(
                                      child: Text(
                                        "Approve Task",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                      ),
                                      color: Color(0xff314B8C),
                                      onPressed: () async {
                                        await showDialog(
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              "Alert !",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline5
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            content: Text(
                                              "Do you want to approve the assignment of task ?",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    widget.taskElement
                                                            .taskStatus =
                                                        "Completed";
                                                  });
                                                  var response =
                                                      await TaskService
                                                          .updateTask(
                                                              widget.taskElement
                                                                  .taskId,
                                                              jsonEncode(widget
                                                                  .taskElement
                                                                  .toJson()));
                                                  if (response) {
                                                    if (widget
                                                            .taskElement
                                                            .tblUsers
                                                            .deviceToken !=
                                                        "") {
                                                      NotificationService
                                                          .sendPushToOne(
                                                        "Task Submitted",
                                                        "Task " +
                                                            widget.taskElement
                                                                .taskName +
                                                            " is approved ",
                                                        widget
                                                            .taskElement
                                                            .tblUsers
                                                            .deviceToken,
                                                      );
                                                    }
                                                    widget.change1(
                                                        widget.taskElement);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    showInSnackBar(
                                                        context,
                                                        "Task Updation successfull ",
                                                        1500);
                                                  } else {
                                                    showInSnackBar(
                                                        context,
                                                        "Task Updation failed try agin later",
                                                        800);
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .subtitle2
                                                      .copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "No",
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .subtitle2
                                                      .copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                          context: context,
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: MaterialButton(
                                      child: Text(
                                        "Reject Task",
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                      ),
                                      color: Color(0xff314B8C),
                                      onPressed: () async {
                                        await showDialog(
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              "Alert !",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .headline5
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            content: Text(
                                              "Do you want to reject the assignment of task ?",
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    widget.taskElement
                                                            .taskStatus =
                                                        "Rejected";
                                                  });
                                                  var response =
                                                      await TaskService
                                                          .updateTask(
                                                              widget.taskElement
                                                                  .taskId,
                                                              jsonEncode(widget
                                                                  .taskElement
                                                                  .toJson()));
                                                  if (response) {
                                                    if (widget
                                                            .taskElement
                                                            .tblUsers
                                                            .deviceToken !=
                                                        "") {
                                                      NotificationService
                                                          .sendPushToOne(
                                                        "Task Rejected",
                                                        "Task " +
                                                            widget.taskElement
                                                                .taskName +
                                                            " is Rejected ",
                                                        widget
                                                            .taskElement
                                                            .tblUsers
                                                            .deviceToken,
                                                      );
                                                    }
                                                    widget.change2(
                                                        widget.taskElement);
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    showInSnackBar(
                                                        context,
                                                        "Task Rejection successful ",
                                                        1500);
                                                  } else {
                                                    showInSnackBar(
                                                        context,
                                                        "Task Rejection failed try again later",
                                                        800);
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .subtitle2
                                                      .copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "No",
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .subtitle2
                                                      .copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                          context: context,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Container()
                        : Container(),
                  ],
                ),
              ),
            ));
  }

  Widget titleWidget(BuildContext context, String label, String data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .primaryTextTheme
              .subtitle1
              .copyWith(color: Color(0xff314B8C), fontWeight: FontWeight.w700),
        ),
        Flexible(
          child: Text(
            data,
            style: Theme.of(context).primaryTextTheme.subtitle2.copyWith(
                color: Color(0xff141414), fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  dateTimeFormatter(String dat) {
    DateTime date = DateTime.parse(dat);
    return '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${DateTime.now().year}  ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}';
  }
}
