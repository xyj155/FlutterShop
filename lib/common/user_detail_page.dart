import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/user_post_item_entity.dart';
import 'package:sauce_app/gson/user_view_detail_entity.dart';
import 'package:sauce_app/home/home_post_item_detail.dart';
import 'package:sauce_app/message/single_conversation.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/util/relative_time_util.dart';
import 'package:sauce_app/widget/Post_detail.dart';
import 'package:sauce_app/widget/list_title_right.dart';
import 'package:share/share.dart';

import 'common_vide_player.dart';
import 'picture_preview_dialog.dart';

const APPBAE_SCROLL_OFFSET = 100;

class UserDetailPage extends StatefulWidget {
  UserDetailPage({Key key, this.userId}) : super(key: key);
  String userId;

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    queryUserDetailByUserId();
  }

  Future queryUserDetailByUserId() async {
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil().get(Api.QUERY_VIEW_USER_DETAIL_BY_ID,
        data: {"userId": widget.userId, "Id": spUtil.getInt("id").toString()});
    print(response);
    print("------------------------------");
    print(widget.userId);
    print(spUtil.getInt("id").toString());
    print("------------------------------");
    if (response != null) {
      var decode = json.decode(response);
      var userViewDetailEntity = UserViewDetailEntity.fromJson(decode);
      if (userViewDetailEntity.code == 200) {
        setState(() {
          _userViewDetailData = userViewDetailEntity.data;
        });
      } else {
        ToastUtil.showErrorToast("获取用户数据失败！");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  double alphaAppBar = 0;

  _onScroll(offset) {
    double alpha = offset / APPBAE_SCROLL_OFFSET;
    if (alpha <= 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      alphaAppBar = alpha;
    });
    print(alphaAppBar);
  }

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    var d = (MediaQuery.of(context).size.width - 12) / 3;
    return _userViewDetailData == null
        ? new Center(
            child: new CupertinoActivityIndicator(
              radius: _screenUtils.setWidgetWidth(15),
            ),
          )
        : Scaffold(
            primary: false,
            body: new Container(
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: NotificationListener(
                            onNotification: (scrollNotification) {
                              if (scrollNotification
                                  is ScrollUpdateNotification) {
                                _onScroll(scrollNotification.metrics.pixels);
                              }
                              return false;
                            },
                            child: new ListView(
                              scrollDirection: Axis.vertical,
                              children: <Widget>[
                                new Stack(
                                  children: <Widget>[
                                    new Column(
                                      children: <Widget>[
                                        new Container(
                                            height: _screenUtils
                                                .setWidgetHeight(160),
                                            color: Colors.black54,
                                            child: Stack(
                                              children: [
                                                new GestureDetector(
                                                  child: Image.network(
                                                    _userViewDetailData.avatar,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover,
                                                    height: _screenUtils
                                                        .setWidgetHeight(160),
                                                  ),
                                                ),
                                                BackdropFilter(
                                                  filter: new ImageFilter.blur(
                                                      sigmaX: 8, sigmaY: 8),
                                                  child: new Container(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: _screenUtils
                                                        .setWidgetHeight(160),
                                                  ),
                                                ),
                                                new Container(
                                                  padding: EdgeInsets.only(
                                                      top: ScreenUtil
                                                          .statusBarHeight),
                                                  child: new AppBar(
                                                    leading: new IconButton(
                                                        icon: new Icon(Icons
                                                            .arrow_back_ios),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                    elevation: 0.5,
                                                    iconTheme:
                                                        new IconThemeData(
                                                            color:
                                                                Colors.white),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  ),
                                                ),
                                                new Positioned(
                                                    left: _screenUtils
                                                        .setWidgetWidth(110),
                                                    bottom: 10,
                                                    child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: <Widget>[
                                                        new Text(
                                                          Base642Text.decodeBase64( _userViewDetailData.nickname),
                                                          style: new TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  _screenUtils
                                                                      .setFontSize(
                                                                          21)),
                                                        ),
                                                        new Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: _screenUtils
                                                                .setWidgetWidth(
                                                                    4),
                                                          ),
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: new Text(
                                                            " ${_userViewDetailData.age}",
                                                            style: new TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    _screenUtils
                                                                        .setFontSize(
                                                                            13)),
                                                          ),
                                                        ),
                                                        new Container(
                                                          margin: EdgeInsets.only(
                                                              left: _screenUtils
                                                                  .setWidgetWidth(
                                                                      6)),
                                                          child:
                                                              new Image.asset(
                                                            _userViewDetailData
                                                                        .sex ==
                                                                    "1"
                                                                ? "assert/imgs/ic_user_boy.png"
                                                                : "assert/imgs/ic_user_girl.png",
                                                            width: _screenUtils
                                                                .setWidgetWidth(
                                                                    18),
                                                            height: _screenUtils
                                                                .setWidgetHeight(
                                                                    18),
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                              ],
                                            )),
                                        new Container(
                                          padding: EdgeInsets.only(
                                              left: _screenUtils
                                                  .setWidgetWidth(110),
                                              top: _screenUtils
                                                  .setWidgetHeight(15)),
                                          height:
                                              _screenUtils.setWidgetHeight(80),
                                          color: Colors.white,
                                          child: new Row(
                                            children: <Widget>[
                                              new Column(
                                                children: <Widget>[
                                                  new Text(
                                                    _userViewDetailData.fans,
                                                    style: new TextStyle(
                                                        fontSize: _screenUtils
                                                            .setFontSize(18),
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  new Text(
                                                    "粉丝",
                                                    style: new TextStyle(
                                                        fontSize: _screenUtils
                                                            .setFontSize(13),
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  )
                                                ],
                                              ),
                                              new Container(
                                                width: _screenUtils
                                                    .setWidgetWidth(15),
                                              ),
                                              new Column(
                                                children: <Widget>[
                                                  new Text(
                                                    _userViewDetailData.observe,
                                                    style: new TextStyle(
                                                        fontSize: _screenUtils
                                                            .setFontSize(18),
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  new Text(
                                                    "关注",
                                                    style: new TextStyle(
                                                        fontSize: _screenUtils
                                                            .setFontSize(13),
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    new Positioned(
                                      child: new ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            _screenUtils.setWidgetHeight(55)),
                                        child: new Image.network(
                                          _userViewDetailData.avatar,
                                          width:
                                              _screenUtils.setWidgetHeight(76),
                                          height:
                                              _screenUtils.setWidgetHeight(76),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      bottom: _screenUtils.setWidgetHeight(52),
                                      left: _screenUtils.setWidgetWidth(20),
                                    ),
                                    new Positioned(
                                      child: new Container(
                                        padding: EdgeInsets.only(
                                            top:
                                                _screenUtils.setWidgetHeight(3),
                                            bottom:
                                                _screenUtils.setWidgetHeight(3),
                                            left:
                                                _screenUtils.setWidgetWidth(10),
                                            right: _screenUtils
                                                .setWidgetWidth(10)),
                                        child: new Text(
                                          "ID ${_userViewDetailData.createTime.replaceAll("-", "").replaceAll(":", "").replaceAll(" ", "").substring(5, 8) + _userViewDetailData.username.substring(0, 6)}",
                                          style: new TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  _screenUtils.setFontSize(12)),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xfff1f3f3),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(0),
                                          ),
                                        ),
                                      ),
                                      bottom: _screenUtils.setWidgetHeight(10),
                                      left: 0,
                                    ),
                                  ],
                                ),
                                new Container(
                                  color: Color(0xfffafafa),
                                  height: _screenUtils.setWidgetHeight(8),
                                ),
                                new Container(
                                  padding: EdgeInsets.only(
                                      top: _screenUtils.setWidgetHeight(9),
                                      bottom: _screenUtils.setWidgetHeight(14),
                                      left: _screenUtils.setWidgetWidth(14)),
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(
                                            top: _screenUtils
                                                .setWidgetHeight(12),
                                            bottom: _screenUtils
                                                .setWidgetHeight(9)),
                                        child: new Text(
                                          "个人简介",
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  _screenUtils.setFontSize(19),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      new Container(
                                        padding: EdgeInsets.only(
                                            top:
                                                _screenUtils.setWidgetHeight(4),
                                            bottom: _screenUtils
                                                .setWidgetHeight(5)),
                                        child: new Text(
                                          _userViewDetailData.signature,
                                          style: new TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                new Container(
                                  color: Color(0xfffafafa),
                                  height: _screenUtils.setWidgetHeight(8),
                                ),
                                new Container(
                                  child: new GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Navigator.push(context,
                                          new MaterialPageRoute(builder: (_) {
                                        return new UserPostPostIdPage(userId: widget.userId,);
                                      }));
                                    },
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          alignment: Alignment.centerLeft,
                                          height:
                                              _screenUtils.setWidgetHeight(65),
                                          color: Colors.white,
                                          child: new RightListTitle(
                                            title:
                                                "TA的动态 ( ${_userViewDetailData.postCount} )",
                                            value: "",
                                            onTap: () {},
                                          ),
                                        ),
                                        new Container(
                                          padding: EdgeInsets.only(
                                              left: _screenUtils
                                                  .setWidgetWidth(15),
                                              bottom: _screenUtils
                                                  .setWidgetHeight(15)),
                                          child: new Row(
                                            children: <Widget>[
                                              new Image.network(
                                                _userViewDetailData
                                                    .postList.picture,
                                                width: _screenUtils
                                                    .setWidgetHeight(100),
                                                fit: BoxFit.cover,
                                                height: _screenUtils
                                                    .setWidgetHeight(100),
                                              ),
                                              new Expanded(
                                                  child: new Container(
                                                height: _screenUtils
                                                    .setWidgetHeight(100),
                                                padding: EdgeInsets.only(
                                                    left: _screenUtils
                                                        .setWidgetWidth(8)),
                                                alignment: Alignment.topLeft,
                                                child: new Text(
                                                  Base642Text.decodeBase64(
                                                      _userViewDetailData
                                                          .postList
                                                          .postContent),
                                                  style: new TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: _screenUtils
                                                          .setFontSize(16)),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                new Container(
                                  color: Color(0xfffafafa),
                                  height: _screenUtils.setWidgetHeight(8),
                                ),
                                new Container(
                                  child: new Column(
                                    children: <Widget>[
                                      new RightListTitle(
                                        value: _userViewDetailData.school,
                                        title: "所在学校",
                                        onTap: () {},
                                      ),
                                      new RightListTitle(
                                        value: _userViewDetailData.major,
                                        title: "专业",
                                        onTap: () {},
                                      ),
                                      new RightListTitle(
                                        value: _userViewDetailData.username,
                                        title: "联系方式",
                                        onTap: () {},
                                      ),
                                      new RightListTitle(
                                        value: _userViewDetailData.currentCity,
                                        title: "所在城市",
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                                new Container(
                                  color: Color(0xfffafafa),
                                  height: _screenUtils.setWidgetHeight(10),
                                ),
                                new Container(
                                  padding: EdgeInsets.only(
                                      top: _screenUtils.setWidgetHeight(9),
                                      bottom: _screenUtils.setWidgetHeight(14),
                                      left: _screenUtils.setWidgetWidth(14)),
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(
                                            bottom: _screenUtils
                                                .setWidgetHeight(10)),
                                        child: new Text(
                                          "照片墙",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                      new GridView.builder(
                                        shrinkWrap: true,
                                        //增加
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 1,
                                          mainAxisSpacing: 1,
                                        ),
                                        itemBuilder: (BuildContext context,
                                            int position) {
                                          return new GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  new MaterialPageRoute(
                                                      builder: (_) {
                                                return new PhotoGalleryPage(
                                                  index: position,
                                                  photoList: _userViewDetailData
                                                      .pictureWal,
                                                );
                                              }));
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(2),
                                              child: new ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        _screenUtils
                                                            .setWidgetWidth(4)),
                                                child: new Image.network(
                                                  _userViewDetailData
                                                      .pictureWal[position],
                                                  fit: BoxFit.cover,
                                                  height: _screenUtils
                                                      .setWidgetHeight(
                                                          d.toInt()),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: _userViewDetailData
                                            .pictureWal.length,
                                        physics:
                                            new NeverScrollableScrollPhysics(),
                                      )
                                    ],
                                  ),
                                  color: Colors.white,
                                )
                              ],
                            ))),
                    Opacity(
                      opacity: alphaAppBar,
                      child: Container(
                        height: _screenUtils.setWidgetHeight(90),
                        decoration: BoxDecoration(color: Colors.white),
                        child: new AppBar(
                          leading: new IconButton(
                              icon: new Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          elevation: 0.5,
                          iconTheme: new IconThemeData(color: Colors.black),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  ],
                )),
            bottomNavigationBar: new Container(
              height: _screenUtils.setWidgetHeight(50),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                      child: new GestureDetector(
                    child: new Container(
                      alignment: Alignment.center,
                      color: Color(0xff1fb5c6),
                      child: new Text("私聊",
                          style: new TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _screenUtils.setFontSize(15))),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (_) {
                        return SingleConversationPage(
                          username:Base642Text.decodeBase64( _userViewDetailData.nickname),
                          avatar: _userViewDetailData.avatar,
                          userId: _userViewDetailData.username,
                        );
                      }));
                    },
                  )),
                  new Expanded(
                      child: _userViewDetailData.isObserve == 1
                          ? new Container(
                              alignment: Alignment.center,
                              color: Color(0xffb6b6b6),
                              child: new Text("已关注",
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: _screenUtils.setFontSize(15))),
                            )
                          : new GestureDetector(
                              onTap: () {
                                submitUserObserve();
                              },
                              child: new Container(
                                alignment: Alignment.center,
                                color: Color(0xff00caa4),
                                child: new Text("关注",
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            _screenUtils.setFontSize(15))),
                              ),
                            )),
                ],
              ),
            ),
          );
  }

  UserViewDetailData _userViewDetailData;

  Future submitUserObserve() async {
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().post(Api.SUBMIT_USER_OBSERVE,
        data: {"userId": widget.userId, "id": spUtil.getInt("id")});
    var baseResponseEntity = BaseResponseEntity.fromJson(json.decode(response));
    if (baseResponseEntity.code == 200) {
      setState(() {
        _userViewDetailData.isObserve = 1;
      });
    } else {
      _userViewDetailData.isObserve = 0;
    }
  }
}

class UserPostPostIdPage extends StatefulWidget {
  String userId;

  UserPostPostIdPage({this.userId}) : super();

  @override
  _UserPostPostIdPageState createState() => _UserPostPostIdPageState();
}

class _UserPostPostIdPageState extends State<UserPostPostIdPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    getUserPostByUserId();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }
  ScreenUtils screenUtil=new ScreenUtils();
  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "用户发帖"),
      body: new Container(
        child: EasyRefresh(
          header: ClassicalHeader(
              enableInfiniteRefresh: false,
              refreshText: "正在刷新...",
              completeDuration: Duration(milliseconds: 500),
              refreshReadyText: "下拉我刷新哦！",
              refreshingText: "还在刷新哦！",
              refreshedText: "刷新好了哦！嘻嘻",
              refreshFailedText: "刷新失败了哦！",
              noMoreText: "没有数据了",
              infoText: "",
              bgColor: Colors.white,
              infoColor: Colors.white),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1), () {
              setState(() {
                getUserPostByUserId();
              });
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              page = page + 1;
              setState(() {
                getUserPostByUserIdNextPage(page);
              });
            });
          },
          footer: new ClassicalFooter(
              loadText: "",
              completeDuration: Duration(milliseconds: 500),
              loadReadyText: "放开我啦！",
              loadingText: "努力获取数据中",
              loadedText: "加载完成了！",
              loadFailedText: "加载失败了！",
              noMoreText: "没有数据了哦！",
              infoText: "",
              bgColor: Colors.white,
              infoColor: Colors.white),
          child: getBody(),
        ),
      ),
    );
  }

  getBody() {
    if (_user_post_list.length != 0) {
      return ListView.builder(
          itemCount: _user_post_list.length,
          itemBuilder: (BuildContext context, int position) {
            return setUserPostList(_user_post_list[position]);
          });
    } else {
      // 加载菊花
      return new Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }

  List<UserPostItemData> _user_post_list = new List();
  int page = 1;

  Future getUserPostByUserId() async {
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_USER_POST_LIST_BY_USERID,
        data: {"userId":  widget.userId, "page": 1});
    var decode = json.decode(response);
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      _user_post_list = userPostItemEntity.data;
    });
  }

  Future getUserPostByUserIdNextPage(int pages) async {

    var response = await HttpUtil.getInstance().get(
        Api.QUERY_USER_POST_LIST_BY_USERID,
        data: {"userId": widget.userId, "page": pages});
    var decode = json.decode(response);
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      _user_post_list.addAll(userPostItemEntity.data);
    });
  }

  setUserPostList(UserPostItemData index) {
    print("-------------------------------------------");
    print(index.pictures.length);
    print(index.pictures.length);
    print("-------------------------------------------");
    var like_bumlb = index.like == 1
        ? "assert/imgs/detail_like_selectedx.png"
        : "assert/imgs/person_likex.png";
    int thumb_count = int.parse(index.thumbCount);
    var _picture_list = [];
    var pictures = index.pictures;
    for (var o in pictures) {
      _picture_list.add(o.postPictureUrl);
    }
    return new GestureDetector(
      child: new Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    print("--------------------------------------");
                    print(index.user.toJson());
                    print("--------------------------------------");
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return new UserDetailPage(
                          userId: index.user.id.toString());
                    }));
                  },
                  child: new Container(
                    padding: EdgeInsets.only(
                        top: screenUtil.setWidgetHeight(20),
                        left: screenUtil.setWidgetWidth(20),
                        right: screenUtil.setWidgetWidth(6)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assert/imgs/loading.gif",
                        image: "${index.user.avatar}",
                        fit: BoxFit.cover,
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(
                          top: screenUtil.setWidgetHeight(20),
                          right: screenUtil.setWidgetWidth(6)),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            "${index.user.nickname}",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenUtil.setFontSize(15)),
                          ),
                          new Text(
                            "${RelativeDateFormat.format(index.createTime)}",
                            style: new TextStyle(
                                fontSize: screenUtil.setFontSize(11),
                                color: Color(0xff9B9B9B)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            new Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: screenUtil.setFontSize(20),
                  right: screenUtil.setFontSize(20),
                  top: screenUtil.setFontSize(14),
                  bottom: screenUtil.setFontSize(10)),
              child: new Text(
                Base642Text.decodeBase64("${index.postContent}"),
                style: new TextStyle(
                  fontSize: screenUtil.setFontSize(17),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.left,
              ),
            ),
            new Container(
                child: index.postType == 1
                    ? new GridView.builder(
                  padding: EdgeInsets.only(
                      left: screenUtil.setWidgetWidth(20),
                      right: screenUtil.setWidgetWidth(20),
                      top: screenUtil.setWidgetHeight(8),
                      bottom: screenUtil.setWidgetHeight(8)),
                  physics: new NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6.0,
                    crossAxisSpacing: 6.0,
                  ),
                  itemCount: _picture_list.length,
                  itemBuilder: (BuildContext context, int indexs) {
                    return new GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: "${_picture_list[indexs]}" +
                              "?x-oss-process=style/image_press",
                          fit: BoxFit.cover,
                          width: screenUtil.setWidgetWidth(54),
                          height: screenUtil.setWidgetWidth(54),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PhotoGalleryPage(
                                    index: indexs,
                                    photoList: _picture_list,
                                  )),
                        );
                      },
                    );
                  },
                )
                    : index.pictures.length==0
                    ? new Container()
                    : new GestureDetector(
                  onTap: () {
                    print("-------------------------------------------");
                    print(index.pictures[0].height);
                    print(index.pictures[0].weight);
                    print("-------------------------------------------");
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (_) {
                          return new CommonVideoPlayer(
                            videoUrl: index.pictures[0].postPictureUrl,
                            height: index.pictures[0].height,
                            width: index.pictures[0].weight,
                          );
                        }));
                  },
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(
                            left: screenUtil.setWidgetHeight(20)),
                        alignment: Alignment.center,
                        height: screenUtil.setWidgetHeight(200),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: "${index.pictures[0].postPictureUrl}" +
                              "?x-oss-process=video/snapshot,t_5000,f_jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                            left: screenUtil.setWidgetHeight(20)),
                        height: screenUtil.setWidgetHeight(200),
                        alignment: Alignment.center,
                        child: new Image.asset(
                          "assert/imgs/video_player.png",
                          width: screenUtil.setWidgetWidth(40),
                          height: screenUtil.setWidgetHeight(40),
                        ),
                      ),
                    ],
                  ),
                )),
            new Row(
              children: <Widget>[
                new UserPostDetailList(
                  title: "分享",
                  imagePath: "assert/imgs/person_share.png",
                  onTap: () {
                    Share.share(
                        '【玩安卓Flutter版】\n https://github.com/yechaoa/wanandroid_flutter');
                  },
                ),
                new UserPostDetailList(
                  title: "评论" + index.commentCount.toString(),
                  imagePath: "assert/imgs/person_commentx.png",
                ),
                new UserPostDetailList(
                  onTap: () {
                    if (index.like == 1) {
                      return;
                    }
                    userThumb(index).then((isSuccess) {
                      print(isSuccess);
                      if (isSuccess) {
                        setState(() {
                          like_bumlb = 'assert/imgs/detail_like_selectedx.png';
                          index.like = 1;
                          index.thumbCount =
                              (int.parse(index.thumbCount) + 1).toString();
                        });
                      }
                    });
                  },
                  title: "点赞 " + thumb_count.toString(),
                  imagePath: like_bumlb,
                ),
                new Expanded(
                    child: new Container(
                        child: new Image.asset(
                          "assert/imgs/post_more.png",
                          width: screenUtil.setWidgetWidth(24),
                          height: screenUtil.setWidgetHeight(21),
                        ),
                        alignment: Alignment.centerRight))
              ],
            ),
            new Container(
              height: screenUtil.setWidgetHeight(8),
              color: Color(0xfffafafa),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            CustomRouteSlide(
                UserPostDetailItemPage(postId: "${index.id.toString()}")));
      },
    );
  }

  Future<bool> userThumb(UserPostItemData postId) async {
    var spUtil = await SpUtil.instance;
    var id = spUtil.getInt("id");

    var reponse =
    await HttpUtil.getInstance().post(Api.USER_UPDATE_BY_POST_ID, data: {
      "userId": id.toString(),
      "postId": postId.id.toString(),
      "postUserId": postId.user.id.toString()
    });
    var decode = json.decode(reponse);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code != 200) {
      ToastUtil.showCommonToast("点赞失败！");
      return false;
    } else {
      ToastUtil.showErrorToast("点赞成功");
      return true;
    }
  }
}
