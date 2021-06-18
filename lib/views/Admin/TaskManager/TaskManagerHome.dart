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
      searchResult21.addAll(pendingTaskList2);
      searchResult22.addAll(unApprovedTaskList2);
      searchResult23.addAll(completedTaskList2);
      loading = false;
    });
  }

  TabController _tabController;
  TabController _tabController21;
  TabController _tabController22;

  TextEditingController _searchController21 = TextEditingController();
  TextEditingController _searchController22 = TextEditingController();
  TextEditingController _searchController23 = TextEditingController();

  List searchResult21 = [];
  List searchResult22 = [];
  List searchResult23 = [];

  void searchOperation21(String searchText) {
    searchResult21.clear();
    if (searchText.isNotEmpty) {
      List templist = [];
      pendingTaskList2.forEach((element) {
        if (element.tblUsers.name
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          setState(() {
            templist.add(element);
          });
        }
      });
      setState(() {
        searchResult21.clear();
        searchResult21.addAll(templist);
      });
    } else {
      setState(() {
        searchResult21.clear();
        searchResult21.addAll(pendingTaskList2);
      });
    }
  }

  void searchOperation22(String searchText) {
    searchResult22.clear();
    if (searchText.isNotEmpty) {
      List templist = [];
      unApprovedTaskList2.forEach((element) {
        if (element.tblUsers.name
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          setState(() {
            templist.add(element);
          });
        }
      });
      setState(() {
        searchResult22.clear();
        searchResult22.addAll(templist);
      });
    } else {
      setState(() {
        searchResult22.clear();
        searchResult22.addAll(pendingTaskList2);
      });
    }
  }

  void searchOperation23(String searchText) {
    searchResult23.clear();
    if (searchText.isNotEmpty) {
      List templist = [];
      completedTaskList2.forEach((element) {
        if (element.tblUsers.name
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          setState(() {
            templist.add(element);
          });
        }
      });
      setState(() {
        searchResult23.clear();
        searchResult23.addAll(templist);
      });
    } else {
      setState(() {
        searchResult23.clear();
        searchResult23.addAll(pendingTaskList2);
      });
    }
  }

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
                    padding: const EdgeInsets.fromLTRB(12, 64, 12, 12),
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
                                  "https://propview.sgp1.digitaloceanspaces.com/User/${user.userId}.png",
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 0),
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(
                                                        0.0, 1.5), //(x,y)
                                                    blurRadius: 2,
                                                    spreadRadius: 0.1),
                                              ],
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextFormField(
                                                controller: _searchController21,
                                                onChanged: searchOperation21,
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Color(0xff314B8C),
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: 'Search By Name',
                                                  hintStyle: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: searchResult21.length == 0
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
                                                  padding: EdgeInsets.all(8.0),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      searchResult21.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return TaskCard(
                                                      taskElement:
                                                          searchResult21[index],
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 0),
                                          child: Container(
                                            height: 55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(
                                                        0.0, 1.5), //(x,y)
                                                    blurRadius: 2,
                                                    spreadRadius: 0.1),
                                              ],
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextFormField(
                                                controller: _searchController22,
                                                onChanged: searchOperation22,
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Color(0xff314B8C),
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: 'Search By Name',
                                                  hintStyle: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: searchResult22.length == 0
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
                                                  padding: EdgeInsets.all(8.0),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      searchResult22.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return TaskCard(
                                                      taskElement:
                                                          searchResult22[index],
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 0),
                                          child: Container(
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    offset: Offset(
                                                        0.0, 1.5), //(x,y)
                                                    blurRadius: 2,
                                                    spreadRadius: 0.1),
                                              ],
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: TextFormField(
                                                controller: _searchController23,
                                                onChanged: searchOperation23,
                                                decoration: InputDecoration(
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Color(0xff314B8C),
                                                  ),
                                                  border: InputBorder.none,
                                                  hintText: 'Search By Name',
                                                  hintStyle: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: searchResult23.length == 0
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
                                                  padding: EdgeInsets.all(8.0),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      searchResult23.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return TaskCard(
                                                      taskElement:
                                                          searchResult23[index],
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
