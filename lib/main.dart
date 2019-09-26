
//import 'package:amap_base_map/amap_base_map.dart';
import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MainPage.dart';
import 'login/login.dart';
import 'package:platform/platform.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'login/third_social_login.dart';
import 'login/user_register_information.dart';
import 'login/user_register_owner_information.dart';
import 'square/part_time_job_detail_page.dart';
import 'square/square_little_shop.dart';
import 'square/square_part_time_job.dart';

MethodChannel channel = MethodChannel('jmessage_flutter');
JmessageFlutter jmessage =
    new JmessageFlutter.private(channel, const LocalPlatform());

void main() => runApp(new MyApp());

void JMessageLogin() async {
  jmessage.login(username: "17374131273", password: "xuyijie19971016");
  JMUserInfo u = await jmessage.getMyInfo();
  if (u != null) print(u.nickname + "==============");
}

JPush jPush = new JPush();

void startupJpush() async {
  print("初始化jpush");
  jPush.setup(
      appKey: "a96bfaaaaa323f4e0e137fb0",
      channel: "developer-default",
      debug: true);
  print("初始化jpush成功");
}

void initAMap() async {
  await AMap.init('30f75cebf01d9a3cfbf88670e2fc4344');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    jmessage..setDebugMode(enable: true);
    jmessage.init(
        isOpenMessageRoaming: true, appkey: "a96bfaaaaa323f4e0e137fb0");
    jmessage.applyPushAuthority(
        new JMNotificationSettingsIOS(sound: true, alert: true, badge: true));
    JMessageLogin();
    startupJpush();
    initAMap();
    return Material(
      color: Colors.white,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(), //启动MainPage
      ),
    );
  }
}
