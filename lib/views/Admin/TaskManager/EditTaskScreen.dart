import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/NotificationService.dart';
import 'package:propview/services/propertyOwnerService.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/taskService.dart';
import 'package:propview/services/userService.dart';

import 'package:propview/views/Admin/landingPage.dart';

// Approved/NotApproved/Completed/transferred

import 'package:propview/utils/progressBar.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskElement task;

  const EditTaskScreen({this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  User _selectedUser;

  TextEditingController _taskDescription = new TextEditingController();

  TextEditingController _taskName = new TextEditingController();
  TextEditingController _taskStartDateTime = new TextEditingController(
      text:
          '${DateTime.now().day.toString().padLeft(2, "0")}/${DateTime.now().month.toString().padLeft(2, "0")}/${DateTime.now().year}    ${DateTime.now().hour.toString().padLeft(2, "0")}:${DateTime.now().minute.toString().padLeft(2, "0")}');
  TextEditingController _taskEndDateTime = new TextEditingController(
      text:
          '${DateTime.now().add(Duration(minutes: 10)).day.toString().padLeft(2, "0")}/${DateTime.now().add(Duration(minutes: 10)).month.toString().padLeft(2, "0")}/${DateTime.now().add(Duration(minutes: 10)).year}    ${DateTime.now().add(Duration(minutes: 10)).hour.toString().padLeft(2, "0")}:${DateTime.now().add(Duration(minutes: 10)).minute.toString().padLeft(2, "0")}');
  TextEditingController _taskStartDateTime2 =
      new TextEditingController(text: DateTime.now().toString());
  TextEditingController _taskEndDateTime2 = new TextEditingController(
      text: DateTime.now().add(Duration(minutes: 10)).toString());

  PropertyOwnerElement propertyOwner;
  PropertyElement property;
  bool loading = false;
  TaskElement task;

  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true;
      task = widget.task;
    });
    propertyOwner = await PropertyOwnerService.getPropertyOwner(
        widget.task.propertyOwnerRef);
    property = await PropertyService.getPropertyById(widget.task.propertyRef);
    _selectedUser = await UserService.getUserById(task.assignedTo);
    _taskName.text = task.taskName;
    _taskDescription.text = task.taskDesc;
    _taskStartDateTime.text = '${task.startDateTime.day.toString().padLeft(2, "0")}/${task.startDateTime.month.toString().padLeft(2, "0")}/${task.startDateTime.year}    ${task.startDateTime.hour.toString().padLeft(2, "0")}:${task.startDateTime.minute.toString().padLeft(2, "0")}';
    _taskEndDateTime.text = '${task.endDateTime.day.toString().padLeft(2, "0")}/${task.endDateTime.month.toString().padLeft(2, "0")}/${task.endDateTime.year}    ${task.endDateTime.hour.toString().padLeft(2, "0")}:${task.endDateTime.minute.toString().padLeft(2, "0")}';
    _taskStartDateTime2.text = task.startDateTime.toString();
    _taskEndDateTime2.text = task.endDateTime.toString();
    setState(() {
      loading = false;
    });
  }

  bool load = false;
  bool propertySelectBox = false;

  checkPayload() {
    if (task.category == "Propdial Office Work" ||
        task.category == "Other Executive Work") {
      if (_taskName.text.length > 0 &&
          _taskDescription.text.length > 0 &&
          _taskStartDateTime2.text.length > 0 &&
          _taskEndDateTime2.text.length > 0 &&
          _selectedUser.userId.toString().length > 0) {
        return true;
      } else {
        return false;
      }
    } else {
      if (_taskName.text.length > 0 &&
          _taskDescription.text.length > 0 &&
          _taskStartDateTime2.text.length > 0 &&
          _taskEndDateTime2.text.length > 0 &&
          _selectedUser.userId.toString().length > 0) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: loading
          ? circularProgressWidget()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, bottom: 24.0, top: 36),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/task.png",
                          height: 75,
                        ),
                        Text(
                          "Create\nNew Task",
                          style: GoogleFonts.nunito(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
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
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xff314B8C).withOpacity(0.12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedUser.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(_selectedUser.designation),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Task Category: ",
                              style: GoogleFonts.nunito(
                                  color: Color(0xff314B8C),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xff314B8C).withOpacity(0.12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.task.category,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    task.category == "Propdial Office Work" ||
                            task.category == "Other Executive Work"
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Owner: ",
                                    style: GoogleFonts.nunito(
                                        color: Color(0xff314B8C),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 60,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color(0xff314B8C).withOpacity(0.12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        propertyOwner.salutation.trim() +
                                            " " +
                                            propertyOwner.ownerName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                    task.category == "Propdial Office Work" ||
                            task.category == "Other Executive Work"
                        ? Container()
                        : propertySelectBox
                            ? SizedBox(
                                height: 8,
                              )
                            : Container(),
                    task.category == "Propdial Office Work" ||
                            task.category == "Other Executive Work"
                        ? Container()
                        : propertySelectBox
                            ? Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Property: ",
                                  style: GoogleFonts.nunito(
                                      color: Color(0xff314B8C),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                    SizedBox(
                      height: 8,
                    ),
                    task.category == "Propdial Office Work" ||
                            task.category == "Other Executive Work"
                        ? Container()
                        : propertySelectBox
                            ? Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Color(0xff314B8C).withOpacity(0.12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.propertyName.trim(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                    task.category == "Propdial Office Work" ||
                            task.category == "Other Executive Work"
                        ? Container()
                        : propertySelectBox
                            ? SizedBox(
                                height: 8,
                              )
                            : Container(),
                    inputField("Task Name:", _taskName, 1),
                    inputField("Task Description:", _taskDescription, 5),
                    inputDateTime("Start Date and Time:", _taskStartDateTime,
                        _taskStartDateTime2, true),
                    inputDateTime("End Date and Time:", _taskEndDateTime,
                        _taskEndDateTime2, false),
                    SizedBox(
                      height: 16,
                    ),
                    MaterialButton(
                      minWidth: 250,
                      color: Color(0xff314B8C),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Create Task",
                            style:
                                Theme.of(context).primaryTextTheme.subtitle1),
                      ),
                      onPressed: () async {
                        if (checkPayload()) {
                          setState(() {
                            load = true;
                          });
                          var payload = jsonEncode({
                            "category": task.category,
                            "task_name": _taskName.text.trim(),
                            "property_name":
                                task.category == "Propdial Office Work" ||
                                        task.category == "Other Executive Work"
                                    ? "noproperty"
                                    : task.propertyName.trim(),
                            "task_desc": _taskDescription.text,
                            "task_status": task.taskStatus == "Rejected" ? "Pending" : task.taskStatus,
                            "start_dateTime": _taskStartDateTime2.text,
                            "end_dateTime": _taskEndDateTime2.text,
                            "assigned_to": _selectedUser.userId.toString(),
                            "property_ref":
                                task.category == "Propdial Office Work" ||
                                        task.category == "Other Executive Work"
                                    ? 14
                                    : task.propertyRef.toString(),
                            "created_at": task.createdAt.toString(),
                            "updated_at": DateTime.now().toString(),
                            "property_owner_ref":
                                task.category == "Propdial Office Work" ||
                                        task.category == "Other Executive Work"
                                    ? 13
                                    : task.propertyOwnerRef.toString(),
                          });
                          bool response = await TaskService.createTask(payload);
                          setState(() {
                            load = false;
                          });
                          if (response) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LandingScreen(
                                  selectedIndex: 1,
                                ),
                              ),
                            );
                            NotificationService.sendPushToOneWithTime(
                                "New Task Assigned",
                                "A new task Has been Assigned : ${_taskName.text}",
                                _selectedUser.deviceToken,
                                _taskStartDateTime2.text,
                                _taskEndDateTime2.text);
                            var managerToken = await UserService.getDeviceToken(
                                _selectedUser.parentId.toString());
                            NotificationService.sendPushToOne(
                              "New Task Assigned",
                              "A new task Has been Assigned to your employee : ${_taskName.text}",
                              managerToken,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Task Creation Failed"),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Fill all details"),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  inputDateTime(label, controller, controller2, isStart) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              label,
              style: GoogleFonts.nunito(
                  color: Color(0xff314B8C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                onChanged: (date) {
                  setState(() {
                    controller.text =
                        '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year}    ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}';
                    controller2.text = date.toString();
                  });
                },
                onConfirm: (date) {
                  setState(() {
                    controller.text =
                        '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year}    ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}';
                    controller2.text = date.toString();
                  });
                },
                currentTime: isStart
                    ? DateTime.now()
                    : DateTime.now().add(Duration(minutes: 10)),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xff314B8C).withOpacity(0.12),
              ),
              child: TextField(
                enabled: false,
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.alarm_on,
                    color: Colors.black,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
                controller: controller,
              ),
            ),
          ),
        ],
      ),
    );
  }

  inputField(label, controller, length) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              label,
              style: GoogleFonts.nunito(
                  color: Color(0xff314B8C),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xff314B8C).withOpacity(0.12),
            ),
            child: TextField(
              style: TextStyle(fontSize: 16, color: Colors.black),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
              ),
              controller: controller,
              minLines: length,
              maxLines: 5,
            ),
          ),
        ],
      ),
    );
  }
}
