import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/config.dart';

import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/TaskManager/CalenderScreen.dart';
import 'package:propview/views/Admin/TaskManager/createTaskScreen.dart';
import 'package:propview/views/Admin/widgets/taskCard.dart';

class TaskMangerHome extends StatefulWidget {
  @override
  _TaskMangerHomeState createState() => _TaskMangerHomeState();
}

class _TaskMangerHomeState extends State<TaskMangerHome>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getData();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  User user;
  List<User> userList;
  bool loading = false;
  Task taskData;
  List<TaskElement> pendingTaskList = [];
  List<TaskElement> completedTaskList = [];
  List<TaskElement> unApprovedTaskList = [];
  List<TaskElement> pendingTaskList2 = [];
  List<TaskElement> completedTaskList2 = [];
  List<TaskElement> unApprovedTaskList2 = [];
  List<TaskElement> pendingTaskList3 = [];
  List<TaskElement> completedTaskList3 = [];
  List<TaskElement> unApprovedTaskList3 = [];
  User tempUser;
  getData() async {
    pendingTaskList.clear();
    completedTaskList.clear();
    unApprovedTaskList.clear();
    pendingTaskList2.clear();
    completedTaskList2.clear();
    unApprovedTaskList2.clear();
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    userList = await UserService.getAllUser();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController21 = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController22 = TabController(length: 3, vsync: this, initialIndex: 0);
    taskData = await TaskService.getAllTask();
    for (int i = 0; i < taskData.data.task.length; i++) {
      if (taskData.data.task[i].taskStatus == "Pending") {
        if (taskData.data.task[i].assignedTo == user.userId.toString()) {
          pendingTaskList.add(taskData.data.task[i]);
        } else {
          pendingTaskList2.add(taskData.data.task[i]);
        }
      } else if (taskData.data.task[i].taskStatus == "Completed") {
        if (taskData.data.task[i].assignedTo == user.userId.toString()) {
          completedTaskList.add(taskData.data.task[i]);
        } else {
          completedTaskList2.add(taskData.data.task[i]);
        }
      } else if (taskData.data.task[i].taskStatus == "Unapproved") {
        if (taskData.data.task[i].assignedTo == user.userId.toString()) {
          unApprovedTaskList.add(taskData.data.task[i]);
        } else {
          unApprovedTaskList2.add(taskData.data.task[i]);
        }
      }
    }
    setState(() {
      tempUser = user;
      loading = false;
    });
  }

  bool serachLoading = false;

  TabController _tabController;
  TabController _tabController21;
  TabController _tabController22;

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateTaskScreen(
                    user: user,
                  )));
        },
      ),
      body: loading
          ? circularProgressWidget()
          : Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: ClipOval(
                          child: FadeInImage.assetNetwork(
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            placeholder: "assets/loader.gif",
                            image:
                                "${Config.STORAGE_ENDPOINT}${user.userId}.jpeg",
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
                      ),
                      title: Text(
                        user.name,
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Admin",
                        style: GoogleFonts.nunito(
                          color: Color(0xffB2B2B2),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              getData();
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
                                Icons.refresh,
                                color: Color(0xff314B8C),
                                size: 24,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CalenderScreen(
                                        taskList: pendingTaskList,
                                      )));
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
                                Icons.calendar_today_outlined,
                                color: Color(0xff314B8C),
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
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
                            Tab(text: "Self"),
                            Tab(text: "Team"),
                          ],
                          onTap: (value) {
                            _tabController.animateTo(
                              value,
                              curve: Curves.easeIn,
                              duration: Duration(milliseconds: 600),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          Column(
                            children: [
                              TabBar(
                                isScrollable: true,
                                controller: _tabController21,
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
                                unselectedLabelColor:
                                    Colors.black.withOpacity(0.4),
                                labelColor: Color(0xff314B8C),
                                tabs: [
                                  Tab(text: "Pending"),
                                  Tab(text: "UnApproved"),
                                  Tab(text: "Completed"),
                                ],
                                onTap: (value) {
                                  _tabController21.animateTo(
                                    value,
                                    curve: Curves.easeIn,
                                    duration: Duration(milliseconds: 600),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Expanded(
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _tabController21,
                                  children: <Widget>[
                                    pendingTaskList.length == 0
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
                                            padding: EdgeInsets.only(top: 0),
                                            itemCount: pendingTaskList.length,
                                            itemBuilder: (context, index) {
                                              return TaskCard(
                                                taskElement:
                                                    pendingTaskList[index],
                                                currentUser: user,
                                                isSelf: true,
                                                change:
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
                                          ),
                                    unApprovedTaskList.length == 0
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
                                            padding: EdgeInsets.only(top: 0),
                                            itemCount:
                                                unApprovedTaskList.length,
                                            itemBuilder: (context, index) {
                                              return TaskCard(
                                                taskElement:
                                                    unApprovedTaskList[index],
                                                currentUser: user,
                                                isSelf: true,
                                                change:
                                                    (TaskElement taskElement) {
                                                  setState(() {
                                                    unApprovedTaskList
                                                        .removeWhere(
                                                            (element) =>
                                                                element
                                                                    .taskId ==
                                                                taskElement
                                                                    .taskId);
                                                    completedTaskList
                                                        .add(taskElement);
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                    completedTaskList.length == 0
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
                                            padding: EdgeInsets.only(top: 0),
                                            itemCount: completedTaskList.length,
                                            itemBuilder: (context, index) {
                                              return TaskCard(
                                                taskElement:
                                                    completedTaskList[index],
                                                currentUser: user,
                                                isSelf: true,
                                                change: (TaskElement
                                                    taskElement) {},
                                              );
                                            },
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16, top: 8),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                75,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Color(0xff314B8C)
                                              .withOpacity(0.12),
                                        ),
                                        child: TypeAheadFormField(
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
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
                                                .contains(
                                                    pattern.toLowerCase()));
                                            return matches;
                                          },
                                          itemBuilder:
                                              (context, User suggestion) {
                                            return ListTile(
                                              title: Text(suggestion.name),
                                              subtitle: Text(
                                                  suggestion.officialEmail),
                                            );
                                          },
                                          noItemsFoundBuilder: (context) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Type to find User !',
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
                                          onSuggestionSelected:
                                              (suggestion) async {
                                            setState(() {
                                              serachLoading = true;
                                            });
                                            Task userTask = await TaskService
                                                .getAllTaskByUserId(
                                                    suggestion.userId);
                                            print(userTask.count);
                                            if (userTask.count == 0) {
                                              showInSnackBar(
                                                  context,
                                                  "No task found in database !",
                                                  2500);
                                            } else {
                                              pendingTaskList3.clear();
                                              unApprovedTaskList3.clear();
                                              completedTaskList3.clear();
                                              for (int i = 0;
                                                  i < userTask.data.task.length;
                                                  i++) {
                                                if (userTask.data.task[i]
                                                        .taskStatus ==
                                                    "Pending") {
                                                  pendingTaskList3.add(
                                                      userTask.data.task[i]);
                                                } else if (userTask.data.task[i]
                                                        .taskStatus ==
                                                    "Completed") {
                                                  completedTaskList3.add(
                                                      userTask.data.task[i]);
                                                } else if (userTask.data.task[i]
                                                        .taskStatus ==
                                                    "Unapproved") {
                                                  unApprovedTaskList3.add(
                                                      userTask.data.task[i]);
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
                                      });
                                    },
                                  ),
                                ],
                              ),
                              serachLoading
                                  ? circularProgressWidget()
                                  : TabBar(
                                      isScrollable: true,
                                      controller: _tabController22,
                                      indicator: UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                            color: Color(0xff314B8C),
                                            width: 4.0),
                                      ),
                                      labelStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff314B8C),
                                      ),
                                      unselectedLabelStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      unselectedLabelColor:
                                          Colors.black.withOpacity(0.4),
                                      labelColor: Color(0xff314B8C),
                                      tabs: [
                                        Tab(text: "Pending"),
                                        Tab(text: "UnApproved"),
                                        Tab(text: "Completed"),
                                      ],
                                      onTap: (value) {
                                        _tabController22.animateTo(
                                          value,
                                          curve: Curves.easeIn,
                                          duration: Duration(milliseconds: 600),
                                        );
                                      },
                                    ),
                              Expanded(
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _tabController22,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Expanded(
                                          child: tempUser.userId == user.userId
                                              ? pendingTaskList2.length == 0
                                                  ? Center(
                                                      child: Text(
                                                        'No Task!',
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .subtitle1
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff314B8C),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          pendingTaskList2
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return TaskCard(
                                                          taskElement:
                                                              pendingTaskList2[
                                                                  index],
                                                          currentUser: user,
                                                          isSelf: false,
                                                        );
                                                      },
                                                    )
                                              : pendingTaskList3.length == 0
                                                  ? Center(
                                                      child: Text(
                                                        'No Task!',
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .subtitle1
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff314B8C),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          pendingTaskList3
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return TaskCard(
                                                          taskElement:
                                                              pendingTaskList3[
                                                                  index],
                                                          currentUser: user,
                                                          isSelf: false,
                                                        );
                                                      },
                                                    ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Expanded(
                                          child: tempUser.userId == user.userId
                                              ? unApprovedTaskList2.length == 0
                                                  ? Center(
                                                      child: Text(
                                                        'No Task!',
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .subtitle1
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff314B8C),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          unApprovedTaskList2
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return TaskCard(
                                                          taskElement:
                                                              unApprovedTaskList2[
                                                                  index],
                                                          currentUser: user,
                                                          isSelf: false,
                                                        );
                                                      },
                                                    )
                                              : unApprovedTaskList3.length == 0
                                                  ? Center(
                                                      child: Text(
                                                        'No Task!',
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .subtitle1
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff314B8C),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          unApprovedTaskList3
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return TaskCard(
                                                          taskElement:
                                                              unApprovedTaskList3[
                                                                  index],
                                                          currentUser: user,
                                                          isSelf: false,
                                                        );
                                                      },
                                                    ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Expanded(
                                          child: tempUser.userId == user.userId
                                              ? completedTaskList2.length == 0
                                                  ? Center(
                                                      child: Text(
                                                        'No Task!',
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .subtitle1
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff314B8C),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          completedTaskList2
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return TaskCard(
                                                          taskElement:
                                                              completedTaskList2[
                                                                  index],
                                                          currentUser: user,
                                                          isSelf: false,
                                                        );
                                                      },
                                                    )
                                              : completedTaskList3.length == 0
                                                  ? Center(
                                                      child: Text(
                                                        'No Task!',
                                                        style: Theme.of(context)
                                                            .primaryTextTheme
                                                            .subtitle1
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff314B8C),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          completedTaskList3
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return TaskCard(
                                                          taskElement:
                                                              completedTaskList3[
                                                                  index],
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
                        ],
                      ),
                    ),
                    flex: 10,
                  ),
                ],
              ),
            ),
    );
  }
}
