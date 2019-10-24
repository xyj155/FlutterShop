import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';

class RightListRadioButton extends StatelessWidget {
  String title;
  String value;
  final ValueChanged<bool> onTap;
  bool isSet;

  RightListRadioButton({Key key, this.title, this.value, this.onTap,this.isSet})
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
          leading: new Text(
            title,
            style: new TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
          ),
          title: new Container(
            alignment: Alignment.centerRight,
            child: new Text(value),
          ),
          trailing:new Switch(value: isSet, onChanged: onTap),
        ),
      ),
    );
  }
}

