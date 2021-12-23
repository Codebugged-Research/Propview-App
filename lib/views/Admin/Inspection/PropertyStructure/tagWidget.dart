import 'package:flutter/material.dart';
import 'package:propview/models/Facility.dart';

class TagWidget extends StatefulWidget {
  List<Facility> tagList;

  TagWidget({@required this.tagList});

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  showConfirm(index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Tag"),
          content: Text("Are you sure you want to remove tag ${widget.tagList[index].facilityName} ?"),
          actions: <Widget>[
            MaterialButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  widget.tagList.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.tagList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              showConfirm(index);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 32,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Color(0xff314B8C),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.tagList[index].facilityName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          );
        });
  }
}
