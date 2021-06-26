import 'package:flutter/material.dart';
import 'package:propview/models/Property.dart';

class IssueInspectionScreen extends StatefulWidget {
  final PropertyElement propertyElement;
  const IssueInspectionScreen({this.propertyElement});
  @override
  _IssueInspectionScreenState createState() => _IssueInspectionScreenState();
}

class _IssueInspectionScreenState extends State<IssueInspectionScreen> {
  PropertyElement propertyElement;

  @override
  void initState() {
    super.initState();
    propertyElement = widget.propertyElement;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Issue Based\n",
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: "Inspection",
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headline3
                              .copyWith(fontWeight: FontWeight.normal))
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
