import 'package:flutter/material.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Property.dart';
import 'package:propview/services/BillTypeService.dart';
import 'package:propview/utils/progressBar.dart';

class MoveInInspectionCard extends StatefulWidget {
  final PropertyElement propertyElement;
  final BillToProperty billToProperty;
  MoveInInspectionCard({this.propertyElement, this.billToProperty});

  @override
  _MoveInInspectionCardState createState() => _MoveInInspectionCardState();
}

class _MoveInInspectionCardState extends State<MoveInInspectionCard> {
  TextEditingController amountController;
  List ss = [];
  bool loading = false;
  String type = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    ss = await BillTypeService.getAllBillTypes();
    type = ss
        .firstWhere(
            (element) => element.billTypeId == widget.billToProperty.billTypeId)
        .billName;
    amountController =
        TextEditingController(text: widget.billToProperty.amount.toString());
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? circularProgressWidget()
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Bill Type:  ',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      type,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Row(
                  children: [
                    Text(
                      'Property Name:  ',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.propertyElement.propertyOwner.ownerName,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(color: Colors.black),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Row(
                  children: [
                    Text(
                      'Last Updated:  ',
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(
                              color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.billToProperty.lastUpdate.toLocal().toString(),
                      style: Theme.of(context)
                          .primaryTextTheme
                          .subtitle1
                          .copyWith(color: Colors.black),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Text(
                  'Amount',
                  style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                inputWidget(amountController),
              ],
            ),
          );
  }

  Widget inputWidget(TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: textEditingController,
        obscureText: false,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          labelStyle: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }
}
