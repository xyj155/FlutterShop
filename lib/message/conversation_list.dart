import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'package:jmessage_flutter/jmessage_flutter.dart'as jmessage;
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:sauce_app/message/single_conversation.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/JMessageUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:platform/platform.dart';
import 'package:sauce_app/util/relative_time_util.dart';
import 'package:sauce_app/widget/empty_layout.dart';

import '../event_bus.dart';
import '../main.dart';

class ConversationListPage extends StatefulWidget {
  @override
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage>
    with AutomaticKeepAliveClientMixin,    WidgetsBindingObserver  {
  AnimationController _controller;
  List<JMConversationInfo> conversationsList = new List();
  JMessageUtil manager = new JMessageUtil();
  @override
  void didUpdateWidget(ConversationListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies");
    initJMessageConversation();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("AppLifecycleState.inactive");
    switch (state) {
      case AppLifecycleState.inactive:
        print('AppLifecycleState.inactive');
        initJMessageConversation();
        break;
      case AppLifecycleState.paused:
        print('AppLifecycleState.paused');
        initJMessageConversation();
        break;
      // 从后台切回来刷新会话
      case AppLifecycleState.resumed:
        print('AppLifecycleState.resumed');
        initJMessageConversation();
        break;
      case AppLifecycleState.suspending:
        print('AppLifecycleState.suspending');
        initJMessageConversation();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  Future initJMessageConversation() async {
    List<JMConversationInfo> conversationLists =
        await jmessage.getConversations();
    print("------------------");
    print(conversationLists.length);
    print("------------------");
    setState(() {
      conversationsList = conversationLists;
    });
  }

  Timer _timer;

  @override
  void initState() {

    super.initState();
    initJMessageConversation();
    _addListener();
    WidgetsBinding.instance.addObserver(this);
  }
  _updateAllConversation() async {
    if (conversationsList.length > 0) {
      conversationsList.clear();
    }
    print('数组的长度${conversationsList.length}');
    List<JMConversationInfo> conversationList = await jmessage.getConversations();
    if (!mounted) return;
    setState(() {
      conversationsList = conversationList;
    });
    await Future.delayed(Duration(milliseconds: 400),(){
      eventBus.fire(UpdateUserInfo(message: 'avatar'));
    });
  }

  _addListener() {
    eventBus.on<UpdateNoteNameAndText>().listen((event) {
      _updateAllConversation();
    });

    eventBus.on<ReceiveMessage>().listen((event) async {
      _updateAllConversation();
    });

    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      _updateAllConversation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _timer.cancel();
  }

  Future<String> getUserAvatar(String username) async {
    Map resJson = await jmessage.downloadOriginalUserAvatar(
        username: username, appKey: '653c79d202ad111a7925b9e2');
    return resJson["filePath"];
  }

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return Scaffold(
        appBar: BackUtil.NavigationBack(context, "消息"),
        body: conversationsList.length != 0
            ? new ListView.builder(
                itemBuilder: (BuildContext context, int position) {
                  return userMsgList(conversationsList[position], context);
                },
                itemCount: conversationsList.length,
              )
            : new Center(
                child: new StatusLayout(
                  statusMsg: "你还没有会话哦！",
                ),
              ));
  }
  Future resetMsg(String username) async {
    await jmessage.resetUnreadMessageCount(
        target:  JMSingle.fromJson({
          'username': username,
        })
    );
  }

  ScreenUtils screenUtils = new ScreenUtils();

  Widget userMsgList(
      JMConversationInfo conversationInfo, BuildContext context) {
    JMNormalMessage jmTextMessage = conversationInfo.latestMessage;
    JMUserInfo target = conversationInfo.target;
    String content = "";
    if (jmTextMessage is JMTextMessage) {
      content = jmTextMessage.text;
    } else if (jmTextMessage is JMVoiceMessage) {
      content = '[语音]';
    } else if (jmTextMessage is JMImageMessage) {
      content = '[图片]';
    }
    String _avatar = target.avatarThumbPath;
    var file = new File(_avatar);
    getUserAvatar(target.username);
    return new Container(
      margin: EdgeInsets.only(bottom: screenUtils.setWidgetHeight(1)),
      color: Colors.white,
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: new Stack(
          alignment: AlignmentDirectional.bottomEnd, //内容对齐方式
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  child: new ClipOval(
                    child: Image.file(
                      file,
                      fit: BoxFit.fill,
                      height: screenUtils.setWidgetHeight(58),
                      width: screenUtils.setWidgetWidth(56),
                    ),
                  ),
                  padding: EdgeInsets.all(screenUtils.setWidgetWidth(12)),
                ),
                new Expanded(
                    child: new Container(
                  alignment: Alignment.centerLeft,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              conversationInfo.title,
                              style: new TextStyle(
                                  fontSize: screenUtils.setFontSize(17),
                                  decoration: TextDecoration.none),
                            ),
                            conversationInfo.unreadCount == 0
                                ? new Container()
                                : new Container(
                                    child: new ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      child: new Container(
                                        alignment: Alignment.center,
                                        width: screenUtils.setWidgetWidth(16),
                                        height: screenUtils.setWidgetHeight(16),
                                        color: Colors.redAccent,
                                        child: new Text(
                                          conversationInfo.unreadCount
                                              .toString(),
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  screenUtils.setFontSize(13)),
                                        ),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: screenUtils.setWidgetWidth(4)),
                                  )
                          ],
                        ),
                        padding: EdgeInsets.only(
                            bottom: screenUtils.setWidgetHeight(8)),
                      ),
                      new Container(
                        width: screenUtils.setWidgetWidth(200),
                        child: new Text(
                          content,
                          style: new TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                            fontSize: screenUtils.setFontSize(14),
                            decoration: TextDecoration.none,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            new Container(
              alignment: Alignment.bottomRight,
              margin: EdgeInsets.all(screenUtils.setWidgetHeight(6)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child:
                    new Text(String.fromCharCode(conversationInfo.unreadCount)),
              ),
            ),
            new Positioned(
                bottom: screenUtils.setWidgetHeight(4),
                right: screenUtils.setWidgetWidth(4),
                child: new Text(
                  RelativeDateFormat.formatWithStamp(jmTextMessage.createTime),
                  style: new TextStyle(
                      color: Colors.grey,
                      fontSize: screenUtils.setFontSize(12)),
                ))
          ],
        ),
        onTap: () {
          resetMsg(target.username);
          Navigator.push(
              context,
              new CustomRouteSlide(SingleConversationPage(
                  userId: target.username,
                  username: target.nickname,
                  type: 0,
                  avatar: target.avatarThumbPath)));
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
