import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/picture_preview_dialog.dart';
import 'package:sauce_app/common/user_detail_page.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/around_user_entity.dart';
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

class _HomePostLocalState extends State<HomePostLocal>
    with AutomaticKeepAliveClientMixin {
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
    SpUtil spUtil = await SpUtil.getInstance();
    int value = spUtil.getInt("local_page");
    _page = value == null ? 1 : value;
    var userId = spUtil.getInt("id");
    var response =
    await HttpUtil.getInstance().get(Api.AROUND_USER_LIST, data: {
      "page": _page.toString(),
      "userId": spUtil.getInt("id").toString(),
      "latitude": spUtil.getString("latitude"),
      "longitude": spUtil.getString("longitude"),
      "city": spUtil.getString("city")
    });
    var decode = json.decode(response.toString());
    var userPostItemEntity = AroundUserEntity.fromJson(decode);

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
  List<AroundUserData> userPostItem = List();

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
    var response =
        await HttpUtil.getInstance().get(Api.AROUND_USER_LIST, data: {
      "page": "1",
      "userId": spUtil.getInt("id").toString(),
      "latitude": spUtil.getString("latitude"),
      "longitude": spUtil.getString("longitude"),
      "city": spUtil.getString("city")
    });
    print("-------------------postType-------------------");
    var decode = json.decode(response.toString());
    print("-------------------postType-------------------");
    var userPostItemEntity = AroundUserEntity.fromJson(decode);
    setState(() {
      userPostItem = userPostItemEntity.data;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  setUserPostList(AroundUserData index) {
    return new GestureDetector(
      child: new Container(
        padding: EdgeInsets.only(
            left: screenUtil.setWidgetWidth(4),
            top: screenUtil.setWidgetHeight(8),
            bottom: screenUtil.setWidgetHeight(8),
            right: screenUtil.setWidgetWidth(4)),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            new Stack(
              children: <Widget>[new Row(
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: new FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: "${index.avatar}",
                          fit: BoxFit.cover,
                          width: screenUtil.setWidgetHeight(64),
                          height: screenUtil.setWidgetHeight(65),
                        ),
                      ),
                      new Container(
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          border: new Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(screenUtil.setWidgetHeight(16))),
                        ),
                        child: new Image.asset(
                          "assert/imgs/around_user_online.png",
                          width: screenUtil.setWidgetWidth(13),
                          height: screenUtil.setWidgetHeight(13),
                        ),
                      )
                    ],
                  ),
                  new Expanded(child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(left: screenUtil.setWidgetWidth(5)),
                        child:    new Text(Base642Text.decodeBase64(index.nickname),style: new TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenUtil.setFontSize(16)
                        ),),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 6,left: screenUtil.setWidgetWidth(5)),
                        width: screenUtil.setWidgetWidth(34),
                        child: new ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child:new Container(
                            padding: EdgeInsets.only(right:3,left: 3,top: 1,bottom: 1),
                            color:index.sex=="1"? Color(0xff49d4ea): Color(0xfffe78b7),
                            child:  new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Image.asset(index.sex=="1"?"assert/imgs/ic_small_boy.png":"assert/imgs/ic_small_girll.png",
                                  width: screenUtil.setWidgetWidth(10),
                                  height: screenUtil.setWidgetHeight(10),),
                                new Text(" "+index.age.toString(),style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: screenUtil.setFontSize(10),
                                ),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: screenUtil.setWidgetWidth(5),
                            top: screenUtil.setWidgetWidth(3)),
                        child: new Text(index.signature,maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: new TextStyle(color: Colors.grey,fontSize: screenUtil.setFontSize(12)),),
                      )
                    ],
                  ))
                ],
              ),
             new Positioned(child:  new Text(index.distance,style: new TextStyle(
                 color: Colors.grey,
                 fontSize: 14
             ),),right: 9,)],
            ),
            new Container(
              margin: EdgeInsets.only(top: 7),
              color: Color(0xfffafafa),
              height: 2,
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
