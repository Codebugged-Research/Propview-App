import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/widgets/taskCard.dart';

class SearchTask extends StatefulWidget {
  const SearchTask();

  @override
  _SearchTaskState createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> with TickerProviderStateMixin {
  @override
  void initState() {
    print("Dsa");
    super.initState();
    getData();
  }

  TextEditingController _searchController = TextEditingController();
  List<TaskElement> pendingTaskList = [];
  List<TaskElement> completedTaskList = [];
  List<TaskElement> unApprovedTaskList = [];
  List<User> userList;
  User user;
  User tempUser;
  bool serachLoading = false;
  bool loading = false;
  TabController _tabController;

  getData() async {
    setState(() {
      loading = true;
    });
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    user = await UserService.getUser();
    userList = await UserService.getAllUserUnderManger(user.userId);
    print(userList.length);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? circularProgressWidget()
          : Container(
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0),
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
                                });
                                Task userTask =
                                    await TaskService.getAllTaskByUserId(
                                        suggestion.userId);
                                print(userTask.count);
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
                          });
                        },
                      ),
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
                              child: pendingTaskList.length == 0
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
                                      padding: EdgeInsets.all(8.0),
                                      scrollDirection: Axis.vertical,
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: pendingTaskList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return TaskCard(
                                          taskElement: pendingTaskList[index],
                                          currentUser: user,
                                          isSelf: false,
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
                              child: unApprovedTaskList.length == 0
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
                                      padding: EdgeInsets.all(8.0),
                                      scrollDirection: Axis.vertical,
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: unApprovedTaskList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return TaskCard(
                                          taskElement:
                                              unApprovedTaskList[index],
                                          currentUser: user,
                                          isSelf: false,
                                          change1: (TaskElement taskElement) {
                                            setState(() {
                                              unApprovedTaskList.removeWhere(
                                                  (element) =>
                                                      element.taskId ==
                                                      taskElement.taskId);
                                              completedTaskList
                                                  .add(taskElement);
                                            });
                                          },
                                          change2: (TaskElement taskElement) {
                                            setState(() {
                                              unApprovedTaskList.removeWhere(
                                                  (element) =>
                                                      element.taskId ==
                                                      taskElement.taskId);
                                              pendingTaskList
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
                              child: completedTaskList.length == 0
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return TaskCard(
                                          taskElement:
                                              completedTaskList[index],
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
