import 'package:flutter/services.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:platform/platform.dart';

class JMessageUtil {
  factory JMessageUtil() => _getInstance();

  static JMessageUtil get instance => _getInstance();
  static JMessageUtil _instance;
  JmessageFlutter jmessage;

  JMessageUtil._internal() {
    MethodChannel channel = MethodChannel('jmessage_flutter');
    jmessage = new JmessageFlutter.private(channel, const LocalPlatform());
    jmessage.login(username: "765274940", password: "765274940");
  }

  static JMessageUtil _getInstance() {
    if (_instance == null) {
      _instance = new JMessageUtil._internal();
    }
    return _instance;
  }

  Future<JMConversationInfo> createConversation(String username) async {
    JMSingle kMockUser = JMSingle.fromJson({
      'username': username,
    });
    JMConversationInfo conversation =
        await jmessage.createConversation(target: kMockUser);
    return conversation;
  }

  createTextMessage(String username) async {
    JMSingle kMockUser = JMSingle.fromJson({
      'username': username,
    });
    JMTextMessage msg = await jmessage.sendTextMessage(
      type: kMockUser,
      text: 'Text Message Test!',
    );
//    Map<String, String> userMap = new Map();
//    userMap.putIfAbsent("username", () => "1234567");
//    JMTextMessage msg = await jmessage.sendTextMessage(
//        type: JMSingle.fromJson(userMap),
//        text: 'Text Message Test!',
//        sendOption: JMMessageSendOptions.fromJson({
//          'isShowNotification': true,
//          'isRetainOffline': true,
//        }));
  }
}
