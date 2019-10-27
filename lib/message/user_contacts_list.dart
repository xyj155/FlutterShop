import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/user_contact_list_entity.dart';
import 'package:sauce_app/util/AppEncryptionUtil.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

import 'single_conversation.dart';

class UserContactsListPage extends StatefulWidget {
  @override
  _UserContactsListPageState createState() => _UserContactsListPageState();
}

ScreenUtils screenUtils = new ScreenUtils();

class _UserContactsListPageState extends State<UserContactsListPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    getUserContactList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "好友列表"),
      body: EasyRefresh(
        header: ClassicalHeader(
            enableInfiniteRefresh: false,
            refreshText: "正在刷新...",
            refreshReadyText: "下拉我刷新哦！",
            refreshingText: "还在刷新哦！",
            refreshedText: "刷新好了哦！嘻嘻",
            refreshFailedText: "刷新失败了哦！",
            noMoreText: "没有数据了",
            infoText: "",
            bgColor: Colors.white,
            infoColor: Colors.white),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {});
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {});
          });
        },
        child: new ListView.builder(
            itemCount: _list.length,
            itemBuilder: (BuildContext context, int position) {
              return setUserContactList(_list[position]);
            }),
      ),
    );
  }

  List<UserContactListData> _list = new List();

  void getUserContactList() async {
    var response = await HttpUtil.getInstance().get(Api.QUERY_USER_CONTACT_LIST,
        data: {"userId": "100481", "page": "1"});
    var decode = json.decode(response.toString());
    print(decode);
    var userPostItemEntity = UserContactListEntity.fromJson(decode);
    if (userPostItemEntity.code == 200) {
      setState(() {
        _list = userPostItemEntity.data;
      });
    } else {}
  }

  Widget setUserContactList(UserContactListData userContactListData) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
        child: new Container(
      color: Colors.white,
      child: new GestureDetector(
        child: new Column(
          children: <Widget>[
           new Stack(
             children: <Widget>[
               new Row(
                 children: <Widget>[
                   new Container(
                     child: new ClipOval(
                       child: Image.network(
                         userContactListData.avatar,
                         fit: BoxFit.fill,
                         height: 52,
                         width: 52,
                       ),
                     ),
                     padding: EdgeInsets.all(screenUtils.setWidgetWidth(12)),
                   ),
                   new Expanded(
                       child: new Container(
                         alignment: Alignment.centerLeft,
                         child: new Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             new Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: <Widget>[
                                 new Container(
                                   margin: EdgeInsets.only(
                                       right: screenUtils.setWidgetWidth(5)),
                                   child: new Text(
                                     Base642Text.decodeBase64(userContactListData.nickname),
                                     style: new TextStyle(
                                         fontSize: screenUtils.setFontSize(16),
                                         decoration: TextDecoration.none),
                                   ),
                                 )
                               ],
                             ),
                           ],
                         ),
                       )
                   )
                 ],
               ),
               new Positioned(child: new Text(userContactListData.isOnline=="1"?"[在线]":"[离线]",style: new TextStyle(
                 color: userContactListData.isOnline=="1"?Color(0xff4ddfa9):Colors.grey,
               ),),right: 8,bottom: 8,)
             ],
           ),
            new Container(
              height: 1.5,
              color: Color(0xfffafafa),
            )
          ],
        ),
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (_) {
            return new SingleConversationPage(
              userId:  Base642Text.decodeBase64(userContactListData.nickname),
              avatar: userContactListData.avatar,
              username: userContactListData.nickname,
            );
          }));
        },
      ),
    ));
  }
}
