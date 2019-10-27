import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/widget/input_text_fied.dart';
import 'package:sauce_app/widget/loading_dialog.dart';

class UserNameEditPage extends StatefulWidget {
  @override
  _UserNameEditPageState createState() => _UserNameEditPageState();
}

class _UserNameEditPageState extends State<UserNameEditPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils screenUtil = new ScreenUtils();
  String _username = "";

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "修改用户名"),
      body: new Container(
        color: Colors.white,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              color: Color(0xfff8f8f8),
              alignment: Alignment.center,
              height: screenUtil.setWidgetHeight(55),
              margin: EdgeInsets.only(
                top: screenUtil.setWidgetHeight(16),
                left: screenUtil.setWidgetWidth(20),
                right: screenUtil.setWidgetWidth(20),
              ),
              child: new ITextField(
                  contentHeight: screenUtil.setWidgetHeight(15),
                  keyboardType: ITextInputType.text,
                  hintText: '请输入你的新用户名',
                  deleteIcon: new Image.asset(
                    "assert/imgs/icon_image_delete.png",
                    width: screenUtil.setWidgetWidth(18),
                    height: screenUtil.setWidgetHeight(55),
                  ),
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: screenUtil.setFontSize(15)),
                  inputBorder: InputBorder.none,
                  fieldCallBack: (content) {
                    setState(() {
                      _username = content;
                    });
                  }),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              height: screenUtil.setWidgetHeight(50),
              margin: EdgeInsets.only(
                top: screenUtil.setWidgetHeight(16),
                left: screenUtil.setWidgetWidth(20),
                right: screenUtil.setWidgetWidth(20),
              ),
              child: new MaterialButton(
                color:
                    _username.isEmpty ? Color(0xff7c7f88) : Color(0xff4ddfa9),
                textColor: Colors.white,
                child: new Text(
                  '修改',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog<Null>(
                      context: context, //BuildContext对象
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return new LoadingDialog(
                          //调用对话框
                          text: '登陆中...',
                        );
                      });
                  updateUserData("nickname",_username);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void updateUserData(String field, String data) async {
    print( Base642Text.encodeBase64(data));
    var instances = await SpUtil.getInstance();
    var id = instances.getInt("id").toString();
    var response = await HttpUtil.getInstance().post(Api.UPDATE_USER_FILED,
        data: {"userId": id, "filed": field, "inputData": Base642Text.encodeBase64(data)});
    print(response.toString());
    var decode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      Navigator.of(context).pop();
      instances.putString(field, data);
      Navigator.of(context).pop();
      ToastUtil.showCommonToast("修改成功！");
    } else {
      Navigator.of(context).pop();
      ToastUtil.showCommonToast("修改失败！");
    }
  }
}
class UserSignatureEditPage extends StatefulWidget {
  @override
  _UserSignatureEditPageState createState() => _UserSignatureEditPageState();
}

class _UserSignatureEditPageState extends State<UserSignatureEditPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils screenUtil = new ScreenUtils();
  String _username = "";

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "修改个性签名"),
      body: new Container(
        color: Colors.white,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              color: Color(0xfff8f8f8),
              alignment: Alignment.center,
              height: screenUtil.setWidgetHeight(55),
              margin: EdgeInsets.only(
                top: screenUtil.setWidgetHeight(16),
                left: screenUtil.setWidgetWidth(20),
                right: screenUtil.setWidgetWidth(20),
              ),
              child: new ITextField(
                  contentHeight: screenUtil.setWidgetHeight(15),
                  keyboardType: ITextInputType.text,
                  hintText: '请输入你的新个性签名',
                  deleteIcon: new Image.asset(
                    "assert/imgs/icon_image_delete.png",
                    width: screenUtil.setWidgetWidth(18),
                    height: screenUtil.setWidgetHeight(55),
                  ),
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: screenUtil.setFontSize(15)),
                  inputBorder: InputBorder.none,
                  fieldCallBack: (content) {
                    setState(() {
                      _username = content;
                    });
                  }),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              height: screenUtil.setWidgetHeight(50),
              margin: EdgeInsets.only(
                top: screenUtil.setWidgetHeight(16),
                left: screenUtil.setWidgetWidth(20),
                right: screenUtil.setWidgetWidth(20),
              ),
              child: new MaterialButton(
                color:
                _username.isEmpty ? Color(0xff7c7f88) : Color(0xff4ddfa9),
                textColor: Colors.white,
                child: new Text(
                  '修改',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog<Null>(
                      context: context, //BuildContext对象
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return new LoadingDialog(
                          //调用对话框
                          text: '登陆中...',
                        );
                      });
                  updateUserData("signature",_username);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void updateUserData(String field, String data) async {
    print(data);
    var instances = await SpUtil.getInstance();
    var id = instances.getInt("id").toString();
    var response = await HttpUtil.getInstance().post(Api.UPDATE_USER_FILED,
        data: {"userId": id, "filed": field, "inputData": Base642Text.encodeBase64(data)});
    print(response.toString());
    var decode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      Navigator.of(context).pop();
      instances.putString(field, data);
      Navigator.of(context).pop();
      ToastUtil.showCommonToast("修改成功！");
    } else {
      Navigator.of(context).pop();
      ToastUtil.showCommonToast("修改失败！");
    }
  }
}

