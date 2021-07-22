import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final List<String> tagList;
  final StateSetter stateSetter;
  TagWidget({this.tagList, this.stateSetter});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tagList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              stateSetter(() {
                tagList.removeAt(index);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xff314B8C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  tagList[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.caption.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          );
        });
  }
}
