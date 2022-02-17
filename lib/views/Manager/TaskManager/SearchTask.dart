import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Manager/widgets/taskCard.dart';

// ignore: must_be_immutable
class SearchTask extends StatefulWidget {
  int index;
  SearchTask({this.index});
  @override
  _SearchTaskState createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getData();
  }

  TextEditingController _searchController = TextEditingController();
  List<TaskElement> pendingTaskList = [];
  List<TaskElement> completedTaskList = [];
  List<TaskElement> unApprovedTaskList = [];
  List<TaskElement> pendingTaskList2 = [];
  List<TaskElement> completedTaskList2 = [];
  List<TaskElement> unApprovedTaskList2 = [];
  String start = "";
  String end = "";
  List<User> userList;
  User user;
  User tempUser;
  bool serachLoading = false;
  bool loading = false;
  TabController _tabController;

  getData() async {
    pendingTaskList.clear();
    completedTaskList.clear();
    unApprovedTaskList.clear();
    setState(() {
      loading = true;
    });
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.index = widget.index;
    user = await UserService.getUser();
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
    userList.add(user);
    print(userList.length);
    setState(() {
      loading = false;
    });
  }

  dateFormatter(String dat) {
    DateTime date = DateTime.parse(dat);
    return '${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${DateTime.now().year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: loading
          ? Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xff314B8C)),
              ),
            )
          : Container(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 75,
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
                                controller: this._searchController,
                              ),
                              suggestionsCallback: (pattern) {
                                List<User> matches = [];
                                matches.addAll(userList);
                                matches.retainWhere((s) => s.name
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase()));
                                return matches;
                              },
                              itemBuilder: (context, User suggestion) {
                                return ListTile(
                                  title: Text(suggestion.name),
                                  subtitle: Text(suggestion.officialEmail),
                                );
                              },
                              noItemsFoundBuilder: (context) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Type to find User !',
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
                                setState(() {
                                  serachLoading = true;
                                  _searchController.text = suggestion.name;
                                });
                                Task userTask =
                                    await TaskService.getAllTaskByUserId(
                                        suggestion.userId);
                                if (userTask.count == 0) {
                                  showInSnackBar(context,
                                      "No task found in database !", 2500);
                                } else {
                                  pendingTaskList.clear();
                                  unApprovedTaskList.clear();
                                  completedTaskList.clear();
                                  for (int i = 0;
                                      i < userTask.data.task.length;
                                      i++) {
                                    if (userTask.data.task[i].taskStatus ==
                                            "Pending" ||
                                        userTask.data.task[i].taskStatus ==
                                            "Rejected") {
                                      pendingTaskList
                                          .add(userTask.data.task[i]);
                                    } else if (userTask
                                            .data.task[i].taskStatus ==
                                        "Completed") {
                                      completedTaskList
                                          .add(userTask.data.task[i]);
                                    } else if (userTask
                                            .data.task[i].taskStatus ==
                                        "Unapproved") {
                                      unApprovedTaskList
                                          .add(userTask.data.task[i]);
                                    }
                                  }
                                  showInSnackBar(
                                      context,
                                      "${userTask.count} task found in database !",
                                      2500);
                                  setState(() {
                                    tempUser = suggestion;
                                  });
                                }
                                setState(() {
                                  serachLoading = false;
                                });
                              },
                              validator: (value) => value.isEmpty
                                  ? 'Please select an Owner Name'
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        child: Icon(Icons.clear),
                        onTap: () {
                          setState(() {
                            tempUser = user;
                            _searchController.clear();
                            pendingTaskList.clear();
                            completedTaskList.clear();
                            unApprovedTaskList.clear();
                            pendingTaskList2.clear();
                            completedTaskList2.clear();
                            unApprovedTaskList2.clear();
                            start = "";
                            end = "";
                          });
                        },
                      ),
                    ],
                  ),
                  if (pendingTaskList.length > 0 ||
                      completedTaskList.length > 0 ||
                      unApprovedTaskList.length > 0)
                    serachLoading
                        ? circularProgressWidget()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: start == ""
                                        ? DateTime.now()
                                        : DateTime.parse(start),
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2055),
                                  );
                                  if (start == "") {
                                    setState(() {
                                      start = picked.toString();
                                      end = DateTime.now().toString();
                                    });
                                  } else if (picked != null &&
                                      picked != DateTime.parse(start))
                                    setState(() {
                                      start = picked.toString();
                                    });

                                  print(start);
                                  print(end);
                                  pendingTaskList2.clear();
                                  completedTaskList2.clear();
                                  unApprovedTaskList2.clear();
                                  pendingTaskList2 = pendingTaskList
                                      .where(
                                        (element) =>
                                            element.createdAt.isAfter(
                                              DateTime.parse(start),
                                            ) &&
                                            element.createdAt.isBefore(
                                              DateTime.parse(end),
                                            ),
                                      )
                                      .toList();
                                  completedTaskList2 = completedTaskList
                                      .where(
                                        (element) =>
                                            element.createdAt.isAfter(
                                              DateTime.parse(start),
                                            ) &&
                                            element.createdAt.isBefore(
                                              DateTime.parse(end),
                                            ),
                                      )
                                      .toList();
                                  unApprovedTaskList2 = unApprovedTaskList
                                      .where(
                                        (element) =>
                                            element.createdAt.isAfter(
                                              DateTime.parse(start),
                                            ) &&
                                            element.createdAt.isBefore(
                                              DateTime.parse(end),
                                            ),
                                      )
                                      .toList();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today),
                                    Text(
                                      start == ""
                                          ? "Starting"
                                          : dateFormatter(
                                              start,
                                            ),
                                    )
                                  ],
                                ),
                              ),
                              Text("To"),
                              MaterialButton(
                                onPressed: () async {
                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: end == ""
                                        ? DateTime.now()
                                        : DateTime.parse(end),
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2055),
                                  );
                                  if (end == "") {
                                    setState(() {
                                      end = picked.toString();
                                    });
                                  } else if (picked != null &&
                                      picked != DateTime.parse(end)) {
                                    setState(() {
                                      end = picked.toString();
                                    });
                                  }

                                  pendingTaskList2.clear();
                                  completedTaskList2.clear();
                                  unApprovedTaskList2.clear();
                                  print(start);
                                  print(end);
                                  pendingTaskList2 = pendingTaskList
                                      .where(
                                        (element) =>
                                            element.createdAt.isAfter(
                                              DateTime.parse(start),
                                            ) &&
                                            element.createdAt.isBefore(
                                              DateTime.parse(end),
                                            ),
                                      )
                                      .toList();
                                  completedTaskList2 = completedTaskList
                                      .where(
                                        (element) =>
                                            element.createdAt.isAfter(
                                              DateTime.parse(start),
                                            ) &&
                                            element.createdAt.isBefore(
                                              DateTime.parse(end),
                                            ),
                                      )
                                      .toList();
                                  unApprovedTaskList2 = unApprovedTaskList
                                      .where(
                                        (element) =>
                                            element.createdAt.isAfter(
                                              DateTime.parse(start),
                                            ) &&
                                            element.createdAt.isBefore(
                                              DateTime.parse(end),
                                            ),
                                      )
                                      .toList();
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today),
                                    Text(
                                      end == ""
                                          ? "Till Date"
                                          : dateFormatter(
                                              end,
                                            ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                  serachLoading
                      ? circularProgressWidget()
                      : TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                                color: Color(0xff314B8C), width: 4.0),
                          ),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff314B8C),
                          ),
                          unselectedLabelStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          unselectedLabelColor: Colors.black.withOpacity(0.4),
                          labelColor: Color(0xff314B8C),
                          tabs: [
                            Tab(text: "Pending"),
                            Tab(text: "UnApproved"),
                            Tab(text: "Completed"),
                          ],
                          onTap: (value) {
                            _tabController.animateTo(
                              value,
                              curve: Curves.easeIn,
                              duration: Duration(milliseconds: 600),
                            );
                          },
                        ),
                  Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: <Widget>[
                        //team pending
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              child: end == ""
                                  ? pendingTaskList.length == 0
                                      ? Center(
                                          child: Text(
                                            'No Task!',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: Color(0xff314B8C),
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: pendingTaskList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            pendingTaskList.sort((a, b) => b
                                                .updatedAt
                                                .compareTo(a.updatedAt));
                                            return TaskCard(
                                              taskElement:
                                                  pendingTaskList[index],
                                              currentUser: user,
                                              isSelf: false,
                                              change1:
                                                  (TaskElement taskElement) {
                                                setState(() {
                                                  pendingTaskList.removeWhere(
                                                      (element) =>
                                                          element.taskId ==
                                                          taskElement.taskId);
                                                  unApprovedTaskList
                                                      .add(taskElement);
                                                });
                                              },
                                            );
                                          },
                                        )
                                  : pendingTaskList2.length == 0
                                      ? Center(
                                          child: Text(
                                            'No Task!',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: Color(0xff314B8C),
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: pendingTaskList2.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            pendingTaskList.sort((a, b) => b
                                                .updatedAt
                                                .compareTo(a.updatedAt));
                                            return TaskCard(
                                              taskElement:
                                                  pendingTaskList2[index],
                                              currentUser: user,
                                              isSelf: false,
                                              change1:
                                                  (TaskElement taskElement) {
                                                setState(() {
                                                  pendingTaskList2.removeWhere(
                                                      (element) =>
                                                          element.taskId ==
                                                          taskElement.taskId);
                                                  unApprovedTaskList2
                                                      .add(taskElement);
                                                });
                                              },
                                            );
                                          },
                                        ),
                            )
                          ],
                        ),
                        //team unaprroved
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              child: end == ""
                                  ? unApprovedTaskList.length == 0
                                      ? Center(
                                          child: Text(
                                            'No Task!',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: Color(0xff314B8C),
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: unApprovedTaskList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            unApprovedTaskList.sort((a, b) => b
                                                .updatedAt
                                                .compareTo(a.updatedAt));
                                            return TaskCard(
                                              taskElement:
                                                  unApprovedTaskList[index],
                                              currentUser: user,
                                              isSelf: false,
                                              change1:
                                                  (TaskElement taskElement) {
                                                setState(() {
                                                  unApprovedTaskList
                                                      .removeWhere((element) =>
                                                          element.taskId ==
                                                          taskElement.taskId);
                                                  completedTaskList
                                                      .add(taskElement);
                                                });
                                              },
                                              change2:
                                                  (TaskElement taskElement) {
                                                setState(() {
                                                  unApprovedTaskList
                                                      .removeWhere((element) =>
                                                          element.taskId ==
                                                          taskElement.taskId);
                                                  pendingTaskList
                                                      .add(taskElement);
                                                });
                                              },
                                            );
                                          },
                                        )
                                  : unApprovedTaskList2.length == 0
                                      ? Center(
                                          child: Text(
                                            'No Task!',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .subtitle1
                                                .copyWith(
                                                    color: Color(0xff314B8C),
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: unApprovedTaskList2.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            unApprovedTaskList2.sort((a, b) => b
                                                .updatedAt
                                                .compareTo(a.updatedAt));
                                            return TaskCard(
                                              taskElement:
                                                  unApprovedTaskList2[index],
                                              currentUser: user,
                                              isSelf: false,
                                              change1:
                                                  (TaskElement taskElement) {
                                                setState(() {
                                                  unApprovedTaskList2
                                                      .removeWhere((element) =>
                                                          element.taskId ==
                                                          taskElement.taskId);
                                                  completedTaskList2
                                                      .add(taskElement);
                                                });
                                              },
                                              change2:
                                                  (TaskElement taskElement) {
                                                setState(() {
                                                  unApprovedTaskList2
                                                      .removeWhere((element) =>
                                                          element.taskId ==
                                                          taskElement.taskId);
                                                  pendingTaskList2
                                                      .add(taskElement);
                                                });
                                              },
                                            );
                                          },
                                        ),
                            )
                          ],
                        ),
                        //team completed
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              child: end == ""
                                  ? completedTaskList.length == 0
                                      ? Center(
                                          child: Text(
                                            'No Task!',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .subtitle1
                                                .copyWith(
                                                  color: Color(0xff314B8C),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: completedTaskList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            completedTaskList.sort((a, b) => b
                                                .updatedAt
                                                .compareTo(a.updatedAt));
                                            return TaskCard(
                                              taskElement:
                                                  completedTaskList[index],
                                              currentUser: user,
                                              isSelf: false,
                                            );
                                          },
                                        )
                                  : completedTaskList2.length == 0
                                      ? Center(
                                          child: Text(
                                            'No Task!',
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .subtitle1
                                                .copyWith(
                                                  color: Color(0xff314B8C),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.all(8.0),
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: completedTaskList2.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            completedTaskList2.sort((a, b) => b
                                                .updatedAt
                                                .compareTo(a.updatedAt));
                                            return TaskCard(
                                              taskElement:
                                                  completedTaskList2[index],
                                              currentUser: user,
                                              isSelf: false,
                                            );
                                          },
                                        ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
