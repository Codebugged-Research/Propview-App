import 'package:flutter/material.dart';
import 'package:propview/models/Task.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'CreateTaskScreen.dart';

class CalenderScreen extends StatefulWidget {
  final List<TaskElement> taskList;
  const CalenderScreen({Key key, this.taskList}) : super(key: key);

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class DataSource extends CalendarDataSource {
  DataSource(List source) {
    appointments = source;
  }
}

class TaskTile {
  TaskTile(
      {this.eventName = '',
      this.from,
      this.to,
      this.background,
      this.isAllDay = false});

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<TaskTile> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }
}

MeetingDataSource _getCalendarDataSource(List<TaskElement> tasks) {
  List<TaskTile> taskTiles = <TaskTile>[];
  tasks.forEach(
    (element) {
      print(DateTime(2019, 12, 20, 10)
          .difference(
            DateTime(2019, 12, 18, 10),
          )
          .inDays);
      taskTiles.add(
        TaskTile(
          eventName:
              element.taskName+"-"+element.tblUsers.name,
          from: DateTime.now(),
          to: DateTime.now().add(
            Duration(days: 2),
          ),
          background: DateTime(2019, 12, 20, 10)
                      .difference(
                        DateTime(2019, 12, 18, 10),
                      )
                      .inDays >
                  1
              ? Colors.orange
              : Colors.blue,
        ),
      );
    },
  );
  return MeetingDataSource(taskTiles);
}

class _CalenderScreenState extends State<CalenderScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // createEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: SfCalendar(
          onLongPress: (event) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CreateTaskScreen(),
                          ),
                        );
                      },
                      child: Text("Create New Task"),
                    ),
                  ],
                ),
              ),
            );
          },
          showNavigationArrow: true,
          dataSource: _getCalendarDataSource(widget.taskList),
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
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            numberOfWeeksInView: 6,
          ),
          scheduleViewSettings:
              ScheduleViewSettings(hideEmptyScheduleWeek: false),
          timeSlotViewSettings: TimeSlotViewSettings(
              timeInterval: Duration(minutes: 30), startHour: 7, endHour: 21),
        ),
      ),
    );
  }
}
