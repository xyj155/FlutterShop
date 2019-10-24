import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/picture_preview_dialog.dart';
import 'package:sauce_app/common/user_detail_page.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/home/home_post_item_detail.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/HttpUtil.dart';

import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/gson/user_post_item_entity.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/util/event_bus.dart';
import 'package:sauce_app/util/relative_time_util.dart';
import 'package:sauce_app/widget/Post_detail.dart';
import 'package:share/share.dart';

import '../common/common_vide_player.dart';


class HomePostLocal extends StatefulWidget {
  @override
  _HomePostLocalState createState() => new _HomePostLocalState();
}

class _HomePostLocalState extends State<HomePostLocal> with AutomaticKeepAliveClientMixin {
  ScreenUtils screenUtil = new ScreenUtils();


  void getPage() async {
    SpUtil sp = await SpUtil.getInstance();
    int value = sp.getInt("local_page");
    setState(() {
      _page = value == null ? 1 : value;
      print("-------------------page-------------------");
      print(value);
      print("-------------------page-------------------");
      getPurseDataList(_page);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPage();
  }

  Future getNextPagePost() async {
    SpUtil sp = await SpUtil.getInstance();
    sp.putInt("local_page", (_page + 1));
    setState(() {
      userPostItem.clear();
      getPage();
    });
  }

  Future getPrePagePost() async {
    SpUtil sp = await SpUtil.getInstance();
    sp.putInt("local_page", (_page + 1));
    setState(() {
      getPrePageData();
    });
  }

  int _page;

  Future getPrePageData() async {
    SpUtil sp = await SpUtil.getInstance();
    int value = sp.getInt("local_page");
    _page = value == null ? 1 : value;
    var userId = sp.getInt("id");
    var response = await HttpUtil.getInstance().get(Api.QUERY_LOCATION_USER_POST,
        data: {"page": _page.toString(), "userId": userId.toString()});
    var decode = json.decode(response.toString());
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);

    setState(() {
      userPostItem.addAll(userPostItemEntity.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);

    return new Container(
      margin: EdgeInsets.only(top: 55),
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
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {
              getNextPagePost();
            });
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2), () {
            setState(() {
              getPrePagePost();
            });
          });
        },
        child: getBody(),
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
      ),
    );
  }

  int count = 1;
  List<UserPostItemData> userPostItem = List();

  getBody() {
    if (userPostItem.length != 0) {
      return ListView.builder(
          itemCount: userPostItem.length,
          itemBuilder: (BuildContext context, int position) {
            return setUserPostList(userPostItem[position]);
          });
    } else {
      // 加载菊花
      return new Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }

  void getPurseDataList(int page) async {
    var spUtil = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(Api.QUERY_POST_LIST,
        data: {"page": page, "userId": spUtil.getInt("id").toString()});
    print("-------------------postType-------------------");
    var decode = json.decode(response.toString());
    print("-------------------postType-------------------");
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      userPostItem = userPostItemEntity.data;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  setUserPostList(UserPostItemData index) {
    print("--------------------------");
    print(index.like);
    print("--------------------------");
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
                          image:
                          "${_picture_list[indexs]}" +
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

    var reponse = await HttpUtil.getInstance().post(Api.USER_UPDATE_BY_POST_ID,
        data: {"userId": id.toString(), "postId": postId.id.toString()});
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}