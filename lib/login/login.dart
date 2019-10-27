import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getuuid/flutter_getuuid.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:sauce_app/MainPage.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/common/common_webview_page.dart';
import 'package:sauce_app/gson/user_entity.dart';
import 'package:sauce_app/login/invite_code_input_page.dart';
import 'package:sauce_app/login/third_social_login.dart';
import 'package:sauce_app/login/user_register_owner_information.dart';
import 'package:sauce_app/util/AppEncryptionUtil.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/HttpUtil.dart';

import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/util/logutil.dart';

import 'package:sauce_app/widget/input_text_fied.dart';
import 'package:sauce_app/widget/loading_dialog.dart';

final TextStyle _availableStyle = TextStyle(
    color: const Color(0xFF2da689),
    decoration: TextDecoration.none,
    fontSize: 14,
    fontWeight: FontWeight.normal);

final TextStyle _unavailableStyle = TextStyle(
    fontSize: 16.0,
    color: const Color(0xFFCCCCCC),
    decoration: TextDecoration.none,
    fontWeight: FontWeight.normal);

class LoginPage extends StatefulWidget {
  /// 倒计时的秒数，默认60秒。
  final int countdown;

  /// 用户点击时的回调函数。
  final Function onTapCallback;

  /// 是否可以获取验证码，默认为`false`。
  bool available;

  LoginPage({
    this.countdown: 60,
    this.onTapCallback,
    this.available: true,
  });

  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<LoginPage> {
  ScreenUtils screenUtil = new ScreenUtils();
  Timer _timer;
  String countryCode = "+（86）中国大陆";
  String verifyCode = "";

  /// 当前倒计时的秒数。
  int _seconds;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  TextStyle inkWellStyle = _availableStyle;

  /// 当前墨水瓶（`InkWell`）的文本。
  String _verifyStr = '获取验证码';

  /// 启动倒计时的计时器。
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        setState(() {
          _seconds = widget.countdown;
          inkWellStyle = _availableStyle;
        });
        return;
      }
      setState(() {
        _seconds--;
        _verifyStr = '已发送$_seconds' + 's';
      });
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  String smsCode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seconds = widget.countdown;
    loadJson();

