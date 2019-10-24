import 'dart:convert';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/common_webview_page.dart';
import 'package:sauce_app/common/user_detail_page.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/square/square_little_shop.dart';

import 'package:sauce_app/square/food_kind/square_shop_foods_purse.dart';

import 'package:sauce_app/square/food_kind/square_shop_wear_purse.dart';
import 'package:sauce_app/square/food_kind/square_shop_live_purse.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/gson/user_item_entity.dart';
import 'package:sauce_app/gson/square_purse_title_entity.dart';
import 'package:sauce_app/gson/square_banner_entity.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/gson/business_shop_list_entity.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/util/logutil.dart';
import 'package:sauce_app/widget/common_dialog.dart';
import 'package:sauce_app/widget/page_indicator.dart';
import 'package:sauce_app/widget/progress_dialog.dart';

import 'food_kind/square_shop_all_purse.dart';
import 'food_kind/square_shop_play_purse.dart';
import 'school_activity_page.dart';
import 'shop_recharge_page.dart';
import 'square_part_time_job.dart';
import 'square_play_together.dart';

class SquarePageIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SquarePageState();
  }
}

class SquarePageState extends State<SquarePageIndex>
    with TickerProviderStateMixin {
  ScreenUtils screenUtils = new ScreenUtils();
  List<UserItemData> _user_purse_items;
  List<BusinessShopListData> _shop_list = new List();
  List<SquarePurseTitleData> _purse_title_list = new List();
  bool isLoading = true;
  Future<String> futureString;

  Future scan() async {
    futureString = new QRCodeReader()
        .setForceAutoFocus(true) // default false
        .setHandlePermissions(true) // default true
        .setExecuteAfterPermissionGranted(true) // default truefault false
        .scan();
    var spUtil = await SpUtil.getInstance();
    futureString.then((result) {
      Navigator.push(context, new MaterialPageRoute(builder: (_) {
        return new CommonWebViewPage(
            url: result + "&inviteId=" + spUtil.getInt("id").toString(),
            title: "邀请好友");
      }));
    });
  }

  TabController _tab_controller;

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Container(
      color: Colors.white,
      child: _banner_list==null?new Container(
        child: new Center(
          child: new CupertinoActivityIndicator(
            radius: screenUtils.setWidgetWidth(13),
          ),
        ),
      ):NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: new Column(
                children: <Widget>[
                  new Container(
                    color: Colors.white,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: screenUtils.setWidgetHeight(45),
                        color: Color(0xfff7f7f7),
                        padding: EdgeInsets.only(
                            left: screenUtils.setWidgetWidth(15),
                            right: screenUtils.setWidgetWidth(15)),
                        margin: EdgeInsets.only(
                            left: screenUtils.setWidgetWidth(10),
                            right: screenUtils.setWidgetWidth(10)),
                        child: new Row(
                          children: <Widget>[
                            new Image.asset(
                              "assert/imgs/ic_square_search.png",
                              width: 23,
                              height: 23,
                            ),
                            new Text(
                              "    搜索你想的帖子",
                              style: new TextStyle(
                                color: Color(0xffdbdbdb),
                              ),
                            ),
                            new Expanded(
                                child: new GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    scan();
                                  },
                                  child: new Container(
                                    child: new Image.asset(
                                      "assert/imgs/ic_square_scan.png",
                                      width: 23,
                                      height: 23,
                                    ),
                                    alignment: Alignment.centerRight,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(17)),
                  ),
                  new Container(
                    padding: EdgeInsets.only(
                        top: screenUtils.setWidgetHeight(6),
                        right: screenUtils.setWidgetWidth(5),
                        left: screenUtils.setWidgetWidth(5)),
                    height: screenUtils.setWidgetHeight(110),
                    child: _user_purse_items == null
                        ? new CupertinoActivityIndicator()
                        : new ListView.builder(
                        itemCount: _user_purse_items.length,
                        itemBuilder:
                            (BuildContext context, int position) {
                          print("===================================" +
                              String.fromCharCode(position));
                          return homeTitleItemView(context, position);
                        },
                        scrollDirection: Axis.horizontal),
                  ),
                  new Container(
                      margin: EdgeInsets.only(left: 13, right: 13),
                      width: MediaQuery.of(context).size.width,
                      height: 130.0,
                      child: Swiper(
                        pagination: new SwiperPagination(
                            alignment: Alignment.bottomCenter,
                            builder: new SwiperCustomPagination(builder:
                                (BuildContext context,
                                SwiperPluginConfig config) {
                              return new PageIndicator(
                                layout: PageIndicatorLayout.NIO,
                                size: 10.0,
                                space: 15.0,
                                count: _banner_list.length,
                                controller: config.pageController,
                              );
                            })),
                        itemBuilder: _swiperBuilder,
                        itemCount: _banner_list.length,
                        scrollDirection: Axis.horizontal,
                        autoplay: true,
                        onTap: (index) => Navigator.push(context,
                            new MaterialPageRoute(builder: (_) {
                              return new CommonWebViewPage(
                                  url: _banner_list[index].bannerUrl, title: "");
                            })),
                      )),

                  new Container(
                    margin:
                    EdgeInsets.only(top: screenUtils.setWidgetHeight(15)),
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 1,
                          child: new GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: new Column(
                              children: <Widget>[
                                new Image.asset("assert/imgs/ic_log_home.png",
                                    width: screenUtils.setWidgetWidth(30),
                                    height: screenUtils.setWidgetHeight(30)),
                                new Container(
                                  child: new Text(
                                    "店铺优惠",
                                    style: new TextStyle(
                                        fontSize: screenUtils.setFontSize(13),
                                        color: Colors.black),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: screenUtils.setWidgetHeight(8)),
                                  padding: EdgeInsets.all(
                                      screenUtils.setWidgetHeight(5)),
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (_) {
                                    return new ShopRechargeIndex();
                                  }));
                            },
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (_) {
                                    return new PartTimeJobPage();
                                  }));
                            },
                            child: new Column(
                              children: <Widget>[
                                new Image.asset(
                                    "assert/imgs/ic_partjob_home.png",
                                    width: screenUtils.setWidgetWidth(30),
                                    height: screenUtils.setWidgetHeight(30)),
                                new Container(
                                  child: new Text(
                                    "校园兼职",
                                    style: new TextStyle(
                                        fontSize: screenUtils.setFontSize(13),
                                        color: Colors.black),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: screenUtils.setWidgetHeight(8)),
                                  padding: EdgeInsets.all(
                                      screenUtils.setWidgetHeight(5)),
                                )
                              ],
                            ),
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                      new LittleShopPage()));
                            },
                            child: new Column(
                              children: <Widget>[
                                new Image.asset(
                                    "assert/imgs/ic_active_home.png",
                                    width: screenUtils.setWidgetWidth(30),
                                    height: screenUtils.setWidgetHeight(30)),
                                new Container(
                                  child: new Text(
                                    "小卖部",
                                    style: new TextStyle(
                                        fontSize: screenUtils.setFontSize(13),
                                        color: Colors.black),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: screenUtils.setWidgetHeight(8)),
                                  padding: EdgeInsets.all(
                                      screenUtils.setWidgetHeight(5)),
                                )
                              ],
                            ),
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (_) {
                                    return new SchoolActivityPage();
                                  }));
                            },
                            child: new Column(
                              children: <Widget>[
                                new Image.asset(
                                    "assert/imgs/ic_shop_home.png",
                                    width: screenUtils.setWidgetWidth(30),
                                    height: screenUtils.setWidgetHeight(30)),
                                new Container(
                                  child: new Text(
                                    "校园活动",
                                    style: new TextStyle(
                                        fontSize: screenUtils.setFontSize(13),
                                        color: Colors.black),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: screenUtils.setWidgetHeight(8)),
                                  padding: EdgeInsets.all(
                                      screenUtils.setWidgetHeight(5)),
                                )
                              ],
                            ),
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(context,
                                  new MaterialPageRoute(builder: (_) {
                                    return new SquarePlayTogetherPage();
                                  }));
                            },
                            child: new Column(
                              children: <Widget>[
                                new Image.asset(
                                    "assert/imgs/ic_game_home.png",
                                    width: screenUtils.setWidgetWidth(30),
                                    height: screenUtils.setWidgetHeight(30)),
                                new Container(
                                  child: new Text(
                                    "打游戏",
                                    style: new TextStyle(
                                        fontSize: screenUtils.setFontSize(13),
                                        color: Colors.black),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: screenUtils.setWidgetHeight(8)),
                                  padding: EdgeInsets.all(
                                      screenUtils.setWidgetHeight(5)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(7)),
                    height: screenUtils.setWidgetHeight(7),
                    color: Color(0xfffafafa),
                  ),
                  new Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        left: screenUtils.setWidgetHeight(18),
                        top: screenUtils.setWidgetHeight(8),
                        bottom: screenUtils.setWidgetHeight(8)),
                    child: new Text(
                      "最新优惠",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: screenUtils.setFontSize(17),
                          decoration: TextDecoration.none),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(
                        top: screenUtils.setWidgetHeight(6),
                        right: screenUtils.setWidgetWidth(10),
                        left: screenUtils.setWidgetWidth(10)),
                    height: screenUtils.setWidgetHeight(60),
                    child: _purse_title_list == null
                        ? new CupertinoActivityIndicator()
                        : new ListView.builder(
                      physics: new ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _purse_title_list.length,
                      itemBuilder:
                          (BuildContext context, int position) {
                        return new Container(
                          child: new Row(
                            children: <Widget>[
                              _set_purse_title(context, position),
                              new Container(
                                height: screenUtils.setWidgetHeight(60),
                                margin: EdgeInsets.only(
                                    top:
                                    screenUtils.setWidgetHeight(10),
                                    bottom: screenUtils
                                        .setWidgetHeight(10)),
                                color: Color(0xffebebeb),
                                width: screenUtils.setWidgetWidth(1),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(
                        top: screenUtils.setWidgetHeight(6),
                        right: screenUtils.setWidgetWidth(10),
                        left: screenUtils.setWidgetWidth(10)),
                    height: screenUtils.setWidgetHeight(150),
                    child: _shop_list == null
                        ? new CupertinoActivityIndicator()
                        : new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _shop_list.length,
                      itemBuilder:
                          (BuildContext context, int position) {
                        return _set_widget_location_shop(
                            context, position);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              floating: false,
              pinned: true,
              snap: false,
              forceElevated: innerBoxIsScrolled,
              title: TabBar(
                controller: _tab_controller,
                isScrollable: false,
                indicatorColor: Color(0xff4ddfa9),
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelStyle: new TextStyle(
                    fontSize: screenUtils.setFontSize(17),
                    fontWeight: FontWeight.bold),
                labelStyle: new TextStyle(
                    fontSize: screenUtils.setFontSize(17),
                    fontWeight: FontWeight.bold),
                labelColor: Colors.black,
                unselectedLabelColor: Color(0xff707070),
                indicatorWeight: screenUtils.setFontSize(4),
                tabs: myTabs.map((HomeTabList item) {
                  return new Tab(text: item.text == null ? '错误' : item.text);
                }).toList(),
              ),
            )
          ];
        },
        body: new Container(
//        margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(55)),
          child: TabBarView(
            controller: _tab_controller,
            children: myTabs.map((item) {
              return item.goodList;
            }).toList(),
          ),
        ),
      ),
    );
  }

  final List<HomeTabList> myTabs = <HomeTabList>[
    new HomeTabList('推荐', new SquareShopAllPage()),
    new HomeTabList(
        '吃',
        new SquareShopFoodsPage(
          param: "1",
        )),
    new HomeTabList(
        '玩',
        new SquareShopPlayPage(
          param: "2",
        )),
    new HomeTabList(
        '穿',
        new SquareShopWearPage(
          param: "3",
        )),
    new HomeTabList(
        '住',
        new SquareShopLivePage(
          param: "4",
        ))
  ];

//设置周边店铺item
  Widget _set_widget_location_shop(BuildContext context, int position) {
    return new Container(
        margin: EdgeInsets.all(screenUtils.setWidgetWidth(2)),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new ClipRRect(
                  borderRadius:
                      BorderRadius.circular(screenUtils.setWidgetWidth(3)),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assert/imgs/loading.gif",
                    image: "${_shop_list[position].businessPicture}",
                    fit: BoxFit.cover,
                    width: screenUtils.setWidgetWidth(110),
                    height: screenUtils.setWidgetHeight(86),
                  ),
                ),
                new Positioned(
                  bottom: screenUtils.setWidgetHeight(3),
                  left: screenUtils.setWidgetWidth(3),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(screenUtils.setWidgetWidth(10)),
                    child: new Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.only(
                          left: screenUtils.setWidgetWidth(4),
                          right: screenUtils.setWidgetWidth(4),
                          top: screenUtils.setWidgetHeight(2),
                          bottom: screenUtils.setWidgetHeight(2)),
                      decoration: new BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          Color(0xfffe7e23),
                          Color(0xfffe6519),
                          Color(0xfffe4e12)
                        ]),
                      ),
                      child: new Text(
                        _shop_list[position].purseTag,
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: screenUtils.setFontSize(11),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            new Container(
              width: screenUtils.setWidgetWidth(90),
              margin: EdgeInsets.only(
                  top: screenUtils.setWidgetHeight(6),
                  bottom: screenUtils.setWidgetHeight(2)),
              child: new Text(
                _shop_list[position].businessName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: screenUtils.setFontSize(15)),
              ),
            ),
            new Container(
              width: screenUtils.setWidgetWidth(90),
              child: new Text(
                _shop_list[position].businessDesc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                    fontSize: screenUtils.setFontSize(13)),
              ),
            )
          ],
        ));
  }

  int index = 0;

