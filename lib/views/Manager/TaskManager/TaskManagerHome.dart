import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskServices.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Manager/TaskManager/CalenderScreen.dart';
import 'package:propview/views/Manager/TaskManager/createTaskScreen.dart';
import 'package:propview/views/Manager/widgets/taskCard.dart';

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
  bool loading = false;
  Task taskData;
  List<TaskElement> pendingTaskList = [];
  List<TaskElement> completedTaskList = [];
  List<TaskElement> unApprovedTaskList = [];
  List<TaskElement> pendingTaskList2 = [];
  List<TaskElement> completedTaskList2 = [];
  List<TaskElement> unApprovedTaskList2 = [];

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
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController21 = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController22 = TabController(length: 3, vsync: this, initialIndex: 0);
    var taskData1 = await TaskService.getAllTaskByUserId(user.userId);
    var taskData12 = await TaskService.getAllTaskByManagerId(user.userId);
    List<TaskElement> taskList = [];
    taskList.addAll(taskData1.data.task);
    taskList.addAll(taskData12.data.task);
    for (int i = 0; i < taskList.length; i++) {
      if (taskList[i].taskStatus == "Pending") {
        if (taskList[i].assignedTo == user.userId.toString()) {
          pendingTaskList.add(taskList[i]);
        } else {
          pendingTaskList2.add(taskList[i]);
        }
      } else if (taskList[i].taskStatus == "Completed") {
        if (taskList[i].assignedTo == user.userId.toString()) {
          completedTaskList.add(taskList[i]);
        } else {
          completedTaskList2.add(taskList[i]);
        }
      } else if (taskList[i].taskStatus == "Unapproved") {
        if (taskList[i].assignedTo == user.userId.toString()) {
          unApprovedTaskList.add(taskList[i]);
        } else {
          unApprovedTaskList2.add(taskList[i]);
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  TabController _tabController;
  TabController _tabController21;
  TabController _tabController22;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CreateTaskScreen()));
        },
      ),
      body: loading
          ? circularProgressWidget()
          : Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 64, 12, 12),
                    child: ListTile(
                      leading: Image.asset("assets/dummy.png"),
                      title: Text(
                        user.name,
                        style: GoogleFonts.nunito(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Manager",
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
                  Expanded(
                    child: Container(
                      child: Column(
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
                    flex: 1,
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
                              TabBar(
                                isScrollable: true,
                                controller: _tabController22,
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
                                    pendingTaskList2.length == 0
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
                                            itemCount: pendingTaskList2.length,
                                            itemBuilder: (context, index) {
                                              return TaskCard(
                                                taskElement:
                                                    pendingTaskList2[index],
                                                currentUser: user,
                                              );
                                            },
                                          ),
                                    unApprovedTaskList2.length == 0
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
                                                unApprovedTaskList2.length,
                                            itemBuilder: (context, index) {
                                              return TaskCard(
                                                taskElement:
                                                    unApprovedTaskList2[index],
                                                currentUser: user,
                                              );
                                            },
                                          ),
                                    completedTaskList2.length == 0
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
                                                completedTaskList2.length,
                                            itemBuilder: (context, index) {
                                              return TaskCard(
                                                taskElement:
                                                    completedTaskList2[index],
                                                currentUser: user,
                                              );
                                            },
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    flex: 9,
                  ),
                ],
              ),
            ),
    );
  }
}
