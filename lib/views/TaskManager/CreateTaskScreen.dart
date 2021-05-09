import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTasKScreen extends StatefulWidget {
  const CreateTasKScreen({Key key}) : super(key: key);

  @override
  _CreateTasKScreenState createState() => _CreateTasKScreenState();
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class _CreateTasKScreenState extends State<CreateTasKScreen> {
  List<ListItem> _dropdownItems = [
    ListItem(1, "First Value"),
    ListItem(2, "Second Item"),
    ListItem(3, "Third Item"),
    ListItem(4, "Fourth Item")
  ];

  List<DropdownMenuItem> _dropdownMenuItems;
  ListItem _selectedItem;

  TextEditingController _taskDescription = new TextEditingController();
  TextEditingController _taskName = new TextEditingController();
  TextEditingController _taskStartDateTime =
      new TextEditingController(text: DateTime.now().toString());
  TextEditingController _taskEndDateTime =
      new TextEditingController(text: DateTime.now().toString());

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }
  
  void initState() {
    getData();
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value;
  }

  getData(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                inputDropDown("Select Category of Task: ", _selectedItem,
                    _dropdownMenuItems),
                inputDropDown(
                    "Select Property: ", _selectedItem, _dropdownMenuItems),
                inputField("Enter Task Name", _taskName, 1),
                inputField("Enter Task Description", _taskDescription, 5),
                inputDateTime("Enter Start Date and Time", _taskStartDateTime),
                inputDateTime("Enter End Date and Time", _taskEndDateTime),
                inputDropDown(
                    "Select Employee: ", _selectedItem, _dropdownMenuItems),
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

  inputDropDown(label, selectedItem, dropdownMenuItems) {
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
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xff314B8C).withOpacity(0.12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ListItem>(
                    value: selectedItem,
                    isExpanded: true,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    icon: Icon(
                      Icons.list_alt,
                      color: Colors.black,
                    ),
                    items: dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        selectedItem = value;
                      });
                    }),
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
