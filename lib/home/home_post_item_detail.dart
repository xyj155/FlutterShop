import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/common_vide_player.dart';
import 'package:sauce_app/common/picture_preview_dialog.dart';
import 'package:sauce_app/common/user_detail_page.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/user_post_item_detail_entity.dart';
import 'package:sauce_app/gson/post_comment_list_entity.dart';

import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';

import 'package:sauce_app/util/relative_time_util.dart';
import 'package:sauce_app/util/time_util.dart';
import 'package:sauce_app/util/user_util.dart';
import 'package:sauce_app/widget/Post_detail.dart';
import 'package:share/share.dart';

import 'dart:ui' as ui;

class UserPostDetailItemPage extends StatefulWidget {
  String postId;

  UserPostDetailItemPage({Key key, this.postId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _HomePostDetailItemState();
  }
}

class _HomePostDetailItemState extends State<UserPostDetailItemPage> {
  ScreenUtils screenUtil = new ScreenUtils();
  UserPostItemDetailData userPostItem;

  TextEditingController _editingController = new TextEditingController();

  void getPageData() async {
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(Api.QUERY_POST_BY_POSTID,
        data: {
          "postId": widget.postId.toString(),
          "userId": spUtil.getInt("id").toString()
        });
    print("-------------------------------------------------");
    print(widget.postId.toString());
    print("-------------------------------------------------");
    UserUtil.submitUserViewHistory(widget.postId.toString());
    print(response);
    var decode = json.decode(response.toString());
    var userPostItemEntity = UserPostItemDetailEntity.fromJson(decode);
    setState(() {
      userPostItem = userPostItemEntity.data;
      _post_userId = userPostItemEntity.data.user.id.toString();
    });
  }

  List<PostCommentListData> _comment_list = new List();
  int page = 1;

  Future getPostCommentByPostId(int page) async {
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_POST_COMMENT_BY_ID,
        data: {"postId": widget.postId.toString(), "page": page.toString()});
    if (response != null) {
      var res = json.decode(response);
      var postCommentListEntity = PostCommentListEntity.fromJson(res);
      if (postCommentListEntity.code == 200) {
        _comment_list = postCommentListEntity.data;
      }
    }
  }

