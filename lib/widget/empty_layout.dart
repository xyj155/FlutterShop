import 'package:flutter/material.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

class StatusLayout extends StatelessWidget {
  ScreenUtils screenUtils = new ScreenUtils();
  final String statusMsg;
  final String imgPath;

  StatusLayout({this.statusMsg, this.imgPath});
  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Center(
      child: new Column(
        children: <Widget>[
          new Image.asset(imgPath==null?"assert/imgs/ic_empty_bg.png":imgPath,
            width:screenUtils.setWidgetWidth(150),
          height: screenUtils.setWidgetHeight(150),),
        new Container(
          margin: EdgeInsets.all(screenUtils.setWidgetHeight(10)),
          child:   new Text(statusMsg,style: new TextStyle(
              color: Colors.grey,fontSize: screenUtils.setFontSize(15)
          ),),
        )
        ],
          mainAxisAlignment:MainAxisAlignment.center,

      ),
    );
  }
}