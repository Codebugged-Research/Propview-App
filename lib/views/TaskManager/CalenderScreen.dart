import 'package:flutter/material.dart';
import 'package:propview/models/Task.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderScreen extends StatefulWidget {
  final List taskList;
  const CalenderScreen({Key key, this.taskList}) : super(key: key);

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class DataSource extends CalendarDataSource {
  DataSource(List source) {
    appointments = source;
  }
}

DataSource _getCalendarDataSource(tasks) {
  List appointments = [];
  tasks.forEach((element) {
    appointments.add(Appointment(
      startTime:element.startDateTime,
      endTime: element.endDateTime,
      subject: element.taskName,
      color: Colors.blue,
      startTimeZone: '',
      endTimeZone: '',
    ));
  });

  return DataSource(appointments);
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
          dataSource: _getCalendarDataSource(widget.taskList),
          view: CalendarView.month,
          showDatePickerButton: true,
          allowedViews: [
            CalendarView.day,
            CalendarView.month,
            CalendarView.timelineDay,
            CalendarView.timelineMonth,
            CalendarView.timelineWeek,
            CalendarView.week,
          ],
          monthViewSettings: MonthViewSettings(
              showAgenda: true,
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              numberOfWeeksInView: 6),
          scheduleViewSettings:
              ScheduleViewSettings(hideEmptyScheduleWeek: false),
          timeSlotViewSettings: TimeSlotViewSettings(
              timeInterval: Duration(hours: 1), startHour: 7, endHour: 21),
        ),
      ),
    );
  }
}
