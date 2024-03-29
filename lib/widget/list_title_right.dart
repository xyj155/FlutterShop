import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';

class RightListTitle extends StatelessWidget {
  String title;
  String value;
  final Function onTap;

  RightListTitle({Key key, this.title, this.value, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Color(0xfffafafa),
      margin: EdgeInsets.only(bottom: 1.5),
      alignment: Alignment.centerLeft,
      height: 61.5,
      child: new Container(
        color: Colors.white,
        height: 60,
        child: new ListTile(
          onTap: onTap,
          leading: new Text(
            title,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          ),
          title: new Container(
            alignment: Alignment.centerRight,
            child: new Text(value),
          ),
          trailing: new Image.asset(
            "assert/imgs/person_arrow_right_grayx.png",
            height: 15,
            width: 15,
          ),
        ),
      ),
    );
  }
}