//设置推广信息标题和副标题
  Widget _set_purse_title(BuildContext context, int position) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print(_purse_title_list[position].id);
        setState(() {
          index = position;
        });
        getShopList(_purse_title_list[position].id.toString());
      },
      child: new Container(
        width: screenUtils.setWidgetWidth(90),
        alignment: Alignment.center,
        child: new Column(
          children: <Widget>[
            new Text(
              _purse_title_list[position].purseKind,
              style: new TextStyle(
                  fontSize: screenUtils.setFontSize(16),
                  color: index == position ? Color(0xfffc5a22) : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            new Text(
              _purse_title_list[position].subtitle,
              style: new TextStyle(
                  color: index == position ? Color(0xfffc5a22) : Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: screenUtils.setFontSize(13)),
            )
          ],
        ),
      ),
    );
  }

//获取推广标题数据
  getPurseTitle() async {
    var response =
        await HttpUtil.getInstance().get(Api.QUERY_SQUARE_PURSE_KIND);

    var decode = json.decode(response);
    var squarePurseTitleEntity = SquarePurseTitleEntity.fromJson(decode);
    if (squarePurseTitleEntity.code == 200) {
      setState(() {
        _purse_title_list = squarePurseTitleEntity.data;
        isLoading = false;
      });
    }
  }

