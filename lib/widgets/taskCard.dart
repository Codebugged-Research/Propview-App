import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:propview/models/Task.dart';

class TaskCard extends StatelessWidget {
  final TaskElement taskElement;
  TaskCard({this.taskElement});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        taskDetailsWidget(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 2.5,
                  spreadRadius: 0.0,
                ),
                BoxShadow(
                  color: Colors.grey,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 2.5,
                  spreadRadius: 0.0,
                ),
              ]),
          height: 160,
          child: Row(
            children: [
              Image.asset("assets/task.png"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textWidget(context, "Task Type: ", taskElement.category),
                    textWidget(
                        context,
                        "AssignedTo: ",
                        taskElement.tblUsers.name +
                            "\n(${taskElement.tblUsers.designation})"),
                    textWidget(
                        context,
                        "Property Name: \n",
                        taskElement.property.socid.toString() +
                            " " +
                            taskElement.property.unitNo.toString()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textWidget(BuildContext context, String label, String data) {
    return RichText(
      text: TextSpan(
        text: label,
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        children: <TextSpan>[
          TextSpan(
            text: data,
            style: GoogleFonts.nunito(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  taskDetailsWidget(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Color(0xFFFFFFFF),
        builder: (BuildContext context) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Task Details',
                          style: Theme.of(context).primaryTextTheme.headline6,
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Divider(
                          color: Color(0xff314B8C),
                          thickness: 2.5,
                          indent: 100,
                          endIndent: 100,
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        titleWidget(
                            context, 'Task ID: ', '${taskElement.taskId}'),
                        titleWidget(context, 'Task Status: ',
                            '${taskElement.taskStatus}'),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(
                        context, 'Task Category: ', '${taskElement.category}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(
                        context, 'Task name: ', '${taskElement.taskName}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Description: ',
                        '${taskElement.taskDesc}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Start Time: ',
                        '${taskElement.startDateTime}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task End Time: ',
                        '${taskElement.endDateTime}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Assigned-to: ',
                        '${taskElement.tblUsers.name} [${taskElement.tblUsers.designation}]'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Property Name: ',
                        '${taskElement.property.socid} + ${taskElement.property.unitNo}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Property Address: ',
                        '${taskElement.property.propertyDetail}'),
                  ],
                ),
              ), 
            ));
  }

  Widget titleWidget(BuildContext context, String label, String data) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context)
            .primaryTextTheme
            .subtitle1
            .copyWith(color: Color(0xff314B8C), fontWeight: FontWeight.w700),
        children: <TextSpan>[
          TextSpan(
            text: data,
            style: Theme.of(context).primaryTextTheme.subtitle2.copyWith(
                color: Color(0xff141414), fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
