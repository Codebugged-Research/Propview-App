import 'package:flutter/material.dart';
import 'package:propview/models/Task.dart';
import 'package:propview/services/taskServices.dart';
import 'package:propview/utils/progressBar.dart';
import 'package:propview/views/Manager/TaskManager/CreateTaskScreen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SoloCalendar extends StatefulWidget {
  final String id;
  const SoloCalendar({this.id});

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
      subject: element.propertyName,
      notes: element.taskDesc,
      color: element.endDateTime.difference(element.startDateTime).inDays > 1
          ? Colors.orange
          : Colors.blue,
      startTimeZone: '',
      endTimeZone: '',
    ));
  });

  return DataSource(appointments);
}

class _SoloCalendarState extends State<SoloCalendar> {
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
    task = await TaskService.getAllPendingTaskByUserId(widget.id);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:loading ? circularProgressWidget() :  Padding(
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
