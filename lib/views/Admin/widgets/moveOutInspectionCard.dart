import 'package:flutter/material.dart';
import 'package:propview/models/BillToProperty.dart';
import 'package:propview/models/Property.dart';

class MoveOutInspectionCard extends StatelessWidget {
  final PropertyElement propertyElement;
  final BillToProperty billToProperty;
  MoveOutInspectionCard({this.propertyElement, this.billToProperty});

  TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Bil Type:  ',
                style: Theme.of(context)
                    .primaryTextTheme
                    .subtitle1
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              Text(
                'Maintenance',
                style: Theme.of(context)
                    .primaryTextTheme
                    .subtitle1
                    .copyWith(color: Colors.black),
              )
              // Text('${BillTypeService.getBillTypeById(billToProperty.billTypeId.toString())}')
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.005),
          Row(
            children: [
              Text(
                'Property ID:  ',
                style: Theme.of(context)
                    .primaryTextTheme
                    .subtitle1
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              Text(
                '14',
                style: Theme.of(context)
                    .primaryTextTheme
                    .subtitle1
                    .copyWith(color: Colors.black),
              )
              // Text(
              //   '${propertyElement.tableproperty.propertyId.toString()}',
              //   style: Theme.of(context)
              //       .primaryTextTheme
              //       .subtitle1
              //       .copyWith(color: Colors.black),
              // )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.008),
          Text(
            'Amount',
            style: Theme.of(context)
                .primaryTextTheme
                .subtitle1
                .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
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
