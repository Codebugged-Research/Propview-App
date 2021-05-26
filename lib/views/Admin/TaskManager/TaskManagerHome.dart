import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskServices.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
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
  bool loading = false;
  Task taskData;
  List<TaskElement> pendingTaskList = [];
  List<TaskElement> completedTaskList = [];
  List<TaskElement> unApprovedTaskList = [];

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    taskData = await TaskService.getAllTask();
    for (int i = 0; i < taskData.data.task.length; i++) {
      if (taskData.data.task[i].taskStatus == "Approved") {
        pendingTaskList.add(taskData.data.task[i]);
      } else if (taskData.data.task[i].taskStatus == "Completed") {
        completedTaskList.add(taskData.data.task[i]);
      } else if (taskData.data.task[i].taskStatus == "Unapproved") {
        unApprovedTaskList.add(taskData.data.task[i]);
      }
    }
    setState(() {
      loading = false;
    });
  }

  TabController _tabController;
  int _index = 0;

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
                        "Admin/Super_Admin",
                        style: GoogleFonts.nunito(
                          color: Color(0xffB2B2B2),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: InkWell(
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
                              Tab(text: "Pending"),
                              Tab(text: "Completed"),
                              Tab(text: "UnApproved"),
                            ],
                            onTap: (value) {
                              setState(() {
                                _index = value;
                              });
                              _tabController.animateTo(value,
                                  curve: Curves.easeIn,
                                  duration: Duration(milliseconds: 600));
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
                                          fontWeight: FontWeight.bold),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(top: 0),
                                itemCount: pendingTaskList.length,
                                itemBuilder: (context, index) {
                                  return TaskCard(
                                      taskElement: pendingTaskList[index]);
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
                                          fontWeight: FontWeight.bold),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(top: 0),
                                itemCount: completedTaskList.length,
                                itemBuilder: (context, index) {
                                  return TaskCard(
                                      taskElement: completedTaskList[index]);
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
                                          fontWeight: FontWeight.bold),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(top: 0),
                                itemCount: completedTaskList.length,
                                itemBuilder: (context, index) {
                                  return TaskCard(
                                      taskElement: unApprovedTaskList[index]);
                                },
                              ),
                      ],
                    )),
                    flex: 9,
                  ),
                ],
              ),
            ),
    );
  }
}
