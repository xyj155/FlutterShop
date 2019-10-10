import 'package:flutter/material.dart';

class RightListTitle extends StatelessWidget {
  String title;
  String value;

  RightListTitle({Key key, this.title, this.value})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(title,style: new TextStyle(
        color: Colors.black,fontSize: 15
      ),),
        trailing: new Row(
          children: <Widget>[
            new Text(value,style: new TextStyle(color: Colors.black,
            fontSize: 15),),
            new Image.asset(
              "assert/imgs/person_arrow_right_grayx.png",
              height: 15,
              width: 15,
            )
          ],
        ),

    );
  }
}