import 'package:flutter/material.dart';

class UserPostDetailList extends StatefulWidget {
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
  UserPostDetailListState createState() => new UserPostDetailListState();
}

class UserPostDetailListState extends State<UserPostDetailList> {

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 8, right: 8),
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: new Row(
          children: <Widget>[
            new Image.asset(
              widget.imagePath,
              width: 24,
              height: 21,
            ),
            new Text(
              widget.title,
              style: new TextStyle(color: Color(0xffbcbfc3)),
            ),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  
}