//获取店铺数据
  void getShopList(String purseKindId) async {
    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_HOT_SHOP_DISTANCE_LIST, data: {"activeId": purseKindId});
    var response_json = json.decode(response);
    var businessShopListEntity = BusinessShopListEntity.fromJson(response_json);
    if (businessShopListEntity.code == 200) {
      setState(() {
        _shop_list = businessShopListEntity.data;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getBanner();
    getPurseUserList();
    getShopList("1");
    getPurseTitle();
    _tab_controller = new TabController(length: myTabs.length, vsync: this);
  }

//获取推荐用户
  getPurseUserList() async {
    var response = await HttpUtil().get(Api.SQUARE_PURSE_USER);
    final body = json.decode(response.toString());
    print("=====================");
    print(response.toString());
    print("=====================");
    setState(() {
      UserItemEntity code = UserItemEntity.fromJson(body);
      if (body != null) {
        _user_purse_items = code.data;
      }
    });
  }

  List<SquareBannerData> _banner_list = new List();

  getBanner() async {
    var response = await HttpUtil().get(Api.SQUARE_BANNER, data: {"type": "1"});
    final body = json.decode(response);
    var squareBannerEntity = SquareBannerEntity.fromJson(body);
    print(body);
    if (squareBannerEntity.code == 200) {
      if (body != null) {
        _banner_list = squareBannerEntity.data;
      }
    }
  }

  //轮播图
  Widget _swiperBuilder(BuildContext context, int index) {
    print("===================================");
    print(_banner_list[index].bannerPicture);
    print("===================================");
    return (new ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        _banner_list[index].bannerPicture,
        fit: BoxFit.fill,
      ),
    ));
  }

//关注用户头像
  Widget homeTitleItemView(BuildContext context, int index) {
    UserItemData model = this._user_purse_items[index];
    return new Container(
      child: new GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: new Column(
          children: <Widget>[
            new GestureDetector(
              child: new Container(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(screenUtils.setWidgetWidth(24)),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assert/imgs/loading.gif",
                    image: "${model.avatar}",
                    fit: BoxFit.cover,
                    width: screenUtils.setWidgetWidth(48),
                    height: screenUtils.setWidgetHeight(50),
                  ),
                ),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(screenUtils.setWidgetHeight(52))),
                  border: new Border.all(width: 4, color: Color(0xff4ddfa9)),
                ),
              ),
            ),
            new Container(
              width: screenUtils.setWidgetWidth(48),
              alignment: Alignment.center,
              child: new Text(
                "${model.nickname}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(color: Color(0xff000000)),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(context, new MaterialPageRoute(builder: (_){
            return new UserDetailPage(userId: model.id.toString(),);
          }));
        },
      ),
      margin: EdgeInsets.all(10),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  double get maxExtent => 55;

  @override
  double get minExtent => 55;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

