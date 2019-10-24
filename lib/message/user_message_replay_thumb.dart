import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/home/home_post_item_detail.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/gson/user_like_and_thumb_entity.dart';
import 'package:sauce_app/gson/user_comment_reply_entity.dart';

class UserThumbPage extends StatefulWidget {
  @override
  _UserThumbPageState createState() => _UserThumbPageState();
}

class _UserThumbPageState extends State<UserThumbPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    queryUserThumbByUserId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "点赞"),
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          var user_entity = _user_entity[position];
          return new GestureDetector(
            onTap:(){
              Navigator.push(context, new MaterialPageRoute(builder: (_){
                return new UserPostDetailItemPage(postId: user_entity.post.id.toString(),);
              }));
            },
            child: new Column(
              children: <Widget>[
                new Container(
                  height: _screenUtils.setWidgetHeight(110),
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            padding:
                            EdgeInsets.all(_screenUtils.setWidgetHeight(9)),
                            child: new RichText(
                                text: new TextSpan(
                                    text: user_entity.user.nickname,
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: _screenUtils.setFontSize(17),
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "     赞了你的帖子",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: _screenUtils.setFontSize(12),
                                              color: Colors.grey)),
                                    ])),
                          ),
                          new Container(
                            padding: EdgeInsets.only(
                              left: _screenUtils.setWidgetHeight(9),
                              right: _screenUtils.setWidgetHeight(9),
                            ),
                            child: new ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  _screenUtils.setWidgetWidth(56))),
                              child: new Image.network(
                                user_entity.user.avatar,
                                width: _screenUtils.setWidgetWidth(56),
                                height: _screenUtils.setWidgetHeight(56),
                              ),
                            ),
                          )
                        ],
                      ),
                      new Expanded(
                          child: new Container(
                            child: new Container(
                              height: _screenUtils.setWidgetHeight(90),
                              width: _screenUtils.setWidgetWidth(90),
                              child: new Text(
                                Base642Text.decodeBase64(
                                    user_entity.post.postContent),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: _screenUtils.setFontSize(13)),
                              ),
                            ),
                            height: _screenUtils.setWidgetHeight(90),
                            width: _screenUtils.setWidgetWidth(50),
                            alignment: Alignment.centerRight,
                          ))
                    ],
                  ),
                ),
                new Container(
                  height: 3,
                  color: Color(0xfffafafa),
                )
              ],
            ),
          );
        },
        itemCount: _user_entity.length,
        physics: new BouncingScrollPhysics(),
      ),
    );
  }

  List<UserLikeAndThumbData> _user_entity = new List();

  Future queryUserThumbByUserId() async {
    var sputil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(Api.QUERY_USER_THUMB,
        data: {"userId": sputil.getInt("id").toString(), "page": "1"});
    var decode = json.decode(response);
    var userLikeAndThumbEntity = UserLikeAndThumbEntity.fromJson(decode);
    if (userLikeAndThumbEntity.code == 200) {
      setState(() {
        _user_entity = userLikeAndThumbEntity.data;
      });
    }
    print(response);
  }
}

class UserMsgComment extends StatefulWidget {
  @override
  _UserMsgCommentState createState() => _UserMsgCommentState();
}

class _UserMsgCommentState extends State<UserMsgComment>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    queryUserThumbByUserId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "评论"),
      body: new ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          var user_entity = _user_entity[position];
          return new Column(
            children: <Widget>[
              new GestureDetector(
                onTap:(){
                  Navigator.push(context, new MaterialPageRoute(builder: (_){
                    return new UserPostDetailItemPage(postId: user_entity.post.id.toString(),);
                  }));
                },
                child: new Container(
                  height: _screenUtils.setWidgetHeight(110),
                  color: Colors.white,
                  child: new Row(
                    children: <Widget>[
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            padding:
                            EdgeInsets.all(_screenUtils.setWidgetHeight(9)),
                            child: new RichText(
                                text: new TextSpan(
                                    text: user_entity.user.nickname,
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: _screenUtils.setFontSize(17),
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "     评论了你的帖子",
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: _screenUtils.setFontSize(12),
                                              color: Colors.grey)),
                                    ])),
                          ),
                          new Container(
                            padding: EdgeInsets.only(
                              left: _screenUtils.setWidgetHeight(9),
                              right: _screenUtils.setWidgetHeight(9),
                            ),
                            child: new ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  _screenUtils.setWidgetWidth(56))),
                              child: new Image.network(
                                user_entity.user.avatar,
                                width: _screenUtils.setWidgetWidth(56),
                                height: _screenUtils.setWidgetHeight(56),
                              ),
                            ),
                          ),

                        ],
                      ),
                      new Expanded(
                          child: new Container(
                            child: new Container(
                              height: _screenUtils.setWidgetHeight(90),
                              width: _screenUtils.setWidgetWidth(90),
                              child: new Text(
                                Base642Text.decodeBase64(
                                    user_entity.comment==null?"":user_entity.comment),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: _screenUtils.setFontSize(13)),
                              ),
                            ),
                            height: _screenUtils.setWidgetHeight(90),
                            width: _screenUtils.setWidgetWidth(50),
                            alignment: Alignment.centerRight,
                          ))
                    ],
                  ),
                ),
              ),
              new Container(
                height: 3,
                color: Color(0xfffafafa),
              )
            ],
          );
        },
        itemCount: _user_entity.length,
        physics: new BouncingScrollPhysics(),
      ),
    );
  }

  List<UserCommentReplyData> _user_entity = new List();

  Future queryUserThumbByUserId() async {
    var sputil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(Api.QUERY_USER_THUMB,
        data: {"userId": sputil.getInt("id").toString(), "page": "1"});
    var decode = json.decode(response);
    var userLikeAndThumbEntity = UserCommentReplyEntity.fromJson(decode);
    if (userLikeAndThumbEntity.code == 200) {
      setState(() {
        _user_entity = userLikeAndThumbEntity.data;
      });
    }
    print(response);
  }
}
