import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/message/user_contacts_list.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/JMessageUtil.dart';
import 'package:sauce_app/gson/user_thumb_and_replay_entity.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:platform/platform.dart';

import '../main.dart';
import 'conversation_list.dart';
import 'user_message_replay_thumb.dart';

class MessagePageIndex extends StatefulWidget {
  @override
  _MessagePageIndexState createState() => _MessagePageIndexState();
}

class _MessagePageIndexState extends State<MessagePageIndex>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  ScreenUtils screenUtils = new ScreenUtils();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    initJMessageConversation();
    getUserThumbAndReplay();
    super.initState();
  }

  List<JMConversationInfo> conversations = new List();
  JMessageUtil manager = new JMessageUtil();

  Future initJMessageConversation() async {
    if (jmessage != null) {
      conversations = await jmessage.getConversations();

//      JMConversationInfo createConversation =
//          await manager.createConversation();
//      manager.createMessage();
//      ToastUtil.showCommonToast("发送消息成功！");
    } else {
//      ToastUtil.showCommonToast("获取消息列表失败！");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Container(
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Container(
            child: new Text("消息",
                style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            padding: new EdgeInsets.only(top: 16, left: 20, bottom: 20),
            alignment: Alignment.centerLeft,
          ),
          new Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              new ListTile(
                onTap: (){
                  Navigator.push(context,new MaterialPageRoute(builder: (_){
                    return new UserThumbPage();
                  }));
                },
                  title: new Text(
                    "点赞",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 53, 225, 191)),
                  ),
                  leading: new Image.asset(
                    "assert/imgs/message_like.png",
                    width: 39,
                    height: 39,
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/message_thumb_arrow_right.png",
                    height: 15,
                    width: 15,
                  )),
              new Positioned(
                child: _thumb_count > 0
                    ? new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        child: new Container(
                          alignment: Alignment.center,
                          width: screenUtils.setWidgetWidth(20),
                          height: screenUtils.setWidgetHeight(20),
                          color: Colors.redAccent,
                          child: new Text(
                            _thumb_count > 99 ? "99" : _thumb_count.toString(),
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: screenUtils.setFontSize(12)),
                          ),
                        ),
                      )
                    : new Container(),
                right: screenUtils.setWidgetWidth(45),
              )
            ],
          ),
          new Divider(
            indent: 40,
            height: 10,
            color: Color(0xfffafafa),
          ),
          new Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              new ListTile(
                onTap: (){
                  Navigator.push(context,new MaterialPageRoute(builder: (_){
                    return new UserMsgComment();
                  }));
                },
                title: new Text(
                  "回复",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 156, 222, 195)),
                ),
                trailing: new Image.asset(
                  "assert/imgs/message_notice_arrow_right.png",
                  height: 15,
                  width: 15,
                ),
                leading: new Image.asset(
                  "assert/imgs/message_notice.png",
                  width: 39,
                  height: 39,
                ),
              ),
              new Positioned(
                child: _reply_count > 0
                    ? new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        child: new Container(
                          alignment: Alignment.center,
                          width: screenUtils.setWidgetWidth(20),
                          height: screenUtils.setWidgetHeight(20),
                          color: Colors.redAccent,
                          child: new Text(
                            _reply_count > 99 ? "99" : _reply_count.toString(),
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: screenUtils.setFontSize(12)),
                          ),
                        ),
                      )
                    : new Container(),
                right: screenUtils.setWidgetWidth(45),
              )
            ],
          ),
          new Divider(
            height: 10,
            indent: 40,
            color: Color(0xfffafafa),
          ),
          new ListTile(
            onTap: () {
              Navigator.push(context, CustomRouteSlide(UserContactsListPage()));
            },
            title: new Text(
              "好友",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 127, 161, 246)),
            ),
            leading: new Image.asset(
              "assert/imgs/message_chat.png",
              width: 39,
              height: 39,
            ),
            trailing: new Image.asset(
              "assert/imgs/message_chat_arrow_right.png",
              height: 15,
              width: 15,
            ),
          ),
          new Divider(
            indent: 40,
            height: 10,
            color: Color(0xfffafafa),
          ),
          new ListTile(
            onTap: () {
              Navigator.push(context, CustomRouteSlide(ConversationListPage()));
            },
            title: new Text(
              "消息",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 92, 195, 255)),
            ),
            leading: new Image.asset(
              "assert/imgs/message_reply.png",
              width: 39,
              height: 39,
            ),
            trailing: new Image.asset(
              "assert/imgs/message_reply_arrow_right.png",
              height: 15,
              width: 15,
            ),
          ),
          new Divider(
            height: 10,
            indent: 40,
            color: Color(0xfffafafa),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    getUserThumbAndReplay();
  }

  int _thumb_count = 0;
  int _reply_count = 0;

  Future getUserThumbAndReplay() async {
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_USER_THUMB_AND_REPLAY_COUNT,
        data: {"userId": spUtil.getInt("id").toString()});
    print("-----------------------------------------");
    print(spUtil.getInt("id").toString());
    print("-----------------------------------------");
    var decode = json.decode(response);
    var userThumbAndReplayEntity = UserThumbAndReplayEntity.fromJson(decode);
    List<UserThumbAndReplayData> _list_thumb = userThumbAndReplayEntity.data;
    setState(() {
      _thumb_count = _list_thumb[0].unreadThumb;
      _reply_count = _list_thumb[0].unreadComment;
    });
  }
}
