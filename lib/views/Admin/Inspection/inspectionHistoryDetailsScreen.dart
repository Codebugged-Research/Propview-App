import 'package:flutter/material.dart';
import 'package:propview/models/Inspection.dart';

class InspectionHistoryDetailsScreen extends StatefulWidget {
  final Inspection inspection;
  InspectionHistoryDetailsScreen({this.inspection});
  @override
  _InspectionHistoryDetailsScreenState createState() =>
      _InspectionHistoryDetailsScreenState();
}

class _InspectionHistoryDetailsScreenState
    extends State<InspectionHistoryDetailsScreen> {
  Inspection inspection;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inspection = widget.inspection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      text: "Move In\n",
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
                  ])),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        ));
  }
}
