import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/models/Task.dart';
import 'package:propview/models/TaskCategory.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/taskCategoryService.dart';
import 'package:propview/services/taskServices.dart';
import 'package:propview/services/userService.dart';

import '../landingPage.dart';

// Approved/NotApproved/Completed/transferred

import '../../utils/progressBar.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key key}) : super(key: key);

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  List<DropdownMenuItem> _taskCategoryDropdownList = [];
  var _selectedTaskCategory;
  var _selectedPropertyOwner;
  var _selectedProperty;
  List<DropdownMenuItem> _userDropdownList = [];
  var _selectedUser;

  TextEditingController _taskDescription = new TextEditingController();
  TextEditingController _propertyOwner = new TextEditingController();
  TextEditingController _taskName = new TextEditingController();
  TextEditingController _taskStartDateTime =
      new TextEditingController(text: DateTime.now().toString());
  TextEditingController _taskEndDateTime =
      new TextEditingController(text: DateTime.now().toString());

  List<TaskCategory> taskCategories = [];
  List<User> users = [];
  PropertyOwner propertyOwner;
  // PropertyOwner propertyOwner;
  bool loading = false;
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    taskCategories = await TaskCategoryService.getTaskCategories();
    for (int i = 0; i < taskCategories.length; i++) {
      _taskCategoryDropdownList.add(
        DropdownMenuItem(
          child: Text(taskCategories[i].category),
          value: taskCategories[i].category,
        ),
      );
    }
    propertyOwner = await PropertyOwnerService.getAllPropertyOwner();
    // for (int i = 0; i < propertyOwner.data.propertyOwner.length; i++) {
    //   _propertyDropdownList.add(
    //     DropdownMenuItem(
    //       child: ListTile(
    //         title: Text(propertyOwner.data.propertyOwner[i].ownerName),
    //         // subtitle: Text(propertyOwner.data.propertyOwner[i].ownerAddress,overflow: TextOverflow.ellipsis,softWrap: true,),
    //         leading:
    //             Text(propertyOwner.data.propertyOwner[i].ownerId.toString()),
    //       ),
    //       value: propertyOwner.data.propertyOwner[i].ownerId,
    //     ),
    //   );
    // }
    users = await UserService.getAllUser();
    for (int i = 0; i < users.length; i++) {
      _userDropdownList.add(
        DropdownMenuItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                users[i].name,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                users[i].designation,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          value: users[i].userId,
        ),
      );
    }
    setState(() {
      _selectedTaskCategory = _taskCategoryDropdownList[0].value;
      // _selectedProperty = _propertyDropdownList[0].value;
      _selectedUser = _userDropdownList[0].value;
      loading = false;
    });
  }

  bool load = false;
  bool propertySelectBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  controller: this._propertyOwner,
                                ),
                                suggestionsCallback: (pattern) {
                                  List<PropertyOwnerElement> matches = [];
                                  matches
                                      .addAll(propertyOwner.data.propertyOwner);
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
                                onSuggestionSelected: (suggestion) {
                                  this._propertyOwner.text =
                                      suggestion.ownerName.toString();
                                  _selectedPropertyOwner = suggestion.ownerId;
                                  propertySelectBox = true;
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
                    SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Select Property of the Owner: ",
                        style: GoogleFonts.nunito(
                            color: Color(0xff314B8C),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // propertySelectBox
                    //     ? Align(
                    //         alignment: Alignment.topLeft,
                    //         child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 12, vertical: 4),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(12),
                    //             color: Color(0xff314B8C).withOpacity(0.12),
                    //           ),
                    //           child: TypeAheadFormField(
                    //             textFieldConfiguration: TextFieldConfiguration(
                    //               decoration: InputDecoration(
                    //                 border: InputBorder.none,
                    //               ),
                    //               controller: this._propertyOwner,
                    //             ),
                    //             suggestionsCallback: (pattern) {
                    //               List<PropertyOwnerElement> matches = [];
                    //               matches
                    //                   .addAll(propertyOwner.data.propertyOwner);
                    //               matches.retainWhere((s) => s.ownerName
                    //                   .toLowerCase()
                    //                   .contains(pattern.toLowerCase()));
                    //               return matches;
                    //             },
                    //             itemBuilder:
                    //                 (context, PropertyOwnerElement suggestion) {
                    //               return ListTile(
                    //                 title: Text(suggestion.ownerName),
                    //                 // subtitle: Text(propertyOwner.data.propertyOwner[i].ownerAddress,overflow: TextOverflow.ellipsis,softWrap: true,),
                    //                 leading:
                    //                     Text(suggestion.ownerId.toString()),
                    //               );
                    //             },
                    //             noItemsFoundBuilder: (context) {
                    //               return Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     vertical: 8.0),
                    //                 child: Align(
                    //                   alignment: Alignment.center,
                    //                   child: Text(
                    //                     'Type to find owners property!',
                    //                     style: TextStyle(
                    //                         color:
                    //                             Theme.of(context).disabledColor,
                    //                         fontSize: 18.0),
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //             transitionBuilder:
                    //                 (context, suggestionsBox, controller) {
                    //               return suggestionsBox;
                    //             },
                    //             onSuggestionSelected: (suggestion) {
                    //               this._propertyOwner.text = suggestion.ownerId;
                    //               propertySelectBox = true;
                    //             },
                    //             validator: (value) => value.isEmpty
                    //                 ? 'Please select a property'
                    //                 : null,
                    //             // onSaved: (value) => this.propertyOwner = value,
                    //           ),
                    //         ),
                    //       )
                    //     : Container(),
                    inputField("Enter Task Name", _taskName, 1),
                    inputField("Enter Task Description", _taskDescription, 5),
                    inputDateTime(
                        "Enter Start Date and Time", _taskStartDateTime),
                    inputDateTime("Enter End Date and Time", _taskEndDateTime),
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
                                      value: _selectedUser,
                                      isExpanded: true,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      icon: Icon(
                                        Icons.list_alt,
                                        color: Colors.black,
                                      ),
                                      items: _userDropdownList,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedUser = value;
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ),
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
                        padding: const EdgeInsets.all(8.0),
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
                          "task_status": "Approved",
                          "start_dateTime": _taskStartDateTime.text,
                          "end_dateTime": _taskEndDateTime.text,
                          "assigned_to": _selectedUser.toString(),
                          "property_ref": _selectedProperty.toString(),
                          "created_at": DateTime.now().toString(),
                          "updated_at": DateTime.now().toString(),
                        });
                        bool response = await TaskService.createTask(payload);
                        setState(() {
                          load = false;
                        });
                        if (response) {
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

  inputDateTime(label, controller) {
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
                          controller.text = date.toString();
                        });
                      },
                      onConfirm: (date) {
                        setState(() {
                          controller.text = date.toString();
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
