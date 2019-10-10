import 'package:flutter/material.dart';

class UserPostDetailList extends StatelessWidget {
   UserPostDetailList({
    Key key,
    this.title,
    this.onTap,
    this.imagePath,
  }) : super(key: key);

  final String title;
  final Function onTap;

  final String imagePath;



  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 8, right: 8),
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: new Row(
          children: <Widget>[
            new Image.asset(
              imagePath,
              width: 24,
              height: 21,
            ),
            new Text(
              title,
              style: new TextStyle(color: Color(0xffbcbfc3)),
            ),
          ],
        ),
        onTap:onTap,
      ),
    );
  }
}
