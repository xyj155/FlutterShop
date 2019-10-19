import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/home/home_post_local.dart';
import 'package:sauce_app/home/home_post_observe.dart';
import 'package:sauce_app/home/home_post_purse.dart';

import 'package:sauce_app/home/home_user_topic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/gson/home_title_avatar_entity.dart';

import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomePageIndex();
  }
}

class HomePageIndex extends State<HomePage> with AutomaticKeepAliveClientMixin {
  var _items;
  ScreenUtils screenUtil = new ScreenUtils();
  final List<HomeTabList> myTabs = <HomeTabList>[
    new HomeTabList('推荐', new HomePostPurse()),
    new HomeTabList('附近', new HomePostLocal()),
    new HomeTabList('关注', new HomePostObserve())
  ];

  Widget _widget_menu_card(BuildContext contexts) {
    return new SliverToBoxAdapter(
      child: new Wrap(
        alignment: WrapAlignment.end,
        children: <Widget>[home_top_menu(contexts)],
      ),
    );
  }

  @override
  Widget build(BuildContext contexts) {
    screenUtil.initUtil(contexts);
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _widget_menu_card(contexts),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                child: SliverAppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  floating: false,
                  pinned: true,
                  snap: false,
                  forceElevated: innerBoxIsScrolled,
                  title: TabBar(
                    indicatorColor: Color(0xff4ddfa9),
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelStyle: new TextStyle(
                        fontSize: screenUtil.setFontSize(17),
                        fontWeight: FontWeight.bold),
                    labelStyle: new TextStyle(
                        fontSize: screenUtil.setFontSize(24),
                        fontWeight: FontWeight.bold),
                    labelColor: Colors.black,
                    unselectedLabelColor: Color(0xff707070),
                    indicatorWeight: screenUtil.setFontSize(5),
                    isScrollable: true,
                    tabs: myTabs.map((HomeTabList item) {
                      return new Tab(
                          text: item.text == null ? '错误' : item.text);
                    }).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: myTabs.map((item) {
              return item.goodList;
            }).toList(),
          ),
        ),
      ),
    );
  }

  JPush _jPush = new JPush();

  @override
  void initState() {
    super.initState();
    getTitleAvatarData();
    initJPushTag();
  }

  Future initJPushTag() async {
    var spUtil = await SpUtil.getInstance();
    _jPush.setup(
        appKey: "a96bfaaaaa323f4e0e137fb0",
        channel: "developer-default",
        debug: true);
    print("------------------------------------------");
    await _jPush.setAlias(spUtil.getString("username"));
    await _jPush.setTags(spUtil.getString("username"));
    print("------------------------------------------");
  }

  Widget home_top_menu(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: 10),
      height: screenUtil.setWidgetHeight(120),
      child: _items == null
          ? CupertinoActivityIndicator()
          : new ListView.builder(
              itemCount: _items.length,
              itemBuilder: homeTitleItemView,
              scrollDirection: Axis.horizontal),
    );
  }

  getTitleAvatarData() async {
    var response = await HttpUtil().get(Api.HOME_TITLE_AVATAR);
    print('=========================' + response);
    final body = json.decode(response.toString());
    var code = HomeTitleAvatarEntity.fromJson(body);
    if (body != null)
      setState(() {
        _items = code.data;
      });
  }

  //标题圆圈
  Widget homeTitleItemView(BuildContext context, int index) {
    HomeTitleAvatarData model = this._items[index];
    return new Container(
      child: new GestureDetector(
        child: new Column(
          children: <Widget>[
            new Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: FadeInImage.assetNetwork(
                  placeholder: "assert/imgs/loading.gif",
                  image: "${model.activePicture}",
                  fit: BoxFit.cover,
                  width: screenUtil.setWidgetWidth(56),
                  height: screenUtil.setWidgetHeight(58),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(screenUtil.setWidgetHeight(40))),
                border: new Border.all(width: 4, color: Color(0xff4ddfa9)),
              ),
            ),
            new Text(
              "${model.activeName}",
              style: new TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff000000)),
            )
          ],
        ),
        onTap: () {
          _onListItemTap(context, index);
        },
      ),
      margin: EdgeInsets.all(10),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

void _onListItemTap(
  BuildContext context,
  int index,
) {
  if (index == 0) {
    Navigator.push(context, CustomRouteSlide(UserTopicPage()));
  }
}

class HomeTabList {
  String text;
  Widget goodList;

  HomeTabList(this.text, this.goodList);
}