    setState(() {
      smsCode = getRankCode();
    });
  }

  List<PickerItem> list = new List();

  String telPhone = '';
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

  void sendSMS() async {
    var response = await HttpUtil.getInstance().post(
        Api.QUERY_USER_AND_CHECK_EXIST,
        data: {"telphone": telPhone, "code": smsCode});
    print("--------------------");
    print({"telphone": telPhone, "code": smsCode});
    print(response);
    print("--------------------");
    var encode = json.decode(response.toString());
    var baseResponseEntity = BaseResponseEntity.fromJson(encode);
    if (baseResponseEntity.code == 200) {
      _startTimer();
      inkWellStyle = _unavailableStyle;
      _verifyStr = '已发送$_seconds' + 's';
      setState(() {
        ToastUtil.showCommonToast("验证码：" + smsCode);
      });
    } else if (baseResponseEntity.code == 201) {
      Navigator.push(context, new MaterialPageRoute(builder: (_) {
        return new InviteCodeInputPage();
      }));
//      setState(() {
//        notRegister = true;
//      });
    } else if (baseResponseEntity.code == 301) {
      ToastUtil.showErrorToast("发送验证码失败：" + baseResponseEntity.msg);
    }
  }

  bool notRegister = false;

  Future refresh() async {}

  Future queryUserByCode() async {
    var uuid = await FlutterGetuuid.platformUid;
    var instance = await HttpUtil.getInstance()
        .get(Api.QUERY_USER_BY_INVITE_CODE, data: {"ime": uuid});
    return instance;
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
                child: new Text("手机号注册或登录",
                    style: new TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: screenUtil.setWidgetWidth(14),
                        color: Color(0xffb6b6b6))),
                padding: EdgeInsets.only(
                    top: screenUtil.setWidgetWidth(10),
                    bottom: screenUtil.setWidgetWidth(30)),
              ),
              new GestureDetector(
                  child: new Container(
                    height: screenUtil.setWidgetHeight(55),
                    color: Color(0xfff8f8f8),
                    child: new ListTile(
                      title: new Text(countryCode,
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: screenUtil.setFontSize(15))),
                      trailing: new Image.asset(
                        "assert/imgs/arrow_down_refund.png",
                        width: screenUtil.setWidgetHeight(16),
                        height: screenUtil.setWidgetHeight(16),
                      ),
                    ),
                  ),
                  onTap: () async {
                    Picker picker = new Picker(
                        textStyle: new TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenUtil.setFontSize(12)),
                        itemExtent: screenUtil.setWidgetHeight(31),
                        adapter: PickerDataAdapter(
                          data: list,
                        ),
                        height: screenUtil.setWidgetHeight(210),
                        changeToFirst: true,
                        cancelText: "取消",
                        confirmText: "确定",
                        cancelTextStyle: new TextStyle(
                            color: Color(0xffbfbfbf),
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        confirmTextStyle: new TextStyle(
                            color: Color(0xff19bebf),
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                        columnPadding: const EdgeInsets.all(30.0),
                        onConfirm: (Picker picker, List value) {
                          this.setState(() {
                            countryCode = countryList[value[0]];
                          });
                        });
                    picker.showModal(context);
                  }),
              new Container(
                color: Color(0xfff8f8f8),
                alignment: Alignment.center,
                height: screenUtil.setWidgetHeight(55),
                margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
                child: new ITextField(
                    contentHeight: screenUtil.setWidgetHeight(15),
                    keyboardType: ITextInputType.number,
                    hintText: '请输入手机号',
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
                      telPhone = content;

                      LogUtil.Log(telPhone);
                    }),
              ),
              new Container(
                  height: screenUtil.setWidgetHeight(55),
                  color: Color(0xfff8f8f8),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        child: new TextField(
                          maxLength: 6,
                          style: new TextStyle(
                              fontSize: screenUtil.setFontSize(15)),
                          keyboardType: TextInputType.number,
                          onChanged: (content) {
                            setState(() {
                              verifyCode = content;
                            });
                          },
                          decoration: InputDecoration(
                              counterText: "",
                              hintText: '验证码',
                              border: new UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                        ),
                        width: screenUtil.setWidgetHeight(150),
                        margin: EdgeInsets.only(
                            left: screenUtil.setWidgetWidth(18)),
                      ),
                      new Expanded(
                          child: new Container(
                        alignment: Alignment.centerRight,
                        child: widget.available
                            ? InkWell(
                                child: Text(
                                  '  $_verifyStr  ',
                                  style: inkWellStyle,
                                ),
                                onTap: () {
                                  if (telPhone.isEmpty) {
                                    ToastUtil.showCommonToast("电话号码不可为空哦！");
                                  } else {
                                    bool isMobile = isChinaPhoneLegal(telPhone);
                                    if (isMobile) {
                                      if (_seconds == widget.countdown) {
                                        sendSMS();
                                      } else {
                                        return;
                                      }
                                    } else {
                                      ToastUtil.showCommonToast("你的电话号码不对哦！");
                                    }
                                  }
                                },
                              )
                            : InkWell(
                                child: Text(
                                  '  获取验证码  ',
                                  style: _unavailableStyle,
                                ),
                              ),
                      ))
                    ],
                  )),
              new Container(
                width: MediaQuery.of(context).size.width,
                height: screenUtil.setWidgetHeight(50),
                margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
                child: new MaterialButton(
                  color: Color(0xff7c7f88),
                  textColor: Colors.white,
                  child: new Text(
                    '登陆',
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
                    if (verifyCode == smsCode) {
                      if (telPhone.isEmpty) {
                        Navigator.pop(context);
                        ToastUtil.showCommonToast("手机号不可为空哦！");
                        return;
                      } else {
                        userLoginByUserName();
                      }
                    } else {
                      ToastUtil.showCommonToast("验证码不对哦！");
                      Navigator.pop(context);
                      return;
                    }
                  },
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
                child: RichText(
                  text: TextSpan(
                    text: '点“登录”按钮,即表明您已阅读并同意',
                    style: TextStyle(color: Colors.black, fontSize: 15.0),
                    children: <TextSpan>[
                      TextSpan(
                          text: '《用户注册协议》',
                          style: TextStyle(
                              color: Color(0xff576189), fontSize: 15.0),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (_) {
                                return new CommonWebViewPage(
                                  title: "用户注册协议",
                                  url:
                                      "https://sxystushop.xyz/JustLikeThis/public/app/user_register.html",
                                );
                              }));
                            }),
                      TextSpan(
                        text: '和 ',
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                      ),
                      TextSpan(
                          text: '《隐私权政策》 ',
                          style: TextStyle(
                              color: Color(0xff576189), fontSize: 15.0),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (_) {
                                return new CommonWebViewPage(
                                  title: "隐私权政策",
                                  url:
                                      "https://sxystushop.xyz/JustLikeThis/public/app/user_privacy.html",
                                );
                              }));
                            })
                    ],
                  ),
                ),
              ),
              new Container(
                child: new Expanded(
                    child: GestureDetector(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        "社交账号快速登录",
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
                    Navigator.push(
                        context, CustomRouteSlide(ThirdSocialLoginPage()));
                  },
                )),
              ),
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
                  new CustomRouteSlide(new ThirdSocialLoginPage()),
                  (route) => route == null);
            },
          ),
        )
      ],
    );
  }

  void saveUserData(UserData userData) async {
    print("=============================================================");
    print(userData.nickname);
    print("=============================================================");
    var instance = await SpUtil.getInstance();
    instance.putString("username", userData.username);
    instance.putString("avatar", userData.avatar);
    instance.putString("sex", userData.sex);
    instance.putString("latitude", userData.latitude);
    instance.putString("longitude", userData.longitude);
    instance.putString("currentCity", userData.currentCity);
    instance.putInt("page", userData.page);
    instance.putString("city", userData.city);
    instance.putString("signature", userData.signature);
    instance.putString("fans", userData.fans);
    instance.putString("score", userData.score);
    instance.putString("login", "1");
    instance.putString("school", userData.school);
    instance.putString("nickname", userData.nickname);
    instance.putString("major", userData.major);
    instance.putString("observe", userData.observe);
    instance.putInt("id", userData.id);
  }

  bool isChinaPhoneLegal(String str) {
    return new RegExp(
            '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$')
        .hasMatch(str);
  }
  @override
  void dispose() {
    _timer?.cancel();      //销毁计时器
    _timer=null;
    super.dispose();
  }

  void userLoginByUserName() async {
    var post = await HttpUtil.getInstance().post(Api.USER_LOGIN_BY_USERNAME,
        data: {"username": AppEncryptionUtil.verifyTokenEncode(telPhone)});

    var decode = json.decode(post.toString());
    var userEntity = UserEntity.fromJson(decode);
    if (userEntity.code == 200) {
      saveUserData(userEntity.data[0]);
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context,
          new CustomRouteSlide(new MainPage()), (route) => route == null);
    } else {
      ToastUtil.showCommonToast("用户信息获取错误或用户不存在！");
      Navigator.pop(context);
    }
  }

  String getRankCode() {
    String alphabet = "123456789".trim();
    var code = new StringBuffer();
    for (var i = 0; i < 6; i++) {
      var alphabet2 = alphabet[Random().nextInt(6)];
      code.write(alphabet2);
    }
    if (code.length < 6) {
      getRankCode();
    } else {
      return code.toString();
    }
  }
}
