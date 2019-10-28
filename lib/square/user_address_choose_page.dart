import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/user_receive_address_entity.dart';
import 'package:sauce_app/user/user_index.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';




class UserAddressChoosePage extends StatefulWidget {
  @override
  UserAddressChoosePageState createState() => new UserAddressChoosePageState();
}

class UserAddressChoosePageState extends State<UserAddressChoosePage> {
  ScreenUtils screenUtils=new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "选择收货地址"),
      body: new Container(
        color: Colors.white,
        child: new ListView.builder(itemBuilder: (BuildContext contexts,int position){
          return addressItem(_user_receive[position], contexts);
        },itemCount: _user_receive.length,),
      ),
    );
  }

Widget addressItem(UserReceiveAddressData userReceiveAddressData,BuildContext context){
return new GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: (){
    Navigator.pop(context,userReceiveAddressData);
  },
  child: new Container(
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
        ],
      ),
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
  void didUpdateWidget(UserAddressChoosePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
