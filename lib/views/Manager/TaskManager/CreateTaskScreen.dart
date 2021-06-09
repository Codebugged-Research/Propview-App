import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/models/TaskCategory.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/notificationService.dart';
import 'package:propview/services/propertyOwnerService.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/taskCategoryService.dart';
import 'package:propview/services/taskServices.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/snackBar.dart';

import 'package:propview/views/Manager/landingPage.dart';

// Approved/NotApproved/Completed/transferred

import 'package:propview/utils/progressBar.dart';

class CreateTaskScreen extends StatefulWidget {
  final User user;
  CreateTaskScreen({this.user});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  List<DropdownMenuItem> _taskCategoryDropdownList = [];
  var _selectedTaskCategory;
  var _selectedPropertyOwner;
  var _selectedProperty;
  User _selectedUser;

  TextEditingController _taskDescription = new TextEditingController();

  TextEditingController _user = new TextEditingController();
  TextEditingController _propertyOwner = new TextEditingController();
  TextEditingController _property = new TextEditingController();
  TextEditingController _taskName = new TextEditingController();
  TextEditingController _taskStartDateTime =
      new TextEditingController(text: DateTime.now().toString());
  TextEditingController _taskEndDateTime =
      new TextEditingController(text: DateTime.now().toString());
  TextEditingController _taskStartDateTime2 =
      new TextEditingController(text: DateTime.now().toString());
  TextEditingController _taskEndDateTime2 =
      new TextEditingController(text: DateTime.now().toString());

  List<TaskCategory> taskCategories = [];
  List<PropertyElement> properties = [];
  List<User> users = [];
  // PropertyOwner propertyOwner;

  List<PropertyOwnerElement> propertyOwnerList = [];

  Property propertyList;
  bool loading = false;
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    // propertyList =
    //     await PropertyService.getAllPropertiesByUserId(widget.user.userId);
    propertyList = await PropertyService.getAllPropertiesByUserId(72);

