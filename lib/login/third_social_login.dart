import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fake_tencent/fake_tencent.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/user_entity.dart';
import 'package:sauce_app/util/HttpUtil.dart';

import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/TransationUtil.dart';

import 'package:sauce_app/widget/login_social_button.dart';

import 'login.dart';
import 'user_register_information.dart';

class ThirdSocialLoginPage extends StatefulWidget {
  @override
  ThirdSocialLoginState createState() => new ThirdSocialLoginState();
}

String code = "";
String dataStr = "";

class ThirdSocialLoginState extends State<ThirdSocialLoginPage> {
  ScreenUtils screenUtil = new ScreenUtils();
  Tencent _tencent = Tencent()..registerApp(appId: '1109831276');
  StreamSubscription<TencentLoginResp> _login;
  StreamSubscription<TencentUserInfoResp> _userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJson();
    _login = _tencent.loginResp().listen(_listenLogin);
    _userInfo = _tencent.userInfoResp().listen(_listenUserInfo);
    fluwx.register(
        appId: "wxbdb66154033d3505", doOnAndroid: true, doOnIOS: true);
  }

  String openId = "";

  void _listenLogin(TencentLoginResp resp) {
    openId = resp.openid;
    _tencent.getUserInfo(
      openId: resp.openid,
      accessToken: resp.accessToken,
      expiresIn: resp.expiresIn,
      createAt: resp.createAt,
    );
  }

  Future _listenUserInfo(TencentUserInfoResp resp) async {

    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_USER_EXIST, data: {"socialId": openId});
    print("------------------------");
    print(response);
    print("------------------------");
    var response_json = json.decode(response);
    var userEntity = UserEntity.fromJson(response_json);
    if(userEntity.code==200){

    }else{
      Navigator.push(context, new MaterialPageRoute(builder: (_){
        return new UserAvatarRegisterPage(headImg: resp.headImgUrl(),nickName: resp.nickname,gender: resp.gender,qq: true,);
      }));

    }

  }

//微信登录
  _loginWeChat() async {
    fluwx.sendAuth(scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
    var respCode = "";
    fluwx.responseFromAuth.listen((response) {
      setState(() {
        code = 'response:' + response.code;
        respCode = response.code;
        _getAccessToken(respCode);
      });
    });
  }

  //获取act
  _getAccessToken(respCode) async {
//    var res = await UserDao.wxOauth(respCode);
//    setState(() {
//      if(res.data['Code'].toString()=='0'){
//        //跳转到我的
//        Navigator.pushNamed(context, '/myinfo');
//      }else{
//        //手机认证，跳转到手机认证
////        Navigator.of(context).push( new MaterialPageRoute(builder: (context)=> new MobilePage(token: res.data['Data']) ));
//      }
//    });
  }

  @override
  void dispose() {
    if (_login != null) {
      _login.cancel();
    }
    if (_userInfo != null) {
      _userInfo.cancel();
    }
    super.dispose();
  }

  List<PickerItem> list = new List();

  List<String> countryList = new List();

  void loadJson() {
    rootBundle.loadString('assert/json/country_code_json.json').then((value) {
      var encode = json.decode(value);
      for (int i = 0; i < encode.length; i++) {
        countryList.add(encode[i]['country']);
        list.add(new PickerItem(
            text: new Text(encode[i]['country']), value: encode[i]['code']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    screenUtil.initUtil(context);
    return new Stack(
      children: <Widget>[
        new Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: new Column(
            children: <Widget>[
              new Text("登录",
                  style: new TextStyle(
                      decoration: TextDecoration.none,
                      color: Color(0xff000000),
                      fontSize: screenUtil.setWidgetWidth(29),
                      fontWeight: FontWeight.bold)),
              new Container(
                child: new Text("社交账号快速登录",
                    style: new TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: screenUtil.setWidgetWidth(14),
                        color: Color(0xffb6b6b6))),
                padding: EdgeInsets.only(
                    top: screenUtil.setWidgetWidth(10),
                    bottom: screenUtil.setWidgetWidth(30)),
              ),
              new Container(
                padding: EdgeInsets.only(top: screenUtil.setWidgetHeight(28)),
                child: new LoginSocialButton(
                  icoPath: "assert/imgs/login_qq.png",
                  title: "QQ登录",
                  bgColor: Color(0xff2fc2ff),
                  onClickCallBack: () {
                    _tencent.login(
                      scope: [TencentScope.GET_SIMPLE_USERINFO],
                    );
                  },
                ),
              ),
              new LoginSocialButton(
                icoPath: "assert/imgs/login_wechat.png",
                title: "微信登录",
                bgColor: Color(0xff52bd33),
                onClickCallBack: () {
                  _loginWeChat();
                },
              ),
              new Container(
                child: new Expanded(
                    child: new GestureDetector(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            "使用手机号码登录或注册",
                            style: new TextStyle(
                                fontSize: screenUtil.setFontSize(15),
                                decoration: TextDecoration.none,
                                color: Color(0xff576189),
                                fontWeight: FontWeight.normal),
                          ),
                          new Image.asset(
                            "assert/imgs/login_arrow_rightx.png",
                            width: screenUtil.setWidgetWidth(17),
                            height: screenUtil.setWidgetHeight(13),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            new CustomRouteSlide(new LoginPage()),
                                (route) => route == null);
                      },
                    )),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          padding: EdgeInsets.only(
              left: screenUtil.setWidgetWidth(20),
              right: screenUtil.setWidgetWidth(20),
              top: screenUtil.setWidgetWidth(60)),
        ),
        new Container(
          alignment: Alignment.topRight,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
              top: screenUtil.setWidgetHeight(70),
              right: screenUtil.setWidgetWidth(20)),
          height: screenUtil.setWidgetHeight(38),
          child: GestureDetector(
            child: new Image.asset(
              "assert/imgs/closex.png",
              width: screenUtil.setWidgetWidth(20),
              height: screenUtil.setWidgetHeight(20),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  new CustomRouteSlide(new LoginPage()),
                      (route) => route == null);
            },
          ),
        )
      ],
    );
  }
}