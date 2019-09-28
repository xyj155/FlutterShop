import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/user_entity.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';

class UserObserveFansPage extends StatefulWidget {
  String type;

  UserObserveFansPage({Key key, this.type}) : super(key: key);

  @override
  _UserObserveFansPageState createState() => _UserObserveFansPageState();
}

class _UserObserveFansPageState extends State<UserObserveFansPage>
    with SingleTickerProviderStateMixin {
  int _page = 1;
  List<UserData> _user_list = new List();

  Future getUserFansByUid() async {
    SpUtil instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_USER_OBSERVE_FANS_BY_USERID, data: {
      "userId": instance.getInt("id").toString(),
      "type": widget.type,
      "page": _page.toString()
    });
    print('-------------------------------');
    print(response);
    print('-------------------------------');
    var decode = json.decode(response);
    var userEntity = UserEntity.fromJson(decode);
    if (userEntity.code == 200) {
      setState(() {
        _user_list = userEntity.data;
      });
    } else {
      ToastUtil.showCommonToast("还没有关注的人哦！");
    }
  }

  @override
  void initState() {
    getUserFansByUid();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Scaffold(
      appBar:
          BackUtil.NavigationBack(context, widget.type == "1" ? "关注" : "粉丝"),
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          return new Container(
            color: Colors.white,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.all(screenUtils.setWidgetWidth(10)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: "${_user_list[position].avatar}",
                          fit: BoxFit.cover,
                          width: screenUtils.setWidgetWidth(46),
                          height: screenUtils.setWidgetHeight(48),
                        ),
                      ),
                    ),
                    new Expanded(
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text("${_user_list[position].nickname}",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: screenUtils.setFontSize(17))),
                                new Container(
                                  padding: EdgeInsets.only(
                                      left: screenUtils.setWidgetWidth(4)),
                                  child: _user_list[position].sex == "1"
                                      ? new Image.asset(
                                    "assert/imgs/icon_male.png",
                                    width: screenUtils.setWidgetWidth(12),
                                    height: screenUtils.setWidgetHeight(12),
                                  )
                                      : new Image.asset(
                                    "assert/imgs/icon_female.png",
                                    width: screenUtils.setWidgetWidth(12),
                                    height: screenUtils.setWidgetHeight(12),
                                  ),
                                )
                              ],
                            ),
                            new Container(
                              height: screenUtils.setWidgetHeight(5),
                            ),
                            new RichText(
                              text: new TextSpan(
                                  text: "${_user_list[position].age}岁  ",
                                  style: new TextStyle(
                                      color: Colors.grey,
                                      fontSize: screenUtils.setFontSize(12)),
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: "${_user_list[position].city}  ",
                                        style: new TextStyle(
                                            color: Colors.grey,
                                            fontSize: screenUtils.setFontSize(12))),
                                    new TextSpan(
                                        text: "${_user_list[position].school}  ",
                                        style: new TextStyle(
                                            color: Colors.grey,
                                            fontSize: screenUtils.setFontSize(12)))
                                  ]),
                            )
                          ],
                        )),
                  ],
                ),
                new Container(
                  height: screenUtils.setWidgetHeight(1),
                  color: Color(0xfffafafa),
                  margin: EdgeInsets.only(left:screenUtils.setWidgetWidth(70) ),
                )
              ],
            ),
          );
        },
        itemCount: _user_list.length,
      ),
    );
  }
}
