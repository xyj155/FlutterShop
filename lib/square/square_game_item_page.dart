import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/game_invite_list_entity.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/relative_time_util.dart';

class SquareGameItemPage extends StatefulWidget {
  String param;

  SquareGameItemPage({Key key, this.param}) : super(key: key);

  @override
  _SquareGameItemPageState createState() => _SquareGameItemPageState();
}

class _SquareGameItemPageState extends State<SquareGameItemPage>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    getGameInvite();
    super.initState();
  }

  List<GameInviteListData> _game_list = new List();
  ScreenUtils screenUtils = new ScreenUtils();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future getGameInvite() async {
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_GAME_INVITE_BY_TYPE,
        data: {"page": 1, "gameType": widget.param});
    var decode = json.decode(response);
    var gameInviteListEntity = GameInviteListEntity.fromJson(decode);
    if (gameInviteListEntity.code == 200) {
      setState(() {
        _game_list = gameInviteListEntity.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return Container(
      margin: EdgeInsets.all(screenUtils.setWidgetHeight(7)),
      color: Colors.white,
      child: new ListView.builder(
          itemCount: _game_list.length,
          itemBuilder: (BuildContext context, int position) {
            return getGameListItem(_game_list[position]);
          }),
    );
  }

  Widget getGameListItem(GameInviteListData gameInviteListData) {
    return new Stack(
      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(
              left: screenUtils.setWidgetWidth(15),
              top: screenUtils.setWidgetHeight(15),
              bottom: screenUtils.setWidgetHeight(20),
              right: screenUtils.setWidgetWidth(15)),
          child: new Container(
            height: screenUtils.setWidgetHeight(200),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                left: screenUtils.setWidgetWidth(40),
                top: screenUtils.setWidgetWidth(5)),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(screenUtils.setWidgetHeight(5))),
              boxShadow: [
                BoxShadow(
                    color: Color(0xffd8d8d8),
                    offset:
                        Offset.fromDirection(screenUtils.setWidgetHeight(8)),
                    blurRadius: 3)
              ],
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  "王者荣耀",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: screenUtils.setFontSize(22),
                      fontWeight: FontWeight.bold),
                ),
                new Container(
                  margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(7)),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(screenUtils.setWidgetWidth(45))),
                        child: new Image.network(
                          gameInviteListData.user.avatar,
                          width: screenUtils.setWidgetWidth(50),
                          height: screenUtils.setWidgetHeight(50),
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(
                            left: screenUtils.setWidgetWidth(10)),
                        height: screenUtils.setWidgetHeight(50),
                        alignment: Alignment.centerLeft,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              children: <Widget>[
                                new Text(
                                  "${gameInviteListData.user.nickname}",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: screenUtils.setFontSize(18)),
                                ),
                                new Container(
                                  width: screenUtils.setWidgetWidth(6),
                                ),
                                new Image.asset(
                                  gameInviteListData.user.sex == "0"
                                      ? "assert/imgs/icon_female.png"
                                      : "assert/imgs/icon_male.png",
                                  width: screenUtils.setWidgetWidth(15),
                                  height: screenUtils.setWidgetHeight(15),
                                ),
                              ],
                            ),
                            new Text(
                              "${gameInviteListData.user.school}",
                              style: new TextStyle(
                                  color: Colors.grey,
                                  fontSize: screenUtils.setFontSize(14)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(
                      right: screenUtils.setWidgetWidth(10),
                      top: screenUtils.setWidgetHeight(7)),
                  child: new Text(
                    gameInviteListData.remark,
                    style: new TextStyle(
                        color: Colors.grey,
                        fontSize: screenUtils.setFontSize(15)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                new Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: screenUtils.setWidgetWidth(15),top: screenUtils.setWidgetHeight(10)),
                  child: new Text(RelativeDateFormat.format(gameInviteListData.creatAt),style: new TextStyle(
                    color: Colors.grey
                  ),),
//                  child:new Text(DateUtil.formatDateStr(gameInviteListData.creatAt,format: "yyyy/M/d HH:mm:ss")),
                )
              ],
            ),
          ),
        ),
        new ClipRRect(
          borderRadius: BorderRadius.all(
              Radius.circular(screenUtils.setWidgetHeight(40))),
          child: new Image.asset(
            "assert/imgs/ic_game_lol.png",
            width: screenUtils.setWidgetWidth(50),
            height: screenUtils.setWidgetHeight(50),
          ),
        ),
        new Positioned(right:screenUtils.setWidgetWidth(24),top: screenUtils.setWidgetHeight(24),child: new Image.asset(gameInviteListData.user.isOnline=="1"?"assert/imgs/ic_online.png":"",width: screenUtils.setWidgetWidth(15),height: screenUtils.setWidgetHeight(15),))
      ],
    );
  }

  String readTimestamp(String pa) {
    DateTime param = DateTime.parse(pa);
    var timestamp = param.millisecondsSinceEpoch;
    var now = new DateTime.now();
    var format = new DateFormat('Y-M-D HH:mm:ss');

    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';
    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' 天前';
      } else {
        time = diff.inDays.toString() + ' 天前';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' 周前';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' 周前';
      }
    }

    return time;
  }
}
