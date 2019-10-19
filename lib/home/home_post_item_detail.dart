import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/picture_preview_dialog.dart';
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
import 'package:sauce_app/widget/Post_detail.dart';
import 'package:share/share.dart';

import 'dart:ui' as ui;

// ignore: must_be_immutable
class UserPostDetailItemPage extends StatefulWidget {
  String userId;

  UserPostDetailItemPage({Key key, this.userId}) : super(key: key);

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
        data: {"postId": widget.userId.toString(), "userId": spUtil.getInt("id").toString()});
//        data: {"postId":widget.userId.toString(), "userId":spUtil.getInt("id").toString() });
    print(response);
    var decode = json.decode(response.toString());
    var userPostItemEntity = UserPostItemDetailEntity.fromJson(decode);
    setState(() {
      userPostItem = userPostItemEntity.data;
    });
  }

  List<PostCommentListData> _comment_list = new List();
  int page = 1;

  Future getPostCommentByPostId(int page) async {
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_POST_COMMENT_BY_ID,
        data: {"postId": widget.userId.toString(), "page": page.toString()});
//        data: {"postId": widget.userId.toString(), "page": page.toString()});
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
        data: {"postId": widget.userId.toString(), "page": page.toString()});
    if (response != null) {
      var res = json.decode(response);
      var postCommentListEntity = PostCommentListEntity.fromJson(res);
      if (postCommentListEntity.code == 200) {
        setState(() {
          _comment_list.addAll(postCommentListEntity.data);
        });
      }else{
        ToastUtil.showCommonToast("没有更多数据了！");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageData();
    getPostCommentByPostId(page);
  }

  ScrollController _scrollController = new ScrollController();
  String content = '';

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
                  radius: 14,
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
                   child:  new CustomScrollView(
                     controller: _scrollController,
                     slivers: <Widget>[
                       new SliverToBoxAdapter(
                         child: Column(
                           children: <Widget>[
                             new Row(
                               children: <Widget>[
                                 new Container(
                                   padding: EdgeInsets.only(
                                       top: screenUtil.setWidgetHeight(20),
                                       left: screenUtil.setWidgetWidth(20),
                                       right: screenUtil.setWidgetWidth(6)),
                                   child: ClipRRect(
                                     borderRadius: BorderRadius.circular(22),
                                     child: FadeInImage.assetNetwork(
                                       placeholder: "assert/imgs/loading.gif",
                                       image: "${userPostItem.user.avatar}",
                                       fit: BoxFit.cover,
                                       width: 44,
                                       height: 44,
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
                                         crossAxisAlignment:
                                         CrossAxisAlignment.start,
                                         mainAxisAlignment:
                                         MainAxisAlignment.center,
                                         children: <Widget>[
                                           new Text(
                                             "${userPostItem.user.nickname}",
                                             style: new TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize:
                                                 screenUtil.setFontSize(15)),
                                           ),
                                           new Text(
                                             "${RelativeDateFormat.format(userPostItem.createTime)}",
                                             style: new TextStyle(
                                                 fontSize:
                                                 screenUtil.setFontSize(11),
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
                                   itemCount: userPostItem.pictures.length,
                                   itemBuilder:
                                       (BuildContext context, int indexs) {
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
                                           "${userPostItem.pictures[indexs]}",
                                           fit: BoxFit.cover,
                                           width: 44,
                                           height: 44,
                                         ),
                                       ),
                                     );
                                   },
                                 )
                                     : new Container(
                                   padding: EdgeInsets.only(
                                       left: screenUtil.setWidgetWidth(20),
                                       right:
                                       screenUtil.setWidgetWidth(20)),
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
                                   imagePath: "assert/imgs/person_commentx.png",
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
                           itemBuilder: (BuildContext context, int position) {
                             return userPostCommentItem(
                                 _comment_list[position], position);
                           },
                           itemCount: _comment_list.length,
                         ),
                       )
                     ],
                   ),),
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
                                hintText: '说你想说的呗！',
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
//                          sendMsg(content);
                                submitUserPost();
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
                      "${postCommentListData.user.nickname}",
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
                (position + 1).toString() +
                    "楼    ${RelativeDateFormat.format(postCommentListData.createTime)}",
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

  Future submitUserPost() async {
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance()
        .post(Api.SUBMIT_POST_COMMENT_BY_USER_ID, data: {
      "userId": spUtil.getInt("id").toString(),
      "postId": "107074",
      "comment": content
    });
    var decode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      getPostCommentMoreByPostId(page);
      FocusScope.of(context).requestFocus(FocusNode());
      _editingController.text="";
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
