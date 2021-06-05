import 'package:flutter/material.dart';
import 'package:propview/constants/uiContants.dart';
import 'package:propview/models/PropertyOwner.dart';
import 'package:propview/services/propertyOwnerService.dart';
import 'package:propview/utils/progressBar.dart';

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
                          context,
                          'Owner Name',
                          '${propertyOwner.salutation.trim()} ${propertyOwner.ownerName}',
                          Icons.home),
                      profileSectionWidget(context, 'Owner Number',
                          '${propertyOwner.ownerNumber.trim()}', Icons.home),
                      profileSectionWidget(
                          context,
                          'Whatsapp Number',
                          propertyOwner.whatsappNumber == ''
                              ? 'No Whatsapp Number'
                              : '${propertyOwner.whatsappNumber}',
                          Icons.home),
                      profileSectionWidget(context, 'Owner Email',
                          '${propertyOwner.ownerEmail}', Icons.home),
                      profileSectionWidget(context, 'Owner Address',
                          '${propertyOwner.ownerAddress}', Icons.home),
                      profileSectionWidget(
                          context,
                          'Account Name',
                          propertyOwner.accountName == ''
                              ? 'No Account Name'
                              : '${propertyOwner.accountName}',
                          Icons.home),
                      profileSectionWidget(
                          context,
                          'Bank Name',
                          propertyOwner.bankName == ''
                              ? 'No Bank Name'
                              : '${propertyOwner.bankName}',
                          Icons.home),
                      profileSectionWidget(
                          context,
                          'Account Number',
                          propertyOwner.accountNumber == ''
                              ? 'No Account Number'
                              : '${propertyOwner.accountNumber}',
                          Icons.home),
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
            text: "Owner\n",
            style: Theme.of(context)
                .primaryTextTheme
                .headline3
                .copyWith(fontSize: 42, fontWeight: FontWeight.bold),
            children: [
          TextSpan(
              text: 'Details',
              style: Theme.of(context)
                  .primaryTextTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.normal))
        ]));
  }

  Widget imageWidget(BuildContext context) {
    return Image.asset(
      "assets/owner.png",
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
