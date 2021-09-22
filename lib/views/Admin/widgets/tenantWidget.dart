import 'package:flutter/material.dart';
import 'package:propview/constants/uiConstants.dart';
import 'package:propview/models/City.dart';
import 'package:propview/models/State.dart';
import 'package:propview/models/Tenant.dart';

class TenantWidget extends StatelessWidget {
  final Tenant tenant;
  final int index;
  final List<CStates> cstates;
  final List<City> cities;
  TenantWidget({this.tenant, this.index, this.cstates, this.cities});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        tenantDetailsModalSheet(context);
      },
      child: Container(
        child: Text(
          '${index + 1}. ${tenant.name}',
          style: Theme.of(context)
              .primaryTextTheme
              .subtitle1
              .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  tenantDetailsModalSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        // isScrollControlled: true,
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter stateSetter) =>
                  Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: UIConstants.fitToHeight(16, context)),
                      Text(
                        'Tenant Details',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                                color: Color(0xff314B8C),
                                fontWeight: FontWeight.bold),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Divider(
                            color: Color(0xff314B8C),
                            thickness: 2.5,
                            indent: 100,
                            endIndent: 100,
                          )),
                      SizedBox(height: UIConstants.fitToHeight(16, context)),
                      detailsWidget(context, 'Name', '${tenant.name}'),
                      detailsWidget(
                          context, 'Primary Email', '${tenant.pemail}'),
                      detailsWidget(
                          context, 'Secondary Email', '${tenant.semail}'),
                      detailsWidget(
                          context, 'Primary Mobile', '${tenant.pmobile}'),
                      detailsWidget(
                          context, 'Secondary Mobile', '${tenant.smobile}'),
                      detailsWidget(context, 'Home Mobile', '${tenant.hphone}'),
                      detailsWidget(
                          context, 'office Mobile', '${tenant.ophone}'),
                      detailsWidget(context, 'Family',
                          tenant.isfamily == 1 ? 'Yes' : 'No'),
                      detailsWidget(
                          context, 'Primary Address', '${tenant.paddress}'),
                      detailsWidget(
                          context,
                          'City',
                          '${cities.where((element) {
                                return element.ccid == tenant.city;
                              }).first.ccname}'),
                      detailsWidget(
                          context,
                          'State',
                          '${cstates.where((element) {
                                return element.sid == tenant.state;
                              }).first.sname}'),
                      detailsWidget(context, 'Pan Number', '${tenant.pan}'),
                      detailsWidget(
                          context, 'Aadhar Number', '${tenant.aadhar}'),
                      detailsWidget(
                          context, 'Citizen', '${tenant.citizenship}'),
                      detailsWidget(
                          context, 'Total Members', '${tenant.totalmembers}'),
                      SizedBox(height: UIConstants.fitToHeight(24, context)),
                    ],
                  ),
                ),
              ),
            ));
  }

  Widget detailsWidget(BuildContext context, String title, String subtitle) {
    return ListTile(
      title: Text(title,
          style: Theme.of(context)
              .primaryTextTheme
              .subtitle1
              .copyWith(color: Colors.black, fontWeight: FontWeight.w600)),
      subtitle: subtitle != ''
          ? Text(subtitle,
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle2
                  .copyWith(color: Colors.black))
          : Text('Not there!',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle2
                  .copyWith(color: Colors.black)),
    );
  }
}
