import 'package:flutter/material.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/widget/cell_Input.dart';

import 'login.dart';

class InviteCodeInputPage extends StatefulWidget {
  @override
  InviteCodeInputPageState createState() => new InviteCodeInputPageState();
}

class InviteCodeInputPageState extends State<InviteCodeInputPage> {
  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new Container(
      padding: EdgeInsets.only(top: _screenUtils.setWidgetHeight(50),left:_screenUtils.setWidgetWidth(10),right: _screenUtils.setWidgetWidth(10)),
      color: Colors.black87,
      child: new Stack(
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(bottom: _screenUtils.setWidgetHeight(15),
                    left: _screenUtils.setWidgetWidth(10)),
                child: new Text("输入邀请码",style: new TextStyle(
                    color: Colors.white,fontWeight: FontWeight.bold,
                    fontSize: _screenUtils.setFontSize(27),
                    decoration: TextDecoration.none
                ),),
              ),
              new Container(
                margin: EdgeInsets.only(bottom: _screenUtils.setWidgetHeight(45),
                    left: _screenUtils.setWidgetWidth(10)),
                child: new Text("输入4位邀请码激活 就酱 体验资格",style: new TextStyle(
                    color: Colors.white,fontWeight: FontWeight.normal,
                    fontSize: _screenUtils.setFontSize(15),
                    decoration: TextDecoration.none
                ),),
              ),
              new Container(
                child: CellInput(
                    autofocus: false,
                    strokeColor: Colors.transparent,
                    inputType: InputType.number,
                    textColor: Colors.white,
                    solidColor: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    cellCount: 4,
                    inputCompleteCallback: (v) {
                      print(v);
                    }),

              )
            ],
          ),
         new Positioned(child: new GestureDetector(
           onTap: (){
             Navigator.of(context).pushAndRemoveUntil(
                 new MaterialPageRoute(builder: (context) => new LoginPage()
                 ), (route) => route == null);
           },
           child: new Center(
             child: new Text("已有账号登陆",style: new TextStyle(
               color: Color(0xff21dd87),
               fontSize: _screenUtils.setFontSize(16),
               fontWeight: FontWeight.bold,
               decoration: TextDecoration.none,
             ),),
           ),
         ),bottom: _screenUtils.setWidgetHeight(30),left: 0,right: 0,),

        ],
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
