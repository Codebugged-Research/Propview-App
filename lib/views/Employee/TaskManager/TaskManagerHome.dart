import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:propview/config.dart';

import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Admin/TaskManager/SoloCalendar.dart';
import 'package:propview/views/Employee/Profile/ProfileScreen.dart';
import 'package:propview/views/Employee/TaskManager/CreateTaskScreen.dart';
import 'package:propview/views/Employee/widgets/taskCard.dart';

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
      pendingTaskList.clear();
      completedTaskList.clear();
      unApprovedTaskList.clear();
      loading = true;
    });
    user = await UserService.getUser();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    pendingTaskList =
        await TaskService.getAllSelfTaskByIdAndType(user.userId, "Pending");
    List<TaskElement> tempList =
        await TaskService.getAllSelfTaskByIdAndType(user.userId, "Rejected");
    pendingTaskList.addAll(tempList);
    unApprovedTaskList =
        await TaskService.getAllSelfTaskByIdAndType(user.userId, "Unapproved");
    completedTaskList =
        await TaskService.getAllSelfTaskByIdAndType(user.userId, "Completed");
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateTaskScreen(user: user)));
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
                      leading: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
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
                      ),
                      title: Text(
                        user.name,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline5
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Employee",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle2
                            .copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SoloCalendar(
                                    user: user,
                                  ),
                                ),
                              );
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
                              Tab(text: "Pending"),
                              Tab(text: "UnApproved"),
                              Tab(text: "Completed"),
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
                                      taskElement: pendingTaskList[index],
                                      currentUser: user,
                                      isSelf: true,
                                      change: (TaskElement taskElement) {
                                        setState(() {
                                          pendingTaskList.removeWhere(
                                              (element) =>
                                                  element.taskId ==
                                                  taskElement.taskId);
                                          unApprovedTaskList.add(taskElement);
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
                                            fontWeight: FontWeight.bold),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.only(top: 0),
                                  itemCount: unApprovedTaskList.length,
                                  itemBuilder: (context, index) {
                                    return TaskCard(
                                      taskElement: unApprovedTaskList[index],
                                      currentUser: user,
                                      isSelf: true,
                                      change: (TaskElement taskElement) {
                                        setState(() {
                                          unApprovedTaskList.removeWhere(
                                              (element) =>
                                                  element.taskId ==
                                                  taskElement.taskId);
                                          completedTaskList.add(taskElement);
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
                                            fontWeight: FontWeight.bold),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.only(top: 0),
                                  itemCount: completedTaskList.length,
                                  itemBuilder: (context, index) {
                                    return TaskCard(
                                      taskElement: completedTaskList[index],
                                      currentUser: user,
                                      isSelf: true,
                                      change: (TaskElement taskElement) {},
                                    );
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
