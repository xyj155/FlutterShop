import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/widget/list_title_right.dart';

class UserSettingPageIndex extends StatefulWidget {
  @override
  _UserSettingPageIndexState createState() => _UserSettingPageIndexState();
}

class _UserSettingPageIndexState extends State<UserSettingPageIndex>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
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
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "设置"),
      body: new Container(
        color: Colors.white,
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(
                "消息通知",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: new Image.asset(
                "assert/imgs/person_arrow_right_grayx.png",
                height: 15,
                width: 15,
              ),
            ),
            new ListTile(
              title: new Text(
                "隐私设置",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: new Image.asset(
                "assert/imgs/person_arrow_right_grayx.png",
                height: 15,
                width: 15,
              ),
            ),
            new ListTile(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (_){
                  return new AccountAndSecurityPage();
                }));
              },
              title: new Text(
                "账号与安全",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: new Image.asset(
                "assert/imgs/person_arrow_right_grayx.png",
                height: 15,
                width: 15,
              ),
            ),
            new Container(
              height: screenUtils.setWidgetHeight(10),
              color: Color(0xfffafafa),
            ),
            new ListTile(
              title: new Text(
                "我要打分",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: new Image.asset(
                "assert/imgs/person_arrow_right_grayx.png",
                height: 15,
                width: 15,
              ),
            ),
            new Container(
              height: screenUtils.setWidgetHeight(10),
              color: Color(0xfffafafa),
            ),
            new ListTile(
              title: new Text(
                "用户隐私及协议说明",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: new Image.asset(
                "assert/imgs/person_arrow_right_grayx.png",
                height: 15,
                width: 15,
              ),
            ),
            new ListTile(
              title: new Text(
                "帮助和反馈",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: new Image.asset(
                "assert/imgs/person_arrow_right_grayx.png",
                height: 15,
                width: 15,
              ),
            ),
            new ListTile(
              onTap: () {
                _checkUpgrade();
              },
              title: new Text(
                "当前版本",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: new Image.asset(
                "assert/imgs/person_arrow_right_grayx.png",
                height: 15,
                width: 15,
              ),
            ),
            new ListTile(
              title: new Text(
                "清除缓存",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              trailing: new Image.asset(
                "assert/imgs/person_arrow_right_grayx.png",
                height: 15,
                width: 15,
              ),
            ),
            new Container(
              height: screenUtils.setWidgetHeight(10),
              color: Color(0xfffafafa),
            ),
            new Container(
              padding: EdgeInsets.all(screenUtils.setWidgetHeight(15)),
              child: new Text(
                "退出登录",
                style: new TextStyle(
                  color: Colors.red,
                  decoration: TextDecoration.none,
                  fontSize: screenUtils.setFontSize(16),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            new Expanded(
                child: new Container(
              color: Color(0xfffafafa),
            ))
          ],
        ),
      ),
    );
  }

  void _checkUpgrade() {
    print("获取更新中。。。");
    FlutterBugly.init(
      androidAppId: "e7a846133c",
      iOSAppId: "your iOS app id",
      autoDownloadOnWifi: true,
    );
    FlutterBugly.checkUpgrade(isManual: true, isSilence: false)
        .then((UpgradeInfo info) {
      if (info != null && info.id != null) {
        print("----------------${info.apkUrl}");
//        _showUpdateDialog(info.newFeature, info.apkUrl, info.upgradeType == 2);
      }
    });
  }
}

class AccountAndSecurityPage extends StatefulWidget {
  @override
  AccountAndSecurityPageState createState() =>
      new AccountAndSecurityPageState();
}

class AccountAndSecurityPageState extends State<AccountAndSecurityPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "账号与安全"),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new RightListTitle(
              title: "手机号码",
              value: "1424141414",
            )
          ],
        ),
      ),
    );
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
