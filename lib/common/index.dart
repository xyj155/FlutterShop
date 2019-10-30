import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_getuuid/flutter_getuuid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/login/invite_code_input_page.dart';
import 'package:sauce_app/login/login.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainPage.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    queryUserLoginState();
  }

  void queryUserLoginState() async {
    var instance = await SharedPreferences.getInstance();
    print("======================================");
    print(instance.getString("avatar"));
    print("======================================");
    var in_splash = instance.getBool("isInSplash");
    if (in_splash) {
      if (instance.getString("login") != null) {
        Navigator.pushAndRemoveUntil(context,
            new MaterialPageRoute(builder: (_) {
          return new MainPage();
        }), (route) => route == null);
      } else {
        Navigator.pushAndRemoveUntil(context,
            new MaterialPageRoute(builder: (_) {
          return new LoginPage();
        }), (route) => route == null);
      }
    } else {
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_) {
        return new ApplicationGuidePage();
      }), (route) => route == null);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ApplicationGuidePage extends StatefulWidget {
  @override
  ApplicationGuidePageState createState() => new ApplicationGuidePageState();
}

class ApplicationGuidePageState extends State<ApplicationGuidePage> {
  ScreenUtils screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Container(
      color: Colors.white,
//        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: <Widget>[
          _createPageView(),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              width: screenUtils.setWidgetWidth(90),
              padding: EdgeInsets.only(bottom: screenUtils.setWidgetHeight(30)),
              child: Container(
                width: screenUtils.setWidgetWidth(68),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _dotWidget(0),
                      _dotWidget(1),
                      _dotWidget(2)
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  int _pageIndex = 0;
  PageController _pageController = PageController();

  Widget _createPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (pageIndex) {
        setState(() {
          _pageIndex = pageIndex;
          print(_pageController.page);
          print(pageIndex);
        });
      },
      children: <Widget>[
        Container(
          color: Colors.blue,
          child: Center(
            child: Text('Page 1'),
          ),
        ),
        Container(
          color: Colors.red,
          child: Center(
            child: Text('Page 2'),
          ),
        ),
        Container(
          color: Colors.white,
          child: new Stack(
            children: <Widget>[
              new Container(),
              new Positioned(
                  bottom: 13,
                  right: 13,
                  child: new Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(
                          right: screenUtils.setWidgetWidth(10),
                          bottom: screenUtils.setWidgetHeight(9)),
                      child: new GestureDetector(
                        onTap: () {
                          saveSplashData();
                        },
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: new Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  screenUtils.setWidgetHeight(30))),
                              border: new Border.all(
                                  width: 2, color: Color(0xff4ddfa9)),
                            ),
                            padding: EdgeInsets.only(
                                left: screenUtils.setWidgetWidth(16),
                                right: screenUtils.setWidgetWidth(16),
                                bottom: screenUtils.setWidgetHeight(5),
                                top: screenUtils.setWidgetHeight(5)),
                            child: new Text(
                              "开启",
                              style: new TextStyle(
                                  color: Color(0xff4ddfa9),
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ],
    );
  }

  Future saveSplashData() async {
    var instance = await SharedPreferences.getInstance();
    instance.setBool("isInSplash", true);
    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_) {
      return new LoginPage();
    }), (route) => route == null);
  }

  _dotWidget(int index) {
    return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (_pageIndex == index) ? Colors.white70 : Colors.black12));
  }

  Future requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([
          PermissionGroup.storage,
          PermissionGroup.location,
          PermissionGroup.photos,
          PermissionGroup.sms,
          PermissionGroup.locationAlways,
          PermissionGroup.locationWhenInUse,
          PermissionGroup.camera
        ]);
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission == PermissionStatus.granted) {
    } else {
      ToastUtil.showCommonToast("权限申请被拒绝");
    }
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
