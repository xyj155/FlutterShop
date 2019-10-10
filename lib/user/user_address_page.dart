import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/user_receive_address_entity.dart';
import 'package:sauce_app/user/user_index.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';

import 'user_receive_added_page.dart';

class UserAddressPage extends StatefulWidget {
  @override
  UserAddressPageState createState() => new UserAddressPageState();
}

class UserAddressPageState extends State<UserAddressPage> {
  ScreenUtils screenUtils=new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 1,
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: new Text("收货地址",style:new TextStyle(color: Color(0xff000000))),
        actions: <Widget>[
          new GestureDetector(
            onTap:(){
              pushPage();
            },
            child:new Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: screenUtils.setWidgetWidth(10)),
              child:  new Text("新增地址",style: new TextStyle(
                  color: Colors.black,fontSize: screenUtils.setFontSize(15)
              ),
            ),),
          )
        ],
      ),
      body: new Container(
        color: Colors.white,
        child: new ListView.builder(itemBuilder: (BuildContext contexts,int position){
          return addressItem(_user_receive[position], contexts);
        },itemCount: _user_receive.length,),
      ),
    );
  }
  Future pushPage() async {
    final result = await Navigator.push(context, new MaterialPageRoute(builder: (_){
      return new UserReceiveAddedPage(i: 1,);
    }));
    if(result==1){
      getUserReceive();
    }
  }
Widget addressItem(UserReceiveAddressData userReceiveAddressData,BuildContext context){
return new Container(
  child: new Container(
    padding: EdgeInsets.only(left: screenUtils.setWidgetWidth(10),right: screenUtils.setWidgetHeight(10)),
    child: new Stack(
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new Text(userReceiveAddressData.localCity+"  "+userReceiveAddressData.addressNum,style: new TextStyle(
                  color: Colors.black,fontSize: screenUtil.setFontSize(15)
              ),),
              margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(12),bottom: screenUtils.setWidgetHeight(8)),
            ),
            new Container(
              margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(8),bottom: screenUtils.setWidgetHeight(12)),
              child:   new Text(userReceiveAddressData.sexTag=="男"?"${userReceiveAddressData.username}   先生":"${userReceiveAddressData.username}   女士"+"   ${userReceiveAddressData.userTel}" ,style: new TextStyle(
                  color: Colors.grey
              ),),
            ),
            new Divider()
          ],
        ),
        new Positioned(right:0,bottom: screenUtils.setWidgetHeight(30),child: new Image.asset("assert/imgs/user_address_editor.png",width: screenUtils.setWidgetWidth(17),height: screenUtils.setWidgetHeight(17),))
      ],
    ),
  ),
);
}
@override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserReceive();
  }

  List<UserReceiveAddressData> _user_receive = new List();

  Future getUserReceive() async {
    var spUtil = await SpUtil.getInstance();
    var reponse = await HttpUtil().get(Api.QUERY_USER_RECEIVER_LIST,
        data: {'userId': spUtil.getInt("id").toString()});
    var decode = json.decode(reponse.toString());
    var userReceiveAddressEntity = UserReceiveAddressEntity.fromJson(decode);
    if (userReceiveAddressEntity.code == 200) {
      setState(() {
        _user_receive=userReceiveAddressEntity.data;
      });
    }else{

    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(UserAddressPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
