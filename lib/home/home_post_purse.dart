import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/picture_preview_dialog.dart';
import 'package:sauce_app/common/user_detail_page.dart';
import 'package:sauce_app/home/home_post_item_detail.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/HttpUtil.dart';

import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/gson/user_post_item_entity.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/util/relative_time_util.dart';
import 'package:sauce_app/widget/Post_detail.dart';
import 'package:share/share.dart';

void main() {
  runApp(new MaterialApp(
    home: new HomePostPurse(),
  ));
}

class HomePostPurse extends StatefulWidget {
  @override
  _HomePostPurseState createState() => new _HomePostPurseState();
}

class _HomePostPurseState extends State<HomePostPurse>
    with AutomaticKeepAliveClientMixin {
  ScreenUtils screenUtil = new ScreenUtils();

  _HomePostPurseState();

  void getPage() async {
    SpUtil sp = await SpUtil.getInstance();
    int value = sp.getInt("page");
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
    sp.putInt("page", (_page + 1));
    setState(() {
      userPostItem.clear();
      getPage();
    });
  }

  Future getPrePagePost() async {
    SpUtil sp = await SpUtil.getInstance();
    sp.putInt("page", (_page + 1));
    setState(() {
      getPrePageData();
    });
  }

  int _page;

  Future getPrePageData() async {
    SpUtil sp = await SpUtil.getInstance();
    int value = sp.getInt("page");
    _page = value == null ? 1 : value;

    var response = await HttpUtil.getInstance().get(Api.QUERY_POST_LIST,
        data: {"page": _page.toString(), "userId": "1"});
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
      return CupertinoActivityIndicator();
    }
  }

  void getPurseDataList(int page) async {
    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_POST_LIST, data: {"page": page, "userId": "1"});
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
    return new GestureDetector(
      child: new Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new GestureDetector(
                    onTap: (){
                      new CustomRouteSlide(new UserDetailPage(userId:index.user.uid.toString()));
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
                        itemCount: index.pictures.length,
                        itemBuilder: (BuildContext context, int indexs) {
                          return new GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage.assetNetwork(
                                placeholder: "assert/imgs/loading.gif",
                                image: "${index.pictures[indexs]}" +
                                    "?x-oss-process=style/image_press",
                                fit: BoxFit.cover,
                                width: 54,
                                height: 54,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PhotoGalleryPage(
                                          index: indexs,
                                          photoList: index.pictures,
                                        )),
                              );
                            },
                          );
                        },
                      )
                    : new Stack(
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(
                                left: screenUtil.setWidgetHeight(20)),
                            alignment: Alignment.centerLeft,
                            height: screenUtil.setWidgetHeight(200),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assert/imgs/loading.gif",
                              image: "${index.pictures[0]}" +
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
                      )),
            new Row(
              children: <Widget>[
                new UserPostDetailList(
                  title: "分享",
                  imagePath: "assert/imgs/person_share.png",
                  onTap: () {
                    Share.share( '【玩安卓Flutter版】\n https://github.com/yechaoa/wanandroid_flutter');
                  },
                ),
                new UserPostDetailList(
                  title: "评论" + index.commentCount.toString(),
                  imagePath: "assert/imgs/person_commentx.png",
                ),
                new UserPostDetailList(
                  title: "点赞 " + index.thumbCount.toString(),
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
      onTap: () {
        Navigator.push(context,
            CustomRouteSlide(UserPostDetailItemPage(userId: "${index.id.toString()}")));
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
