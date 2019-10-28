//import 'package:amap_base_map/amap_base_map.dart';

import 'dart:convert';

//import 'package:amap_base_location/amap_base_location.dart';
import 'package:amap_base_location/amap_base_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_getuuid/flutter_getuuid.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/post/post_picture_page.dart';
import 'package:sauce_app/post/post_text_page.dart';
import 'package:sauce_app/square/square_user_snack_order.dart';
import 'package:sauce_app/user/user_address_page.dart';
import 'package:sauce_app/user/user_detail_center.dart';
import 'package:sauce_app/user/user_index.dart';
import 'package:sauce_app/user/user_information_edit.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/JMessageUtil.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';

import 'MainPage.dart';
import 'common/common_webview_page.dart';
import 'common/index.dart';
import 'common/user_detail_page.dart';
import 'event_bus.dart';
import 'home/home_post_item_detail.dart';
import 'home/home_user_topic.dart';
import 'home/post_topic_page.dart';
import 'login/invite_code_input_page.dart';
import 'login/is_submit_invite_code.dart';
import 'login/login.dart';
import 'package:platform/platform.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'login/third_social_login.dart';
import 'login/user_register_information.dart';
import 'login/user_register_owner_information.dart';
import 'message/conversation_list.dart';
import 'message/message_index.dart';
import 'message/user_message_replay_thumb.dart';
import 'post/post_video_page.dart';
import 'dart:io';
import 'square/school_activity_page.dart';
import 'square/shop_recharge_page.dart';
import 'square/square_little_shop.dart';
import 'square/square_part_time_job.dart';
import 'square/square_play_together.dart';
import 'user/user_receive_added_page.dart';
import 'user/user_setting.dart';
import 'util/amap_location_util.dart';

MethodChannel channel = MethodChannel('jmessage_flutter');
JmessageFlutter jmessage =
    new JmessageFlutter.private(channel, const LocalPlatform());

void main() => runApp(new MyApp());

JPush jPush = new JPush();
JMessageUtil jMessageUtil = new JMessageUtil();

void startupJpush() async {
  print("初始化jpush");
  jPush.setup(
      appKey: "a96bfaaaaa323f4e0e137fb0",
      channel: "developer-default",
      debug: true);

  print("初始化jpush成功");
  jmessage.addReceiveMessageListener((message) {
    eventBus.fire(ReceiveMessage(message: 'new'));
  });
  _fireMessagaeEvent();
}

List<Location> _result = [];
var spInstance;
Future _initAmap() async {

   spInstance = await SpUtil.getInstance();


   await AMap.init('30f75cebf01d9a3cfbf88670e2fc4344');
  var string = spInstance.getString("avatar");
  print("==========================================");
  print(string);
  print("==========================================");
  final options = LocationClientOptions(
    isOnceLocation: true,
    locatingWithReGeocode: true,
  );
  final _amapLocation = AMapLocation();
  if (await Permissions().requestPermission()) {
    _amapLocation.getLocation(options).then(_result.add).then((_) {
      print("==========================================");
      print(_result[0].address);
      print("==========================================");
    });
  } else {
    ToastUtil.showCommonToast('权限不足');
  }
}

_fireMessagaeEvent() async {
  FriendEvent event = FriendEvent('');
  eventBus.fire(event);
}

void initBugly() {
  FlutterBugly.init(
    androidAppId: "e7a846133c",
    iOSAppId: "your iOS app id",
    autoDownloadOnWifi: true,
  );
  FlutterBugly.checkUpgrade(isManual: true, isSilence: false);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    jmessage..setDebugMode(enable: true);
    jmessage.init(
        isOpenMessageRoaming: true, appkey: "653c79d202ad111a7925b9e2");
    jmessage.applyPushAuthority(
        new JMNotificationSettingsIOS(sound: true, alert: true, badge: true));
    startupJpush();
    initBugly();
    _initAmap();
    return Material(
      color: Colors.white,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: IndexPage(), //启动MainPage
      ),
    );
  }
}
