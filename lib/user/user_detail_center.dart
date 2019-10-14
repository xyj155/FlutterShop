import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/widget/input_text_fied.dart';
import 'package:sauce_app/widget/list_title_right.dart';

class UserDetailCenterPage extends StatefulWidget {
  @override
  _UserDetailCenterPageState createState() => _UserDetailCenterPageState();
}

class _UserDetailCenterPageState extends State<UserDetailCenterPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String instance = "";
  String nickname = "";
  String avatar = "";
  String signature = "";
  String major = "";
  String school = "";
  String observe = "";
  String fans = "";
  String score = "";
  String sex = "";

  void loadUserData() async {
    var instance = await SpUtil.getInstance();
    setState(() {
      nickname = instance.getString("nickname");
      school = instance.getString("school");
      major = instance.getString("major");
      avatar = instance.getString("avatar");
      sex = instance.getString("sex");
      signature = instance.getString("signature");
      observe = instance.getString("observe");
      fans = instance.getString("fans");
      score = instance.getString("score");
    });
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "个人信息"),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverToBoxAdapter(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Text(
                    "基本信息",
                    style: new TextStyle(
                        color: Colors.grey,
                        fontSize: _screenUtils.setFontSize(14)),
                  ),
                  padding: EdgeInsets.only(
                      left: _screenUtils.setWidgetHeight(15),
                      top: _screenUtils.setWidgetHeight(8),
                      bottom: _screenUtils.setWidgetHeight(8)),
                ),
                new Container(
                  color: Color(0xfffafafa),
                  margin: EdgeInsets.only(bottom: 1.5),
                  alignment: Alignment.centerLeft,
                  height: 71.5,
                  child: new Container(
                    color: Colors.white,
                    height: 70,
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            child: new Text(
                              "头像",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                left: _screenUtils.setWidgetWidth(15))),
                        new Expanded(
                            child: new Container(
                              alignment: Alignment.centerRight,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    alignment: Alignment.centerRight,
                                    child: new ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              _screenUtils.setWidgetWidth(35))),
                                      child: new Image.network(
                                        avatar,
                                        width: _screenUtils.setWidgetWidth(55),
                                        height: _screenUtils.setWidgetHeight(
                                            57),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    margin: EdgeInsets.all(
                                        _screenUtils.setWidgetWidth(15)),
                                    child: new Image.asset(
                                      "assert/imgs/person_arrow_right_grayx.png",
                                      height: 15,
                                      width: 15,
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                new RightListTitle(
                  title: "用户名",
                  value: nickname,
                  onTap: () {
                    updateUserByInput("nickname", "用户名", "请输入用户名", nickname);
                  },
                ),
                new RightListTitle(
                  title: "个性签名",
                  value: signature.length > 8
                      ? signature.substring(0, 8) + "...."
                      : signature,
                  onTap: () {},
                ),
                new RightListTitle(
                  title: "性别",
                  value: sex == "1" ? "男" : "女",
                  onTap: () {},
                ),
                new Container(
                  height: _screenUtils.setWidgetHeight(10),
                ),
                new Container(
                  child: new Text(
                    "校园信息",
                    style: new TextStyle(
                        color: Colors.grey,
                        fontSize: _screenUtils.setFontSize(14)),
                  ),
                  padding: EdgeInsets.only(
                      left: _screenUtils.setWidgetHeight(15),
                      top: _screenUtils.setWidgetHeight(8),
                      bottom: _screenUtils.setWidgetHeight(8)),
                ),
                new RightListTitle(
                  title: "学校",
                  value: school,
                  onTap: () {},
                ),
                new RightListTitle(
                  title: "专业",
                  value: major,
                  onTap: () {},
                ),
                new RightListTitle(
                  title: "年级",
                  value: "用户名",
                  onTap: () {},
                ),
                new RightListTitle(
                  title: "入学时间",
                  value: "用户名",
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  String inputName = "";
  void updateUserByInput(String filed, String title, String placeHolder,
      String updateData) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "修改"+title,
              style: new TextStyle(
                  fontStyle: FontStyle.normal, fontWeight: FontWeight.normal),
            ),
            content: new Container(
              color: Color(0xfff8f8f8),
              alignment: Alignment.center,
              height: _screenUtils.setWidgetHeight(55),
              margin: EdgeInsets.only(top: _screenUtils.setWidgetHeight(16)),
              child: new ITextField(
                  contentHeight: _screenUtils.setWidgetHeight(15),
                  keyboardType: ITextInputType.number,
                  hintText: placeHolder,
                  deleteIcon: new Image.asset(
                    "assert/imgs/icon_image_delete.png",
                    width: _screenUtils.setWidgetWidth(18),
                    height: _screenUtils.setWidgetHeight(55),
                  ),
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: _screenUtils.setFontSize(15)),
                  inputBorder: InputBorder.none,
                  fieldCallBack: (content) {
                    inputName = content;
                  }),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('确认'),
                onPressed: () {
                  updateUserData(filed, inputName, updateData);
                },
              ),
              CupertinoDialogAction(
                child: Text('取消'),
                onPressed: () {
                  print('no...');
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void updateUserData(String field, String data, String updateData) async {
    print(data);
    var instances = await SpUtil.getInstance();
    var id = instances.getInt("id").toString();
    var response = await HttpUtil.getInstance().post(Api.UPDATE_USER_FILED,
        data: {"userId": id, "filed": field, "inputData": data});
    print(response.toString());
    var decode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      setState(() {
        nickname = data;
      });
      Navigator.of(context).pop();
      ToastUtil.showCommonToast("修改成功！");
    } else {
      Navigator.of(context).pop();
      ToastUtil.showCommonToast("修改失败！");
    }
  }
}
