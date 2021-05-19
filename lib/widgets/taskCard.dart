import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:propview/models/Task.dart';
import 'package:propview/services/taskServices.dart';

class TaskCard extends StatefulWidget {
  final TaskElement taskElement;
  final Function refresh;
  TaskCard({this.taskElement, this.refresh});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
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
                    textWidget(
                        context, "Task Type: ", widget.taskElement.category),
                    textWidget(
                        context,
                        "AssignedTo: ",
                        widget.taskElement.tblUsers.name +
                            "\n(${widget.taskElement.tblUsers.designation})"),
                    textWidget(
                        context,
                        "Property Name: \n",
                        widget.taskElement.property.socid.toString() +
                            " " +
                            widget.taskElement.property.unitNo.toString()),
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
                        titleWidget(context, 'Task ID: ',
                            '${widget.taskElement.taskId}'),
                        titleWidget(context, 'Task Status: ',
                            '${widget.taskElement.taskStatus}'),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Category: ',
                        '${widget.taskElement.category}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task name: ',
                        '${widget.taskElement.taskName}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Description: ',
                        '${widget.taskElement.taskDesc}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Start Time: ',
                        '${widget.taskElement.startDateTime}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task End Time: ',
                        '${widget.taskElement.endDateTime}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Task Assigned-to: ',
                        '${widget.taskElement.tblUsers.name} [${widget.taskElement.tblUsers.designation}]'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Property Name: ',
                        '${widget.taskElement.property.socid}  ${widget.taskElement.property.unitNo}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    titleWidget(context, 'Property Address: ',
                        '${widget.taskElement.propertyOwner.ownerAddress}'),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    widget.taskElement.taskStatus != "Completed"
                        ? Align(
                            alignment: Alignment.center,
                            child: MaterialButton(
                              child: Text(
                                "Complete Task",
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .subtitle2
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                              ),
                              color: Color(0xff314B8C),
                              onPressed: () async {
                                await showDialog(
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Alert !",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline5
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    content: Text(
                                      "Do you want to submit your task ?",
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    actions: [
                                      MaterialButton(
                                        onPressed: () async {
                                          setState(() {
                                            widget.taskElement.taskStatus =
                                                "Completed";
                                          });
                                          print(jsonEncode(
                                              widget.taskElement.toJson()));
                                          var response =
                                              await TaskService.updateTask(
                                                  widget.taskElement.taskId,
                                                  jsonEncode(widget.taskElement
                                                      .toJson()));
                                          print(response);
                                          Navigator.of(context).pop();

                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Yes",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle2
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "No",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .subtitle2
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  context: context,
                                );
                              },
                            ),
                          )
                        : Container(),
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
