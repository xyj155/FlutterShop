import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sauce_app/config.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/widget/list_radiobutton_right.dart';
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
    loadCache();
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
            new RightListTitle(
              title: "消息通知",
              value: "",
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return new NotificationPage();
                }));
              },
            ),
            new RightListTitle(
              title: "隐私设置",
              value: "",
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return new UserPrivacyPage();
                }));
              },
            ),
            new ListTile(
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
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
            new RightListTitle(
              value: SystemConfig.appVersion,
              title: '当前版本',
              onTap: () {
                _checkUpgrade();
              },
            ),
            new RightListTitle(
              value: cacheSize,
              title: '清除缓存',
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

  String cacheSize = "0.00K";

  ///加载缓存
  Future<Null> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);
      /*tempDir.list(followLinks: false,recursive: true).listen((file){
          //打印每个缓存文件的路径
        print(file.path);
      });*/
      print('临时目录大小: ' + value.toString());
      setState(() {
        cacheSize = _renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }

  /// 递归方式 计算文件的大小
  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
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

class UserPrivacyPage extends StatefulWidget {
  @override
  _UserPrivacyPageState createState() => _UserPrivacyPageState();
}

class _UserPrivacyPageState extends State<UserPrivacyPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "隐私设置"),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RightListRadioButton(
            value: "",
            title: "允许被搜索",
            onTap: (isCheck) {
              print(isCheck);
            },
          ),
          RightListRadioButton(
            value: "",
            title: "附近人可以私聊我",
            onTap: (isCheck) {
              print(isCheck);
            },
          ),
          RightListRadioButton(
            value: "",
            title: "允许聊天",
            onTap: (isCheck) {
              print(isCheck);
            },
          ),
        ],
      ),
    );
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
        child: Column(
          children: <Widget>[
            RightListTitle(
              title: "电话号码",
              value: "12141515515",
              onTap: () {},
            ),
            RightListTitle(
              title: "注销账号",
              value: "",
              onTap: () {},
            ),
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

class NotificationPage extends StatefulWidget {
  @override
  NotificationPageState createState() => new NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  String mode = "正常";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "消息通知"),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new RightListTitle(
              value: mode,
              title: "提示方式",
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new SimpleDialog(
                        title: new Text(
                          '选择',
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        children: <Widget>[
                          new SimpleDialogOption(
                            child: new Text("正常",
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                )),
                            onPressed: () {
                              setState(() {
                                mode = "正常";
                              });
                              Navigator.pop(context);
                            },
                          ),
                          new SimpleDialogOption(
                            child: new Text("静音",
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                )),
                            onPressed: () {
                              mode = "静音";
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
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
