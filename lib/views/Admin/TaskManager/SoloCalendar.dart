import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:propview/models/Task.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/taskService.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/utils/snackBar.dart';
import 'package:propview/views/Admin/TaskManager/CreateTaskScreen.dart';
import 'package:propview/views/Admin/TaskManager/EditTaskScreen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SoloCalendar extends StatefulWidget {
  final User user;

  const SoloCalendar({this.user});

  @override
  _SoloCalendarState createState() => _SoloCalendarState();
}

class DataSource extends CalendarDataSource {
  DataSource(List source) {
    appointments = source;
  }
}

_getCalendarDataSource(List<TaskElement> tasks) {
  List appointments = [];
  tasks.forEach((element) {
    appointments.add(Appointment(
      startTime: element.startDateTime,
      endTime: element.endDateTime,
      subject: element.propertyName == "No Property"
          ? element.taskName
          : element.propertyName,
      notes: element.taskStatus,
      resourceIds: [element],
      color: returnColor(element.taskStatus),
      startTimeZone: '',
      endTimeZone: '',
      // location: element.taskId.toString(),
    ));
  });

  return DataSource(appointments);
}

returnColor(String status) {
  if (status == 'Pending') {
    return Colors.orange;
  } else if (status == 'Completed') {
    return Colors.green;
  } else if (status == 'Rejected') {
    return Colors.red;
  } else if (status == 'Unapproved') {
    return Colors.blue;
  }
}

class _SoloCalendarState extends State<SoloCalendar> {
  User currentUser;
  @override
  void initState() {
    super.initState();
    createEvent();
  }

  Task task;
  bool loading = false;

  createEvent() async {
    setState(() {
      loading = true;
    });
    task = await TaskService.getAllTaskByUserId(widget.user.userId);
    currentUser = await UserService.getUser();
    print(task.count);
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
              padding: const EdgeInsets.only(top: 32.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Unapproved"),
                        SizedBox(
                          width: 16,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Completed"),
                      ],
                    ),
                  ),
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Rejected"),
                        SizedBox(
                          width: 16,
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Pending"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SfCalendar(
                      showNavigationArrow: true,
                      dataSource: _getCalendarDataSource(task.data.task),
                      view: CalendarView.month,
                      showDatePickerButton: true,
                      appointmentTimeTextFormat: 'HH:mm',
                      allowedViews: [
                        CalendarView.day,
                        CalendarView.month,
                        CalendarView.timelineDay,
                        CalendarView.timelineMonth,
                      ],
                      monthViewSettings: MonthViewSettings(
                        showAgenda: true,
                        showTrailingAndLeadingDates: false,
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment,
                        numberOfWeeksInView: 6,
                      ),
                      scheduleViewSettings:
                          ScheduleViewSettings(hideEmptyScheduleWeek: false),
                      timeSlotViewSettings: TimeSlotViewSettings(
                          timeInterval: Duration(minutes: 30),
                          startHour: 7,
                          endHour: 21),
                      onTap: (value) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Task List"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: value.appointments
                                  .map(
                                    (e) => ListTile(
                                        title: Text(e.subject),
                                        subtitle: Text(
                                          e.notes,
                                          style: TextStyle(
                                            color: returnColor(
                                              e.notes,
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: InkWell(
                                          onTap: () {
                                            if (currentUser.userType ==
                                                    "admin" ||
                                                currentUser.userType ==
                                                    "super_admin" ||
                                                widget.user.parentId
                                                    .split(",")
                                                    .contains(
                                                        currentUser.userId)) {
                                              if (e.resourceIds[0].taskStatus ==
                                                      "Pending" ||
                                                  e.resourceIds[0].taskStatus ==
                                                      "Rejected") {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditTaskScreen(
                                                      task: e.resourceIds[0],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                showInSnackBar(
                                                    context,
                                                    "Task Alteration Not Allowed!",
                                                    1800);
                                                Navigator.of(context).pop();
                                              }
                                            } else {
                                              showInSnackBar(
                                                  context,
                                                  "Task Alteration Not Allowed!",
                                                  1800);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Icon(
                                            Icons.edit,
                                          ),
                                        )),
                                  )
                                  .toList(),
                            ),
                            actions: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CreateTaskScreen(),
                                    ),
                                  );
                                },
                                child: Text("Create New"),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
