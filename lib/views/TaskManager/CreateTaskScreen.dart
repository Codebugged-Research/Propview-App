import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/models/TaskCategory.dart';
import 'package:propview/services/propertyService.dart';
import 'package:propview/services/taskCategoryService.dart';

class CreateTasKScreen extends StatefulWidget {
  const CreateTasKScreen({Key key}) : super(key: key);

  @override
  _CreateTasKScreenState createState() => _CreateTasKScreenState();
}

class _CreateTasKScreenState extends State<CreateTasKScreen> {
  List<DropdownMenuItem> _taskCategoryDropdownList = [];
  var _selectedTaskCategory;
  List<DropdownMenuItem> _propertyDropdownList = [];
  var _selectedProperty;

  TextEditingController _taskDescription = new TextEditingController();
  TextEditingController _taskName = new TextEditingController();
  TextEditingController _taskStartDateTime =
      new TextEditingController(text: DateTime.now().toString());
  TextEditingController _taskEndDateTime =
      new TextEditingController(text: DateTime.now().toString());

  List<TaskCategory> taskCategories = [];
  PropertyOwner propertyOwner;
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
          value: taskCategories[i].taskCategoryId,
        ),
      );
    }
    propertyOwner = await PropertyService.getAllProperties();
    for (int i = 0; i < propertyOwner.data.propertyOwner.length; i++) {
      _propertyDropdownList.add(
        DropdownMenuItem(
          child: ListTile(
            title: Text(propertyOwner.data.propertyOwner[i].ownerName),
            // subtitle: Text(propertyOwner.data.propertyOwner[i].ownerAddress,overflow: TextOverflow.ellipsis,softWrap: true,),
            leading:
                Text(propertyOwner.data.propertyOwner[i].ownerId.toString()),
          ),
          value: propertyOwner.data.propertyOwner[i].ownerId,
        ),
      );
    }
    setState(() {
      _selectedTaskCategory = _taskCategoryDropdownList[0].value;
      _selectedProperty = _propertyDropdownList[0].value;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, bottom: 24.0, top: 16),
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
                                "Select Property: ",
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
                                  child: DropdownButton(
                                      value: _selectedProperty,
                                      isExpanded: true,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      icon: Icon(
                                        Icons.list_alt,
                                        color: Colors.black,
                                      ),
                                      items: _propertyDropdownList,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedProperty = value;
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      inputField("Enter Task Name", _taskName, 1),
                      inputField("Enter Task Description", _taskDescription, 5),
                      inputDateTime(
                          "Enter Start Date and Time", _taskStartDateTime),
                      inputDateTime(
                          "Enter End Date and Time", _taskEndDateTime),
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
                          child: Text(
                            "Create Task",
                            style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
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
