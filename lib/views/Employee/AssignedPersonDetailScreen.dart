import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';

import 'package:propview/models/User.dart';
import 'package:propview/services/userService.dart';
import 'package:propview/utils/progressBar.dart';

class AssignedPersonDetailScreen extends StatefulWidget {
  final String assignedTo;

  const AssignedPersonDetailScreen({Key key, this.assignedTo})
      : super(key: key);

  @override
  _AssignedPersonDetailScreenState createState() =>
      _AssignedPersonDetailScreenState();
}

class _AssignedPersonDetailScreenState
    extends State<AssignedPersonDetailScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool loading = false;
  User assignedTo;

  getData() async {
    setState(() {
      loading = true;
    });
    assignedTo = await UserService.getUserById(
      widget.assignedTo,
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: loading
          ? circularProgressWidget()
          : Container(
              height: UIConstants.fitToHeight(640, context),
              width: UIConstants.fitToWidth(360, context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      headerWidget(context),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      profileSectionWidget(
                          context, 'Name', '${assignedTo.name}', Icons.home),
                      profileSectionWidget(context, 'Designation',
                          '${assignedTo.designation}', Icons.home),
                      profileSectionWidget(context, 'Number',
                          '${assignedTo.officialNumber}', Icons.home),
                      profileSectionWidget(context, 'Official Email',
                          '${assignedTo.officialEmail}', Icons.home),
                      profileSectionWidget(context, 'Personal Email',
                          '${assignedTo.personalEmail}', Icons.home),
                      profileSectionWidget(context, 'Local Address',
                          '${assignedTo.localAddress}', Icons.home),
                      profileSectionWidget(context, 'Permanent Address',
                          '${assignedTo.permanentAddress}', Icons.home),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget headerWidget(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [textWidget(context), imageWidget(context)]);
  }

  Widget textWidget(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: "Assigned\n",
            style: Theme.of(context)
                .primaryTextTheme
                .headline3
                .copyWith(fontSize: 42, fontWeight: FontWeight.bold),
            children: [
          TextSpan(
              text: 'To',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.normal))
        ]));
  }

  Widget imageWidget(BuildContext context) {
    return Image.asset(
      "assets/person.png",
      height: UIConstants.fitToHeight(75, context),
      width: UIConstants.fitToWidth(75, context),
    );
  }

  Widget profileSectionWidget(
      BuildContext context, String heading, String body, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                iconData,
                color: Color(0xff314B8C),
              ),
              SizedBox(width: UIConstants.fitToWidth(16, context)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                  Container(
                      width: UIConstants.fitToHeight(210, context),
                      child: Text(
                        body,
                        // overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .subtitle2
                            .copyWith(color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
