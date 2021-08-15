import 'package:flutter/material.dart';
import 'package:propview/models/Facility.dart';

class TagWidget extends StatefulWidget {
  final List<Facility> tagList;

  TagWidget({this.tagList});

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.tagList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.tagList.removeAt(index);
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
                  widget.tagList[index].facilityName,
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
