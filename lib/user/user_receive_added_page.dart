import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/event_bus.dart';
import 'package:sauce_app/widget/loading_dialog.dart';

class UserReceiveAddedPage extends StatefulWidget {
  int i;
  UserReceiveAddedPage({Key key, this.i}) : super(key: key);
  @override
  _UserReceiveAddedPageState createState() => _UserReceiveAddedPageState();
}

class _UserReceiveAddedPageState extends State<UserReceiveAddedPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String userTel = "";
  String addressNum = "";
  String username = "";

  ScreenUtils screenUtils = new ScreenUtils();
  var emptyResult = new Result();
  String local = "";

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    local = emptyResult == null || emptyResult.areaName == null
        ? ''
        : emptyResult.provinceName.toString() +
            emptyResult.cityName.toString() +
            emptyResult.areaName.toString();
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: BackUtil.NavigationBack(context, "收货地址"),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverToBoxAdapter(
            child: new Column(
              children: <Widget>[
                new GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    Result result = await CityPickers.showCityPicker(
                        context: context,
                        height: screenUtils.setWidgetHeight(200));
                    setState(() {
                      emptyResult = result;
                      local =
                          emptyResult == null || emptyResult.areaName == null
                              ? ''
                              : emptyResult.provinceName.toString() +
                                  emptyResult.cityName.toString() +
                                  emptyResult.areaName.toString();
                    });
                  },
                  child: new Container(
                    padding:
                        EdgeInsets.only(left: screenUtils.setWidgetWidth(18)),
                    alignment: Alignment.centerLeft,
                    height: screenUtils.setWidgetHeight(60),
                    child: new RichText(
                        text: TextSpan(
                            text: "地址",
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                            children: <TextSpan>[
                          new TextSpan(
                            text: emptyResult == null ||
                                    emptyResult.areaName == null
                                ? '     请选择地址'
                                : '     ' +
                                    emptyResult.provinceName.toString() +
                                    emptyResult.cityName.toString() +
                                    emptyResult.areaName.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ])),
                  ),
                ),
                new Divider(
                  indent: screenUtils.setWidgetWidth(30),
                  endIndent: screenUtils.setWidgetWidth(15),
                ),
                new TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '门牌号',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        bottom: screenUtils.setWidgetHeight(17),
                        top: screenUtils.setWidgetHeight(17)),
                    icon: new Container(
                      margin:
                          EdgeInsets.only(left: screenUtils.setWidgetWidth(16)),
                      child: new Text(
                        "门牌号",
                        style: new TextStyle(
                            fontSize: screenUtils.setFontSize(15),
                            color: Colors.black),
                      ),
                    ),
                  ),
                  autofocus: false,
                  onChanged: (content) {
                    addressNum = content;
                  },
                ),
                new Divider(
                  indent: screenUtils.setWidgetWidth(30),
                  endIndent: screenUtils.setWidgetWidth(15),
                ),
                new TextField(
                  onChanged: (content) {
                    username = content;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '请填写联系人',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        bottom: screenUtils.setWidgetHeight(17),
                        top: screenUtils.setWidgetHeight(17)),
                    icon: new Container(
                      margin:
                          EdgeInsets.only(left: screenUtils.setWidgetWidth(16)),
                      child: new Text(
                        "联系人",
                        style: new TextStyle(
                            fontSize: screenUtils.setFontSize(15),
                            color: Colors.black),
                      ),
                    ),
                  ),
                  autofocus: false,
                ),
                new Divider(
                  indent: screenUtils.setWidgetWidth(30),
                  endIndent: screenUtils.setWidgetWidth(15),
                ),
                new Container(
                  margin:
                      EdgeInsets.only(left: screenUtils.setWidgetHeight(40)),
                  child: new Row(
                    children: <Widget>[
                      new Text(
                        "男",
                        style: new TextStyle(
                            fontSize: screenUtils.setFontSize(15),
                            color: Colors.black),
                      ),
                      new Radio(
                          value: "男",
                          groupValue: groupValue,
                          activeColor: Colors.red,
                          onChanged: (T) {
                            updateGroupValue(T);
                          }),
                      new Text(
                        "女",
                        style: new TextStyle(
                            fontSize: screenUtils.setFontSize(15),
                            color: Colors.black),
                      ),
                      new Radio(
                          value: "女",
                          groupValue: groupValue,
                          activeColor: Colors.red,
                          onChanged: (T) {
                            updateGroupValue(T);
                          }),
                    ],
                  ),
                ),
                new Divider(
                  indent: screenUtils.setWidgetWidth(30),
                  endIndent: screenUtils.setWidgetWidth(15),
                ),
                new TextField(
                  onChanged: (content) {
                    userTel = content;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '请填写收货手机号码',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                        bottom: screenUtils.setWidgetHeight(17),
                        top: screenUtils.setWidgetHeight(17)),
                    icon: new Container(
                      margin:
                          EdgeInsets.only(left: screenUtils.setWidgetWidth(16)),
                      child: new Text(
                        "手机号码",
                        style: new TextStyle(
                            fontSize: screenUtils.setFontSize(15),
                            color: Colors.black),
                      ),
                    ),
                  ),
                  autofocus: false,
                ),
                new Divider(
                  indent: screenUtils.setWidgetWidth(30),
                  endIndent: screenUtils.setWidgetWidth(15),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width - 28,
                  height: screenUtils.setWidgetHeight(50),
                  margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(27)),
                  child: new MaterialButton(
                    color: Color(0xff7c7f88),
                    textColor: Colors.white,
                    child: new Text(
                      "提交",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      showDialog<Null>(
                          context: context, //BuildContext对象
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return new LoadingDialog(
                              //调用对话框
                              text: '提交中...',
                            );
                          });

                      if (local.isEmpty ||
                          addressNum.isEmpty ||
                          username.isEmpty ||
                          userTel.isEmpty) {
                        Navigator.pop(context);
                        ToastUtil.showCommonToast("输入不可为空！");
                        return;
                      } else {
                        submitUserAddress();
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String groupValue = "男";

  void submitUserAddress() async {
    var instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().post(Api.SUBMIT_USER_ADDRESS, data:
        {
      "userId": instance.getInt("id").toString(),
      "username": username.toString(),
      "userTel": userTel.toString(),
      "localCity": local,
      "addressNum": addressNum.toString(),
      "sexTag": groupValue.toLowerCase(),
      "currentCity": emptyResult.cityName,
      "user_receive_address": addressNum,
    });
    var decode = json.decode(response.toString());
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if(baseResponseEntity.code==200){
      Navigator.pop(context);
      Navigator.pop(context,1);
      print(response.toString());
    }else{
      Navigator.pop(context);
    }

  }

  void updateGroupValue(String v) {
    setState(() {
      groupValue = v;
    });
  }
}
