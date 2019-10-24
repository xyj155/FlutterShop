import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/user_receive_address_entity.dart';
import 'package:sauce_app/user/user_index.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/widget/loading_dialog.dart';

import 'user_receive_added_page.dart';

class UserAddressPage extends StatefulWidget {
  @override
  UserAddressPageState createState() => new UserAddressPageState();
}

class UserAddressPageState extends State<UserAddressPage> {
  ScreenUtils screenUtils = new ScreenUtils();

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
        title: new Text("收货地址", style: new TextStyle(color: Color(0xff000000))),
        actions: <Widget>[
          new GestureDetector(
            onTap: () {
              pushPage();
            },
            child: new Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: screenUtils.setWidgetWidth(10)),
              child: new Text(
                "新增地址",
                style: new TextStyle(
                    color: Colors.black, fontSize: screenUtils.setFontSize(15)),
              ),
            ),
          )
        ],
      ),
      body: new Container(
        color: Colors.white,
        child: new ListView.builder(
          itemBuilder: (BuildContext contexts, int position) {
            return addressItem(_user_receive[position], contexts);
          },
          itemCount: _user_receive.length,
        ),
      ),
    );
  }


  Future pushPage() async {
    final result =
    await Navigator.push(context, new MaterialPageRoute(builder: (_) {
      return new UserReceiveAddedPage(
        i: 1,
      );
    }));
    if (result == 1) {
      getUserReceive();
    }
  }


  Widget addressItem(UserReceiveAddressData userReceiveAddressData,
      BuildContext context) {
    return new Container(
      child: new Container(
        padding: EdgeInsets.only(
            left: screenUtils.setWidgetWidth(10),
            right: screenUtils.setWidgetHeight(10)),
        child: new Stack(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Text(
                    userReceiveAddressData.localCity +
                        "  " +
                        userReceiveAddressData.addressNum,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: screenUtil.setFontSize(15)),
                  ),
                  margin: EdgeInsets.only(
                      top: screenUtils.setWidgetHeight(12),
                      bottom: screenUtils.setWidgetHeight(8)),
                ),
                new Container(
                  margin: EdgeInsets.only(
                      top: screenUtils.setWidgetHeight(8),
                      bottom: screenUtils.setWidgetHeight(12)),
                  child: new Text(
                    userReceiveAddressData.sexTag == "男"
                        ? "${userReceiveAddressData.username}   先生"
                        : "${userReceiveAddressData.username}   女士" +
                        "   ${userReceiveAddressData.userTel}",
                    style: new TextStyle(color: Colors.grey),
                  ),
                ),
                new Divider()
              ],
            ),
            new Positioned(
                right: 0,
                bottom: screenUtils.setWidgetHeight(30),
                child: new GestureDetector(
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return new UserReceiveEditPage(
                        id: userReceiveAddressData.id,
                        city: userReceiveAddressData.localCity.replaceAll("|", ""),
                        region: userReceiveAddressData.sexTag,
                        tel: userReceiveAddressData.userTel,
                        location: userReceiveAddressData.addressNum,
                        username: userReceiveAddressData.username,
                      );
                    }));
                  },
                  behavior: HitTestBehavior.opaque,
                  child: new Image.asset(
                    "assert/imgs/user_address_editor.png",
                    width: screenUtils.setWidgetWidth(17),
                    height: screenUtils.setWidgetHeight(17),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    getUserReceive();
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
        _user_receive = userReceiveAddressEntity.data;
      });
    } else {}
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

class UserReceiveEditPage extends StatefulWidget {
  int id;
  String city;
  String location;
  String tel;
  String username;

  String region;

  UserReceiveEditPage(
      {Key key, this.id, this.city, this.location, this.tel, this.username, this.region})
      : super(key: key);

  @override
  _UserReceiveEditPageState createState() => _UserReceiveEditPageState();
}

class _UserReceiveEditPageState extends State<UserReceiveEditPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    setState(() {
      groupValue=widget.region;
      local=widget.city.replaceAll("|", "");
      addressNum=widget.location;
      username=widget.username;
      userTel=widget.tel;
      print("====================================");
      print(local);
      print("====================================");
    });
  }
  String groupValue = "";
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
    local = (emptyResult == null || emptyResult.areaName == null)
        ? local : emptyResult.provinceName.toString() +
        emptyResult.cityName.toString() +
        emptyResult.areaName.toString();
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: BackUtil.NavigationBack(context, "更新地址"),
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
                                    ? '     ' + local
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
                  controller: new TextEditingController(text: addressNum),
                  keyboardType: TextInputType.text,
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
                  controller: new TextEditingController(text:username),
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
                  controller: new TextEditingController(text: userTel),
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 28,
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



  void submitUserAddress() async {
    var instance = await SpUtil.getInstance();
    var response =
    await HttpUtil.getInstance().post(Api.SUBMIT_USER_ADDRESS, data: {
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
    if (baseResponseEntity.code == 200) {
      Navigator.pop(context);
      Navigator.pop(context, 1);
      print(response.toString());
    } else {
      Navigator.pop(context);
    }
  }

  void updateGroupValue(String v) {
    setState(() {
      groupValue = v;
    });
  }
}
