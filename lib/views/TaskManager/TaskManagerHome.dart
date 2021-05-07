import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskServices.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/views/Notification/notificationScreen.dart';

class TaskMangerHome extends StatefulWidget {
  @override
  _TaskMangerHomeState createState() => _TaskMangerHomeState();
}

class _TaskMangerHomeState extends State<TaskMangerHome> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  User user;
  bool loading = false;

  Task taskData;

  getData() async {
    setState(() {
      loading = true;
    });
    user = await UserService.getUser();
    taskData = await TaskService.getAllTask();
    setState(() {
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
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
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
                        child: Text("Total Task Count: ${taskData.count}"),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                          itemCount: taskData.count,
                          itemBuilder: (context, index) {
                            return taskCard(taskData.data.task[index]);
                          },
                        ),
                      ),
                      flex: 9,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  taskCard(TaskElement taskElement) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            offset: const Offset(
              0.0,
              0.0,
            ),
            blurRadius: 2.0,
            spreadRadius: 0.0,
          ), //BoxShadow
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(0.0, 0.0),
            blurRadius: 2.5,
            spreadRadius: 0.0,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
        height: 140,
        child: Row(
          children: [
            Image.asset("assets/task.png"),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Task Type: "+taskElement.category),
                SizedBox(
                  height: 6,
                ),
                Text("AssignedTo: " + taskElement.tblUsers.name + "\n(${taskElement.tblUsers.designation})"),
                SizedBox(
                  height: 6,
                ),
                Text("Property Owner's Name: \n"+taskElement.propertyOwner.ownerName),
                SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Text(taskElement.startDate),
                    SizedBox(
                      width: 10,
                    ),
                    Text(taskElement.endDate),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