    taskCategories = await TaskCategoryService.getTaskCategories();
    for (int i = 0; i < taskCategories.length; i++) {
      _taskCategoryDropdownList.add(
        DropdownMenuItem(
          child: Text(taskCategories[i].category),
          value: taskCategories[i].category,
        ),
      );
    }
    for (int i = 0; i < propertyList.count; i++) {
      propertyOwnerList.add(propertyList.data.property[i].propertyOwner);
    }
    // propertyOwner = await PropertyOwnerService.getAllPropertyOwner();
    users = await UserService.getAllUser();
    setState(() {
      _selectedTaskCategory = _taskCategoryDropdownList[0].value;
      loading = false;
    });
  }

  bool load = false;
  bool propertySelectBox = false;

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
                              "Select Category of Task: ",
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xff314B8C).withOpacity(0.12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: DropdownButton(
                                      value: _selectedTaskCategory,
                                      isExpanded: true,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      icon: Icon(
                                        Icons.list_alt,
                                        color: Colors.black,
                                      ),
                                      items: _taskCategoryDropdownList,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedTaskCategory = value;
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ),
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
                              "Select Property Owner: ",
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xff314B8C).withOpacity(0.12),
                              ),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  controller: this._propertyOwner,
                                ),
                                suggestionsCallback: (pattern) {
                                  List<PropertyOwnerElement> matches = [];
                                  matches.addAll(propertyOwnerList);
                                  matches.retainWhere((s) => s.ownerName
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()));
                                  return matches;
                                },
                                itemBuilder:
                                    (context, PropertyOwnerElement suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.ownerName),
                                    // subtitle: Text(propertyOwner.data.propertyOwner[i].ownerAddress,overflow: TextOverflow.ellipsis,softWrap: true,),
                                    leading:
                                        Text(suggestion.ownerId.toString()),
                                  );
                                },
                                noItemsFoundBuilder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Type to find Owner !',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (suggestion) async {
                                  propertySelectBox = false;
                                  this._propertyOwner.text =
                                      suggestion.ownerName.toString();
                                  setState(() {
                                    _selectedPropertyOwner = suggestion.ownerId;
                                  });
                                  var response = propertyList.data.property
                                      .where((element) =>
                                          element.tableproperty.ownerId ==
                                          suggestion.ownerId).toList();
                                  // var response = await PropertyService
                                  //     .getAllPropertiesByOwnerId(
                                  //         _selectedPropertyOwner);
                                  if (response == null) {
                                    showInSnackBar(
                                        context,
                                        "No property found in database !",
                                        2500);
                                  } else {
                                    showInSnackBar(
                                        context,
                                        "${response.length} property found in database !",
                                        2500);
                                    setState(() {
                                      properties.clear();
                                      properties = response;
                                    });
                                    propertySelectBox = true;
                                  }
                                },
                                validator: (value) => value.isEmpty
                                    ? 'Please select an Owner Name'
                                    : null,
                                // onSaved: (value) => this.propertyOwner = value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    propertySelectBox
                        ? SizedBox(
                            height: 8,
                          )
                        : Container(),
                    propertySelectBox
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Select Property of the Owner: ",
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
                    propertySelectBox
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xff314B8C).withOpacity(0.12),
                              ),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  controller: this._property,
                                ),
                                suggestionsCallback: (pattern) {
                                  List<PropertyElement> matches = [];
                                  matches.addAll(properties);
                                  print(matches[0].toJson());
                                  matches.retainWhere((s) => s
                                      .tableproperty.unitNo
                                      .toLowerCase()
                                      .contains(pattern != null
                                          ? pattern.toLowerCase()
                                          : ""));
                                  return matches;
                                },
                                itemBuilder:
                                    (context, PropertyElement suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.tableproperty.socid
                                        .toString()),
                                    leading: Text(suggestion
                                        .tableproperty.unitNo
                                        .toString()),
                                  );
                                },
                                noItemsFoundBuilder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Type to find property!',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (suggestion) {
                                  this._property.text = suggestion
                                          .tableproperty.unitNo
                                          .toString() +
                                      " " +
                                      suggestion.tableproperty.socid.toString();
                                  setState(() {
                                    _selectedProperty =
                                        suggestion.tableproperty.propertyId;
                                  });
                                },
                                validator: (value) => value.isEmpty
                                    ? 'Please select a property'
                                    : null,
                                // onSaved: (value) => this.propertyOwner = value,
                              ),
                            ),
                          )
                        : Container(),
                    propertySelectBox
                        ? SizedBox(
                            height: 8,
                          )
                        : Container(),
                    inputField("Enter Task Name", _taskName, 1),
                    inputField("Enter Task Description", _taskDescription, 5),
                    inputDateTime("Enter Start Date and Time",
                        _taskStartDateTime, _taskStartDateTime2),
                    inputDateTime("Enter End Date and Time", _taskEndDateTime,
                        _taskEndDateTime2),
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
                              "Select Employee: ",
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
                              height: 75,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xff314B8C).withOpacity(0.12),
                              ),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  controller: this._user,
                                ),
                                suggestionsCallback: (pattern) {
                                  List<User> matches = [];
                                  matches.addAll(users);
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
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (suggestion) {
                                  this._user.text = suggestion.name.toString() +
                                      "\n" +
                                      suggestion.designation.toString();
                                  setState(() {
                                    _selectedUser = suggestion;
                                  });
                                },
                                validator: (value) => value.isEmpty
                                    ? 'Please select a property'
                                    : null,
                                // onSaved: (value) => this.propertyOwner = value,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
                        setState(() {
                          load = true;
                        });
                        var payload = jsonEncode({
                          "category": _selectedTaskCategory,
                          "task_name": _taskName.text,
                          "task_desc": _taskDescription.text,
                          "task_status": "Pending",
                          "start_dateTime": _taskStartDateTime2.text,
                          "end_dateTime": _taskEndDateTime2.text,
                          "assigned_to": _selectedUser.userId.toString(),
                          "property_ref": _selectedProperty.toString(),
                          "created_at": DateTime.now().toString(),
                          "updated_at": DateTime.now().toString(),
                          "property_owner_ref": _selectedPropertyOwner,
                        });
                        print(payload);
                        bool response = await TaskService.createTask(payload);
                        setState(() {
                          load = false;
                        });
                        if (response) {
                          NotificationService.sendPushToOneWithTime(
                              "New Task Assigned",
                              "A new task Has been Assigned : ${_taskName.text}",
                              _selectedUser.deviceToken,
                              _taskStartDateTime.text,
                              _taskEndDateTime.text);
                          var managerToken = await UserService.getDeviceToken(
                              _selectedUser.parentId);
                          NotificationService.sendPushToOne(
                            "New Task Assigned",
                            "A new task Has been Assigned to your employee : ${_taskName.text}",
                            managerToken,
                          );
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LandingScreen(
                                    selectedIndex: 1,
                                  )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Task Creation Failed"),
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

  inputDateTime(label, controller, controller2) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunito(
                      color: Color(0xff314B8C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                MaterialButton(
                  color: Color(0xff314B8C),
                  onPressed: () {
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
                      currentTime: DateTime.now(),
                    );
                  },
                  child: Text(
                    "Select",
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xff314B8C).withOpacity(0.12),
            ),
            child: TextField(
              enabled: false,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.list_alt,
                  color: Colors.black,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
              ),
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  // inputDropDown(label, selectedItem, dropdownMenuItems) {
  //   return
  // }

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
                suffixIcon: Icon(
                  Icons.list_alt,
                  color: Colors.black,
                ),
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
