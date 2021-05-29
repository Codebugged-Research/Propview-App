import 'package:flutter/material.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/services/propertyOwnerService.dart';

class PropertyOwnerDetailScreen extends StatefulWidget {
  final String propertyOwnerId;
  const PropertyOwnerDetailScreen({Key key, this.propertyOwnerId})
      : super(key: key);

  @override
  _PropertyOwnerDetailScreenState createState() =>
      _PropertyOwnerDetailScreenState();
}

class _PropertyOwnerDetailScreenState extends State<PropertyOwnerDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool loading = false;
  PropertyOwnerElement propertyOwner;

  getData() async {
    setState(() {
      loading = true;
    });
    propertyOwner = await PropertyOwnerService.getPropertyOwner(
      widget.propertyOwnerId,
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
                          'Property Owner Details',
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
                        context, 'Name: ', '${propertyOwner.ownerName}'),
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
