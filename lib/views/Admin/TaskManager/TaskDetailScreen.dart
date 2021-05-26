import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:propview/models/Task.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskElement taskElement;
  TaskDetailScreen({this.taskElement});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24.0, bottom: 24.0, top: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/task.png",
                      height: 75,
                    ),
                    Text(
                      "Task Details",
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
