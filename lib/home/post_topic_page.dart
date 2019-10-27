import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/common_vide_player.dart';
import 'package:sauce_app/common/picture_preview_dialog.dart';
import 'package:sauce_app/common/user_detail_page.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/topic_detail_entity.dart';
import 'package:sauce_app/gson/user_post_item_entity.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/util/relative_time_util.dart';
import 'package:sauce_app/widget/Post_detail.dart';
import 'package:share/share.dart';

import 'home_post_item_detail.dart';

const APPBAE_SCROLL_OFFSET = 100;

class TopicPostPage extends StatefulWidget {
  String topicId;
  String topicPicture;
  String topicName ;

  TopicPostPage({Key key, this.topicId, this.topicPicture, this.topicName})
      : super();

  @override
  _TopicPostPageState createState() => _TopicPostPageState();
}

class _TopicPostPageState extends State<TopicPostPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getTopicDetail();
    getNextPagePost(1);
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils screenUtil = new ScreenUtils();

  double alphaAppBar = 0;

  Future join_topic() async {
    var instance = await SpUtil.getInstance();
    var response =
        await HttpUtil.getInstance().post(Api.JOIN_TOPIC_BY_USER_ID, data: {
      "userId": instance.getInt("id"),
      "avatar": instance.getString("avatar"),
      "topicId": widget.topicId,
    });
    var baseResponseEntity = BaseResponseEntity.fromJson(json.decode(response));
    if (baseResponseEntity.code == 200) {
      setState(() {
        _topicDetailData.joinCount = _topicDetailData.joinCount + 1;
        _topicDetailData.isObserve = true;
      });
    } else {}
  }

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
    screenUtil.initUtil(context);
    return Scaffold(
      body: new Container(
        color: Colors.white,
        child: _topicDetailData == null
            ? new Container(
                child: new Center(
                  child: new CupertinoActivityIndicator(
                    radius: 14,
                  ),
                ),
              )
            : Stack(
                children: <Widget>[
                  MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                          return false;
                        },
                        child: new EasyRefresh(
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
                              await Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  getPagePost();
                                });
                              });
                            },
                            onLoad: () async {
                              await Future.delayed(Duration(seconds: 2), () {
                                setState(() {
                                  page = page + 1;
                                  getNextPagePost(page);
                                });
                              });
                            },
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Stack(
                                  children: <Widget>[
                                    new Column(
                                      children: <Widget>[
                                        new Container(
                                            height:
                                                screenUtil.setWidgetHeight(160),
                                            color: Colors.black54,
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  _topicDetailData
                                                      .topic.topicPicUrl,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  fit: BoxFit.cover,
                                                  height: screenUtil
                                                      .setWidgetHeight(160),
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
                                                    height: screenUtil
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
                                                    left: screenUtil
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
                                                          _topicDetailData
                                                              .topic.topicName,
                                                          style: new TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: screenUtil
                                                                  .setFontSize(
                                                                      26)),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            )),
                                        new Container(
                                          padding: EdgeInsets.only(
                                              left: screenUtil
                                                  .setWidgetWidth(110),
                                              top: screenUtil
                                                  .setWidgetHeight(15)),
                                          height:
                                              screenUtil.setWidgetHeight(80),
                                          color: Colors.white,
                                          child: new Row(
                                            children: <Widget>[
                                              new Column(
                                                children: <Widget>[
                                                  new RichText(
                                                      text: new TextSpan(
                                                          children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                                _topicDetailData
                                                                    .joinCount
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: screenUtil
                                                                    .setFontSize(
                                                                        23),
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        TextSpan(
                                                            text: "人 已加入",
                                                            style: TextStyle(
                                                                fontSize: screenUtil
                                                                    .setFontSize(
                                                                        15),
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                      ]))
                                                ],
                                              ),
                                              new Container(
                                                width: screenUtil
                                                    .setWidgetWidth(15),
                                              ),
                                              new Expanded(
                                                  child: new GestureDetector(
                                                onTap: () {
                                                  if (_topicDetailData
                                                      .isObserve) {
                                                    return;
                                                  } else {
                                                    join_topic();
                                                  }
                                                },
                                                child: new Container(
                                                  padding: EdgeInsets.only(
                                                      right: screenUtil
                                                          .setWidgetWidth(15)),
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: new ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            screenUtil
                                                                .setWidgetWidth(
                                                                    35))),
                                                    child: new Container(
                                                      padding: EdgeInsets.only(
                                                          left: screenUtil
                                                              .setWidgetWidth(
                                                                  15),
                                                          right: screenUtil
                                                              .setWidgetWidth(
                                                                  15),
                                                          bottom: screenUtil
                                                              .setWidgetHeight(
                                                                  5),
                                                          top: screenUtil
                                                              .setWidgetHeight(
                                                                  5)),
                                                      color: _topicDetailData
                                                              .isObserve
                                                          ? Color(0xffb6b6b6)
                                                          : Color(0xff4ddfa9),
                                                      child: new Text(
                                                        _topicDetailData
                                                                .isObserve
                                                            ? "已加入"
                                                            : "+ 加入",
                                                        style: new TextStyle(
                                                            color: Colors.white,
                                                            fontSize: screenUtil
                                                                .setFontSize(
                                                                    15)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    new Positioned(
                                      child: new ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            screenUtil.setWidgetHeight(55)),
                                        child: new Image.network(
                                          _topicDetailData.topic.topicPicUrl,
                                          width: screenUtil.setWidgetHeight(76),
                                          height:
                                              screenUtil.setWidgetHeight(76),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      bottom: screenUtil.setWidgetHeight(52),
                                      left: screenUtil.setWidgetWidth(20),
                                    ),
                                  ],
                                ),
                                new Container(
                                  color: Color(0xfffafafa),
                                  height: screenUtil.setWidgetHeight(8),
                                ),
                                new Container(
                                  padding: EdgeInsets.only(
                                      top: screenUtil.setWidgetHeight(7),
                                      bottom: screenUtil.setWidgetHeight(7),
                                      left: screenUtil.setWidgetWidth(14)),
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(
                                            top: screenUtil.setWidgetHeight(6),
                                            bottom:
                                                screenUtil.setWidgetHeight(6)),
                                        child: new Text(
                                          "话题简介",
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  screenUtil.setFontSize(16),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      new Container(
                                        padding: EdgeInsets.only(
                                            top: screenUtil.setWidgetHeight(4),
                                            bottom:
                                                screenUtil.setWidgetHeight(5)),
                                        child: new Text(
                                          _topicDetailData.topic.topicDesc,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: new TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                new Container(
                                  color: Color(0xfffafafa),
                                  height: screenUtil.setWidgetHeight(8),
                                ),
                                new Container(
                                  padding: EdgeInsets.only(
                                      top: screenUtil.setWidgetHeight(7),
                                      bottom: screenUtil.setWidgetHeight(7),
                                      left: screenUtil.setWidgetWidth(14)),
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(
                                            top: screenUtil.setWidgetHeight(5),
                                            bottom:
                                                screenUtil.setWidgetHeight(5)),
                                        child: new Text(
                                          "加入用户",
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  screenUtil.setFontSize(16),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      new Container(
                                        padding: EdgeInsets.only(
                                            top: screenUtil.setWidgetHeight(4),
                                            bottom:
                                                screenUtil.setWidgetHeight(5)),
                                        child: Container(
                                            height:
                                                screenUtil.setWidgetHeight(30),
                                            alignment: Alignment.topRight,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: _getImageStackWidth(
                                                      _topicDetailData
                                                          .userList.length),
                                                  height: double.infinity,
                                                  child: Stack(
                                                    children: _getStackItems(
                                                        _topicDetailData
                                                            .userList.length),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                new Container(
                                  color: Color(0xfffafafa),
                                  height: screenUtil.setWidgetHeight(8),
                                ),
                                new Container(
                                  padding: EdgeInsets.only(
                                      top: screenUtil.setWidgetHeight(7),
                                      bottom: screenUtil.setWidgetHeight(7),
                                      left: screenUtil.setWidgetWidth(14)),
                                  child: new Container(
                                    padding: EdgeInsets.only(
                                        top: screenUtil.setWidgetHeight(5),
                                        bottom: screenUtil.setWidgetHeight(5)),
                                    child: new Text(
                                      "帖子",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: screenUtil.setFontSize(16),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                new Container(
                                  child: _user_post_list.length != 0
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              new NeverScrollableScrollPhysics(),
                                          itemCount: _user_post_list.length,
                                          itemBuilder: (BuildContext context,
                                              int position) {
                                            return setUserPostList(
                                                _user_post_list[position]);
                                          })
                                      :
                                      // 加载菊花
                                      new Container(
                                          child: new Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        ),
                                ),
                              ],
                            )),
                      )),
                  Opacity(
                    opacity: alphaAppBar,
                    child: Container(
                      height: screenUtil.setWidgetHeight(90),
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
              ),
      ),
    );
  }

  final double offsetW = 20.0;

  double _getImageStackWidth(int imageNumber) {
    return offsetW * (imageNumber - 1) + 28;
  }

  int page = 1;
  TopicDetailData _topicDetailData;

  Future getTopicDetail() async {
    var spUtil = await SpUtil.getInstance();
    print("==========================");
    print(spUtil.getInt("id").toString());
    print("==========================");
    var httpUtil = await HttpUtil.getInstance().get(Api.QUERY_TOPIC_DETAIL,
        data: {"topicId": widget.topicId, "userId": spUtil.getInt("id").toString()});
    var topicDetailData = TopicDetailEntity.fromJson(json.decode(httpUtil));
    if (topicDetailData.code == 200) {
      setState(() {
        _topicDetailData = topicDetailData.data;
      });
    } else {
      ToastUtil.showCommonToast("加载错误");
    }
  }

  List<Widget> _getStackItems(int count) {
    List<Widget> _list = new List<Widget>();
    for (var i = 0; i < count; i++) {
      double off = 20.0 * i;
      _list.add(Positioned(
        left: off,
        child: new GestureDetector(
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (_) {
              return new UserDetailPage(
                userId: _topicDetailData.userList[i].userId.toString(),
              );
            }));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            child: Image.network(
              _topicDetailData.userList[i].avatar,
              width: 28,
              height: 28,
            ),
          ),
        ),
      ));
    }
    return _list;
  }

  List<UserPostItemData> _user_post_list = new List();

  Future getNextPagePost(int page) async {
//    QUERY_POST_BY_TOPIC_ID
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(Api.QUERY_POST_BY_TOPIC_ID,
        data: {
          "page": page,
          "userId": spUtil.getInt("id").toString(),
          "topicId": widget.topicId
        });
    print("-------------------postType-------------------");
    print(spUtil.getInt("id").toString());
    var decode = json.decode(response.toString());
    print("-------------------postType-------------------");
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      _user_post_list.addAll(userPostItemEntity.data);
    });
  }

  Future getPagePost() async {
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(Api.QUERY_POST_BY_TOPIC_ID,
        data: {
          "page": "1",
          "userId": spUtil.getInt("id").toString(),
          "topicId": widget.topicId
        });
    print("-------------------postType-------------------");
    var decode = json.decode(response.toString());
    print("-------------------postType-------------------");
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      _user_post_list = userPostItemEntity.data;
    });
  }

  Widget setUserPostList(UserPostItemData index) {
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
                                    builder: (context) => PhotoGalleryPage(
                                          index: indexs,
                                          photoList: _picture_list,
                                        )),
                              );
                            },
                          );
                        },
                      )
                    : index.pictures.length == 0
                        ? new Container()
                        : new GestureDetector(
                            onTap: () {
                              print(
                                  "-------------------------------------------");
                              print(index.pictures[0].height);
                              print(index.pictures[0].weight);
                              print(
                                  "-------------------------------------------");
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
            new GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return new TopicPostPage(
                    topicPicture: index.topicPicUrl,
                    topicId: index.topicId.toString(),
                    topicName: index.topicName,
                  );
                }));
              },
              child: new Container(
                margin: EdgeInsets.only(
                  left: screenUtil.setWidgetWidth(15),
                  top: screenUtil.setWidgetHeight(6),
                ),
                alignment: Alignment.centerLeft,
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  child: new Container(
                    padding: EdgeInsets.only(
                        left: screenUtil.setWidgetWidth(4),
                        right: screenUtil.setWidgetWidth(4),
                        top: screenUtil.setWidgetHeight(2),
                        bottom: screenUtil.setWidgetHeight(2)),
                    color: Color(0xff4ddfa9),
                    child: new Text(
                      "${index.topicName} | # ",
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
