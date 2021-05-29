import 'package:flutter/material.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/models/User.dart';
import 'package:propview/services/propertyOwnerService.dart';
import 'package:propview/services/userService.dart';

class AssignedPersonDetailScreen extends StatefulWidget {
  final String assignedTo;
  const AssignedPersonDetailScreen({Key key, this.assignedTo})
      : super(key: key);

  @override
  _AssignedPersonDetailScreenState createState() =>
      _AssignedPersonDetailScreenState();
}

class _AssignedPersonDetailScreenState extends State<AssignedPersonDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
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
      body: loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.only(top: 56.0, left: 24, right: 24),
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
                    'Assigned Person Details',
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
              titleWidget(
                  context, 'Name: ', '${assignedTo.name}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget(BuildContext context, String label, String data) {
    return RichText(
      text: TextSpan(
        text: label,
        style: Theme.of(context).primaryTextTheme.headline6.copyWith(
            color: Color(0xff314B8C),
            fontWeight: FontWeight.w700,
            fontSize: 20),
        children: <TextSpan>[
          TextSpan(
            text: data,
            style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                color: Color(0xff141414),
                fontWeight: FontWeight.w600,
                fontSize: 18),
          )
        ],
      ),
    );
  }
}