  Future getPostCommentMoreByPostId(int page) async {
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_POST_COMMENT_BY_ID,
        data: {"postId": widget.postId.toString(), "page": page.toString()});
    if (response != null) {
      var res = json.decode(response);
      var postCommentListEntity = PostCommentListEntity.fromJson(res);
      if (postCommentListEntity.code == 200) {
        setState(() {
          _comment_list.addAll(postCommentListEntity.data);
        });
      } else {
        ToastUtil.showCommonToast("没有更多数据了！");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageData();
    getPostCommentByPostId(1);
  }

  ScrollController _scrollController = new ScrollController();
  String content = '';
  String _post_userId = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    screenUtil.initUtil(context);
    _editingController.addListener(() {
//      print(_editingController.text);
      content = _editingController.text;
    });
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        // 滑动到最底部了
//
//      }
//    });
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "帖子详情"),
      body: new Container(
        color: Colors.white,
        child: userPostItem == null
            ? new Center(
                child: CupertinoActivityIndicator(
                  radius: 13,
                ),
              )
            : new Stack(
                children: <Widget>[
                  new EasyRefresh(
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
                          page = 1;
                          getPageData();
//                         getNextPagePost();
                        });
                      });
                    },
                    onLoad: () async {
                      await Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          page++;
                          print("=================================");
                          print(page);
                          print("=================================");
                          getPostCommentMoreByPostId(page);
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
                    child: new CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        new SliverToBoxAdapter(
                          child: Column(
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  new GestureDetector(
                                    child: new Container(
                                      padding: EdgeInsets.only(
                                          top: screenUtil.setWidgetHeight(20),
                                          left: screenUtil.setWidgetWidth(20),
                                          right: screenUtil.setWidgetWidth(6)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(22),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assert/imgs/loading.gif",
                                          image: "${userPostItem.user.avatar}",
                                          fit: BoxFit.cover,
                                          width: screenUtil.setWidgetWidth(38),
                                          height: screenUtil.setWidgetHeight(38),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(context,
                                          new MaterialPageRoute(builder: (_) {
                                        return new UserDetailPage(
                                            userId: _post_userId);
                                      }));
                                    },
                                  ),
                                  new Column(
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(
                                            top: screenUtil.setWidgetHeight(20),
                                            right:
                                                screenUtil.setWidgetWidth(6)),
                                        child: new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Text(
                                              "${Base642Text.decodeBase64(userPostItem.user.nickname)}",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenUtil
                                                      .setFontSize(15)),
                                            ),
                                           new Container(
                                             margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(6)),
                                             child:  new Text(
                                               "${RelativeDateFormat.format(userPostItem.createTime)}",
                                               style: new TextStyle(
                                                   fontSize: screenUtil
                                                       .setFontSize(11),
                                                   color: Color(0xff9B9B9B)),
                                             ),

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
                                  Base642Text.decodeBase64(
                                      "${userPostItem.postContent}"),
                                  style: new TextStyle(
                                    fontSize: screenUtil.setFontSize(17),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              new Container(
                                  child: userPostItem.postType == 1
                                      ? new GridView.builder(
                                          padding: const EdgeInsets.all(20.0),
                                          physics:
                                              new NeverScrollableScrollPhysics(),
                                          //增加
                                          shrinkWrap: true,
                                          //增加
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 10.0,
                                          ),
                                          itemCount:
                                              userPostItem.pictures.length,
                                          itemBuilder: (BuildContext context,
                                              int indexs) {
                                            print("=====================================================================");
                                            print("${userPostItem.pictures[indexs].postPictureUrl}?x-oss-process=style/image_press");
                                            print("=====================================================================");
                                            return new GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PhotoGalleryPage(
                                                            index: indexs,
                                                            photoList:
                                                                userPostItem
                                                                    .pictures,
                                                          )),
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      "assert/imgs/loading.gif",
                                                  image:
                                                      "${userPostItem.pictures[indexs].postPictureUrl}?x-oss-process=style/image_press",
                                                  fit: BoxFit.cover,
                                                  width: 44,
                                                  height: 44,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : userPostItem.pictures.length == 0
                                          ? new Container()
                                          : new GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    new MaterialPageRoute(
                                                        builder: (_) {
                                                  return new CommonVideoPlayer(
                                                    videoUrl: userPostItem
                                                        .pictures[0]
                                                        .postPictureUrl,
                                                    height: userPostItem
                                                        .pictures[0].height,
                                                    width: userPostItem
                                                        .pictures[0].weight,
                                                  );
                                                }));
                                              },
                                              child: new Stack(
                                                children: <Widget>[
                                                  new Container(
                                                    padding: EdgeInsets.only(
                                                        left: screenUtil
                                                            .setWidgetHeight(
                                                                20)),
                                                    alignment: Alignment.center,
                                                    height: screenUtil
                                                        .setWidgetHeight(200),
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      placeholder:
                                                          "assert/imgs/loading.gif",
                                                      image: "${userPostItem.pictures[0].postPictureUrl}" +
                                                          "?x-oss-process=video/snapshot,t_5000,f_jpg",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  new Container(
                                                    padding: EdgeInsets.only(
                                                        left: screenUtil
                                                            .setWidgetHeight(
                                                                20)),
                                                    height: screenUtil
                                                        .setWidgetHeight(200),
                                                    alignment: Alignment.center,
                                                    child: new Image.asset(
                                                      "assert/imgs/video_player.png",
                                                      width: screenUtil
                                                          .setWidgetWidth(40),
                                                      height: screenUtil
                                                          .setWidgetHeight(40),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                              new Row(
                                children: <Widget>[
                                  new UserPostDetailList(
                                    onTap: () {
                                      Share.share(
                                          '【玩安卓Flutter版】\n https://github.com/yechaoa/wanandroid_flutter');
                                    },
                                    title: "分享",
                                    imagePath: "assert/imgs/person_share.png",
                                  ),
                                  new UserPostDetailList(
                                    title: "评论 ${userPostItem.commentCount}",
                                    imagePath:
                                        "assert/imgs/person_commentx.png",
                                  ),
                                  new UserPostDetailList(
                                    title: "点赞 ${userPostItem.thumbCount}",
                                    imagePath: "assert/imgs/person_likex.png",
                                  ),
                                  new Expanded(
                                      child: new Container(
                                          child: new Image.asset(
                                            "assert/imgs/post_more.png",
                                            width: 24,
                                            height: 21,
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
                        new SliverToBoxAdapter(
                          child: new Container(
                            margin: EdgeInsets.only(
                                left: screenUtil.setWidgetWidth(13),
                                top: screenUtil.setWidgetHeight(9),
                                bottom: screenUtil.setWidgetHeight(10)),
                            child: new Text(
                              "评论",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: screenUtil.setFontSize(15)),
                            ),
                          ),
                        ),
                        new SliverToBoxAdapter(
                          child: new ListView.builder(
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemBuilder: (BuildContext context, int position) {
                              return userPostCommentItem(
                                  _comment_list[position], position);
                            },
                            itemCount: _comment_list.length,
                          ),
                        )
                      ],
                    ),
                  ),
                  new Positioned(
                    bottom: 0,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: EdgeInsets.all(7),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(-2, 0),
                          blurRadius: 5,
                        ),
                      ]),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: '说点什么呗！',
                                border: InputBorder.none,
                              ),
                              controller: _editingController,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (content.isEmpty) {
                                ToastUtil.showCommonToast("你还没有输入文字哦！");
                              } else {
                                submitUserPostComment();
                              }
                            },
                            icon: Icon(
                              Icons.send,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget userPostCommentItem(
      PostCommentListData postCommentListData, int position) {
    return new Column(
      children: <Widget>[
        new Container(
          color: Colors.white,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(screenUtil.setWidgetHeight(13)),
                child: new ClipRRect(
                  child: new FadeInImage.assetNetwork(
                    width: screenUtil.setWidgetWidth(50),
                    height: screenUtil.setWidgetHeight(50),
                    placeholder: "assert/imgs/loading.gif",
                    image: postCommentListData.user.avatar,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(screenUtil.setWidgetHeight(57))),
                ),
              ),
              new Expanded(
                  child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(
                        bottom: screenUtil.setWidgetHeight(6),
                        top: screenUtil.setWidgetHeight(11)),
                    child: new Text(
                      "${Base642Text.decodeBase64(postCommentListData.user.nickname)}",
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: screenUtil.setFontSize(14),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  new Text(
                    Base642Text.decodeBase64(
                      "${postCommentListData.comment}",
                    ),
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: screenUtil.setFontSize(14)),
                  ),
                ],
              ))
            ],
          ),
        ),
        new Container(
          margin: EdgeInsets.only(
              left: screenUtil.setWidgetWidth(75),
              top: screenUtil.setWidgetHeight(6),
              bottom: screenUtil.setWidgetHeight(7)),
          child: new Row(
            children: <Widget>[
              new Text(
          "${RelativeDateFormat.format(postCommentListData.createTime)}",
                style: new TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
        new Container(
          color: Color(0xfffafafa),
          height: screenUtil.setWidgetHeight(2),
        )
      ],
    );
  }

  Future submitUserPostComment() async {
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance()
        .post(Api.SUBMIT_POST_COMMENT_BY_USER_ID, data: {
      "userId": spUtil.getInt("id").toString(),
      "postId": widget.postId.toString(),
      "postUserId": _post_userId,
      "comment": content
    });
    print("-------------------------------------------------");
    print(widget.postId.toString());
    print("-------------------------------------------------");
    var decode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      DataUtils dataUtils= DataUtils.instance;
      var today = DateTime.now();
//      getPostCommentMoreByPostId(page);
      _comment_list.add(new PostCommentListData(
        createTime:dataUtils.getFormartData(timeSamp: today.millisecondsSinceEpoch,format: "yyyy-mm-dd hh:mm:ss") ,
        comment: Base642Text.encodeBase64(content),
        userId: spUtil.getInt("id"),
        user: new PostCommentListDataUser(
          sex: spUtil.getString("avatar"),
          nickname: spUtil.getString("nickname"),
          isOnline: spUtil.getString("sex"),
          avatar: spUtil.getString("avatar"),
          id: spUtil.getInt("id")
        )
      ));
      FocusScope.of(context).requestFocus(FocusNode());
      _editingController.text = "";
      ToastUtil.showCommonToast("评论成功");
    } else {
      ToastUtil.showErrorToast("评论失败");
    }
  }

  @override
  void dispose() {
//    _videoPlayerController2.dispose();
//    _videoPlayerController2.pause();
    super.dispose();
  }
}
