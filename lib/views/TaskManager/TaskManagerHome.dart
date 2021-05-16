import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskServices.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Notification/notificationScreen.dart';
import 'package:propview/views/TaskManager/createTaskScreen.dart';
import 'package:propview/widgets/taskCard.dart';

import 'TaskDetailScreen.dart';

class TaskMangerHome extends StatefulWidget {
  @override
  _TaskMangerHomeState createState() => _TaskMangerHomeState();
}

class _TaskMangerHomeState extends State<TaskMangerHome>
    with TickerProviderStateMixin {
  @override
  void initState() {
    getData();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  User user;
  bool loading = false;
  Task taskData;
  List pendingTaskList = [];
  List completedTaskList = [];

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    taskData = await TaskService.getAllTask();
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    String token = await messaging.getToken();
    print(token);
    for (int i = 0; i < taskData.data.task.length; i++) {
      if (taskData.data.task[i].taskStatus == "Approved") {
        pendingTaskList.add(taskData.data.task[i]);
      } else if (taskData.data.task[i].taskStatus == "Completed") {
        completedTaskList.add(taskData.data.task[i]);
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
                    padding: const EdgeInsets.fromLTRB(12, 48, 12, 12),
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
                        user.userType,
                        style: GoogleFonts.nunito(
                          color: Color(0xffB2B2B2),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NotificationScreen()));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
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
                            Icons.notifications_none_outlined,
                            color: Color(0xff314B8C),
                            size: 32,
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
                              Tab(
                                text: "Pending",
                              ),
                              Tab(
                                text: "Completed",
                              ),
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
                          ListView.builder(
                            itemCount: pendingTaskList.length,
                            itemBuilder: (context, index) {
                              return TaskCard(
                                  taskElement: pendingTaskList[index]);
                            },
                          ),
                          ListView.builder(
                            itemCount: completedTaskList.length,
                            itemBuilder: (context, index) {
                              return TaskCard(
                                  taskElement: completedTaskList[index]);
                            },
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
