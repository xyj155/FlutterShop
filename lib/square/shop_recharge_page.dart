import 'dart:convert';

import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/common_webview_page.dart';
import 'package:sauce_app/gson/business_shop_list_entity.dart';
import 'package:sauce_app/gson/business_banner_entity.dart';
import 'package:sauce_app/gson/business_class_tags_entity.dart';
import 'package:sauce_app/gson/square_banner_entity.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

import 'package:sauce_app/widget/page_indicator.dart';
import 'package:sauce_app/widget/rating_bar.dart';

class ShopRechargeIndex extends StatefulWidget {
  @override
  _ShopRechargeIndexState createState() => _ShopRechargeIndexState();
}
//

class _ShopRechargeIndexState extends State<ShopRechargeIndex>
    with SingleTickerProviderStateMixin {
  var controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: myTabs.length,
      vsync: this, //动画效果的异步处理，默认格式，背下来即可
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  final List<HomeTabList> myTabs = <HomeTabList>[
    new HomeTabList('推荐', new ShopRechargeAllCityPage()),
    new HomeTabList('附近', new ShopRechargePage(1)),
    new HomeTabList('水果', new ShopRechargePage(1)),
    new HomeTabList('小吃快餐', new ShopRechargePage(2)),
    new HomeTabList('自助餐', new ShopRechargePage(3)),
    new HomeTabList('奶茶蛋糕', new ShopRechargePage(4)),
    new HomeTabList('家常菜', new ShopRechargePage(5)),
    new HomeTabList('薯条披萨', new ShopRechargePage(6)),
  ];

  ScreenUtils __screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    __screenUtils.initUtil(context);

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.5,
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: TabBar(
          controller: controller,
          indicatorColor: Color(0xff4ddfa9),
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelStyle: new TextStyle(
              fontSize: __screenUtils.setFontSize(15),
              fontWeight: FontWeight.bold),
          labelStyle: new TextStyle(
              fontSize: __screenUtils.setFontSize(15),
              fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          unselectedLabelColor: Color(0xff707070),
          indicatorWeight: __screenUtils.setFontSize(5),
          isScrollable: true,
          tabs: myTabs.map((HomeTabList item) {
            return new Tab(text: item.text == null ? '错误' : item.text);
          }).toList(),
        ),
      ),
      body: new Container(
        child: TabBarView(
          controller: controller, //配置控制器
          children: myTabs.map((item) {
            return item.goodList;
          }).toList(),
        ),
      ),
    );
  }
}

class ShopRechargePage extends StatefulWidget {
  int type;

  ShopRechargePage(this.type) : super();

  @override
  ShopRechargePageState createState() => new ShopRechargePageState();
}

class ShopRechargePageState extends State<ShopRechargePage> {
  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new Container(
      child: new ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          return shopItem(context, position);
        },
        itemCount: _business_list.length,
      ),
    );
  }

  Widget shopItem(BuildContext context, int position) {
    BusinessShopListData _business_shop_data = _business_list[position];
    List<String> _item_tag = _business_shop_data.shopTag.split(",");
    var color = _business_shop_data.special;
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: _screenUtils.setWidgetHeight(8)),
      margin: EdgeInsets.only(
          top: _screenUtils.setWidgetHeight(2),
          bottom: _screenUtils.setWidgetHeight(2)),
      child: new Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Container(
                color: Colors.white,
                margin:
                    EdgeInsets.only(bottom: _screenUtils.setWidgetHeight(1)),
                padding: EdgeInsets.only(
                    left: _screenUtils.setWidgetHeight(11),
                    top: _screenUtils.setWidgetHeight(11)),
                child: new Row(
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: new FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          width: _screenUtils.setWidgetWidth(80),
                          height: _screenUtils.setWidgetHeight(65),
                          placeholder: "assert/imgs/loading.gif",
                          image: _business_shop_data.businessPicture),
                    ),
                    new Container(
                      width: _screenUtils.setWidgetWidth(260),
                      padding: EdgeInsets.only(
                          left: _screenUtils.setWidgetHeight(8)),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            _business_shop_data.businessName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: _screenUtils.setFontSize(16),
                                fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            _business_shop_data.businessDesc,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                color: Colors.grey,
                                fontSize: _screenUtils.setFontSize(13)),
                          ),
                          new Container(
                            height: _screenUtils.setWidgetHeight(15),
                            child: new ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _item_tag.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext b, int position) {
                                return new Text(
                                  _item_tag[position],
                                  style: new TextStyle(
                                      color: Colors.grey,
                                      fontSize: _screenUtils.setFontSize(10)),
                                );
                              },
                            ),
                          ),
                          new RatingBar(
                            value: _business_shop_data.rankScore.toDouble(),
                            size: 15,
                            padding: 1,
                            nomalImage: 'assert/imgs/ic_ranting_unselect.png',
                            selectImage: 'assert/imgs/ic_ranting_select.png',
                            selectAble: false,
                            maxRating: 10,
                            count: 5,
                            onRatingUpdate: (String value) {},
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: EdgeInsets.only(left: _screenUtils.setWidgetWidth(95)),
                child: new ListView.builder(
                    shrinkWrap: true,
                    //解决无限高度问题
                    physics: NeverScrollableScrollPhysics(),
                    //禁用滑动事件
                    itemCount: color.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext b, int position) {
//                     print(int.parse(color[position].bgColor));
                      return new Container(
                        margin: EdgeInsets.all(_screenUtils.setWidgetHeight(2)),
                        child: new Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                              child: new Container(
                                alignment: Alignment.center,
                                width: _screenUtils.setWidgetWidth(15),
                                height: _screenUtils.setWidgetHeight(15),
                                color: hexToColor(color[position].bgColor),
                                child: new Text(
                                  color[position].tagShortName,
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: _screenUtils.setFontSize(12)),
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(
                                  left: _screenUtils.setWidgetWidth(5)),
                              child: new Text(
                                color[position].content,
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: _screenUtils.setFontSize(13)),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestShopByChildType(widget.type);
  }

   Color hexToColor(String s) {
    if (s == null ||
        s.length != 7 ||
        int.tryParse(s.substring(1, 7), radix: 16) == null) {
      s = '#999999';
    }
    return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }

  int page = 1;
  List<BusinessShopListData> _business_list = new List();

  Future requestShopByChildType(int type) async {
    var response = await HttpUtil.getInstance().getDio().get(
        Api.QUERY_SHOP_BY_CHILD_TYPE,
        queryParameters: {"typeId": type.toString(), "page": page.toString()});
    var decode = json.decode(response.toString());
    if (decode != null) {
      var businessShopListEntity = BusinessShopListEntity.fromJson(decode);
      if (businessShopListEntity.code == 200) {
        setState(() {
          _business_list = businessShopListEntity.data;
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class ShopRechargeAllCityPage extends StatefulWidget {
  @override
  ShopRechargeAllCityPageState createState() =>
      new ShopRechargeAllCityPageState();
}

class ShopRechargeAllCityPageState extends State<ShopRechargeAllCityPage>
    with AutomaticKeepAliveClientMixin {
  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new Container(
      child: new NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverToBoxAdapter(
              child: new Container(
                  margin: EdgeInsets.only(
                      left: _screenUtils.setWidgetWidth(13),
                      right: _screenUtils.setWidgetWidth(13),
                      top: _screenUtils.setWidgetHeight(8)),
                  width: MediaQuery.of(context).size.width,
                  height: _screenUtils.setWidgetHeight(130),
                  child: Swiper(
                    pagination: new SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: new SwiperCustomPagination(builder:
                            (BuildContext context, SwiperPluginConfig config) {
                          return new PageIndicator(
                            layout: PageIndicatorLayout.NIO,
                            size: 10.0,
                            space: 15.0,
                            count: _business_banner.length,
                            controller: config.pageController,
                          );
                        })),
                    itemBuilder: _swiperBuilder,
                    itemCount: _business_banner.length,
                    scrollDirection: Axis.horizontal,
                    autoplay: true,
                    onTap: (index) => Navigator.push(context,
                        new MaterialPageRoute(builder: (_) {
                      return new CommonWebViewPage(
                          url: _business_banner[index].bannerUrl, title: "");
                    })),
                  )),
            ),
            new SliverToBoxAdapter(
                child: new Container(
              child: new Text(
                "优惠推荐",
                style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: _screenUtils.setFontSize(16)),
              ),
              padding: EdgeInsets.only(
                  top: _screenUtils.setWidgetHeight(10),
                  bottom: _screenUtils.setWidgetHeight(10),
                  left: _screenUtils.setWidgetHeight(15)),
            )),
            new SliverToBoxAdapter(
              child: new Wrap(
                alignment: WrapAlignment.end,
                children: <Widget>[
                  new Container(
                    height: _screenUtils.setWidgetHeight(155),
                    child: _business_shop_list == null
                        ? new CupertinoActivityIndicator()
                        : new ListView.builder(
                            itemBuilder: (BuildContext context, int position) {
                              return allCityPurseItem(
                                  context, _business_shop_list[position]);
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: _business_shop_list.length,
                          ),
                  )
                ],
              ),
            ),
            new SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              child: new SliverAppBar(
                automaticallyImplyLeading:false,
//                leading: new Container(),
                elevation: 0,
                backgroundColor: Color(0xfffafafa),
                floating: false,
                pinned: true,
                snap: false,
                forceElevated: innerBoxIsScrolled,
                title: new Container(
                  color: Color(0xfffafafa),
                  child: new Container(
                    height: _screenUtils.setWidgetHeight(28),
                    child: new ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: new BouncingScrollPhysics(),
                      itemCount: _business_class_tag.length,
                      itemBuilder: (BuildContext context, int position) {
                        return new GestureDetector(
                          onTap: () {
                            setState(() {
                              _tag_index = position;
                              queryShopByClassifyTag(_business_class_tag[position].id.toString());
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: _screenUtils.setWidgetWidth(7),
                              right: _screenUtils.setWidgetWidth(7),
                            ),
                            height: _screenUtils.setWidgetHeight(16),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: new Container(
                                padding: EdgeInsets.only(
                                    left: _screenUtils.setWidgetWidth(8),
                                    right: _screenUtils.setWidgetWidth(8),
                                    bottom: _screenUtils.setWidgetHeight(2),
                                    top: _screenUtils.setWidgetHeight(2)),
                                color: _tag_index == position
                                    ? Color(0xff4ddfa9)
                                    : Color(0xfff2f7f6),
                                child: new Text(
                                  _business_class_tag[position].businessTag,
                                  style: new TextStyle(
                                      color: _tag_index == position
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: _screenUtils.setFontSize(13)),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: new Container(
          padding: EdgeInsets.only(top: _screenUtils.setWidgetHeight(55)),
          child: new ListView.builder(
            itemCount:_business_shop_item.length ,
            physics: new BouncingScrollPhysics(),
            itemBuilder: (BuildContext context,int position){
              BusinessShopListData business_item=   _business_shop_item[position];
              return shopItem(context,business_item);
            },
          ),
        ),
      ),
    );
  }


List<BusinessShopListData> _business_shop_item=new List();
  Future queryShopByClassifyTag(String param) async {
    print("------------------------------------------------");
    print(param);
    print("------------------------------------------------");
    var response = await HttpUtil.getInstance().get(Api.QUERY_SHOP_LIST_BY_CLASSIFY,
        data: {"classifyTag": param});

    var decode = json.decode(response);
    var businessShopListEntity = BusinessShopListEntity.fromJson(decode);
    setState(() {
      _business_shop_item= businessShopListEntity.data;
    });
  }
  Widget shopItem(BuildContext context, BusinessShopListData _business_shop_data) {
    List<String> _item_tag = _business_shop_data.shopTag.split(",");
    var color = _business_shop_data.special;
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: _screenUtils.setWidgetHeight(8)),
      margin: EdgeInsets.only(
          top: _screenUtils.setWidgetHeight(2),
          bottom: _screenUtils.setWidgetHeight(2)),
      child: new Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Container(
                color: Colors.white,
                margin:
                EdgeInsets.only(bottom: _screenUtils.setWidgetHeight(1)),
                padding: EdgeInsets.only(
                    left: _screenUtils.setWidgetHeight(11),
                    top: _screenUtils.setWidgetHeight(11)),
                child: new Row(
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: new FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          width: _screenUtils.setWidgetWidth(80),
                          height: _screenUtils.setWidgetHeight(65),
                          placeholder: "assert/imgs/loading.gif",
                          image: _business_shop_data.businessPicture),
                    ),
                    new Container(
                      width: _screenUtils.setWidgetWidth(260),
                      padding: EdgeInsets.only(
                          left: _screenUtils.setWidgetHeight(8)),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            _business_shop_data.businessName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: _screenUtils.setFontSize(16),
                                fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            _business_shop_data.businessDesc,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                color: Colors.grey,
                                fontSize: _screenUtils.setFontSize(13)),
                          ),
                          new Container(
                            height: _screenUtils.setWidgetHeight(15),
                            child: new ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _item_tag.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext b, int position) {
                                return new Text(
                                  _item_tag[position],
                                  style: new TextStyle(
                                      color: Colors.grey,
                                      fontSize: _screenUtils.setFontSize(10)),
                                );
                              },
                            ),
                          ),
                          new RatingBar(
                            value: _business_shop_data.rankScore.toDouble(),
                            size: 15,
                            padding: 1,
                            nomalImage: 'assert/imgs/ic_ranting_unselect.png',
                            selectImage: 'assert/imgs/ic_ranting_select.png',
                            selectAble: false,
                            maxRating: 10,
                            count: 5,
                            onRatingUpdate: (String value) {},
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: EdgeInsets.only(left: _screenUtils.setWidgetWidth(95)),
                child: new ListView.builder(
                    shrinkWrap: true,
                    //解决无限高度问题
                    physics: NeverScrollableScrollPhysics(),
                    //禁用滑动事件
                    itemCount: color.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext b, int position) {
//                     print(int.parse(color[position].bgColor));
                      return new Container(
                        margin: EdgeInsets.all(_screenUtils.setWidgetHeight(2)),
                        child: new Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(3)),
                              child: new Container(
                                alignment: Alignment.center,
                                width: _screenUtils.setWidgetWidth(15),
                                height: _screenUtils.setWidgetHeight(15),
                                color: hexToColor(color[position].bgColor),
                                child: new Text(
                                  color[position].tagShortName,
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: _screenUtils.setFontSize(12)),
                                ),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(
                                  left: _screenUtils.setWidgetWidth(5)),
                              child: new Text(
                                color[position].content,
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: _screenUtils.setFontSize(13)),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
  int _tag_index = 0;
  List<BusinessClassTagsData> _business_class_tag = new List();
  Color hexToColor(String s) {
    if (s == null ||
        s.length != 7 ||
        int.tryParse(s.substring(1, 7), radix: 16) == null) {
      s = '#999999';
    }
    return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }
  Future queryUserShopClassTags() async {
    var response =
        await HttpUtil.getInstance().get(Api.QUERY_SHOP_CLASSIFY_TAGS);

    var decode = json.decode(response);
    var businessClassTagsEntity = BusinessClassTagsEntity.fromJson(decode);
    if (businessClassTagsEntity.code == 200) {
      setState(() {
        _business_class_tag = businessClassTagsEntity.data;
      });
    }

  }

  //轮播图
  Widget _swiperBuilder(BuildContext context, int index) {
    return (new ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        _business_banner[index].bannerPicture,
        fit: BoxFit.fill,
      ),
    ));
  }

  List<BusinessBannerData> _business_banner = new List();

  Future queryBusinessBanner() async {
    var response = await HttpUtil.getInstance().get(Api.QUERY_BUSINESS_BANNER);

    if (response != null) {
      var decode = json.decode(response);
      var businessBannerEntity = BusinessBannerEntity.fromJson(decode);
      if (businessBannerEntity.code == 200) {
        setState(() {
          _business_banner = businessBannerEntity.data;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPurseShop();
    queryBusinessBanner();
    queryUserShopClassTags();
    queryShopByClassifyTag("1");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<BusinessShopListData> _business_shop_list = new List();

  Future getPurseShop() async {
    var response = await HttpUtil.getInstance().get(Api.QUERY_ALL_CITY_SHOP);
    if (response != null) {
      print(response);
      var decode = json.decode(response);
      var businessShopListEntity = BusinessShopListEntity.fromJson(decode);
      if (businessShopListEntity.code == 200) {
        setState(() {
          _business_shop_list = businessShopListEntity.data;
        });
      }
    }
  }

  Widget allCityPurseItem(
      BuildContext context, BusinessShopListData businessShopListData) {
    return new Container(
      margin: EdgeInsets.only(
          top: _screenUtils.setWidgetHeight(4),
          left: _screenUtils.setWidgetWidth(4),
          right: _screenUtils.setWidgetWidth(4),
          bottom: _screenUtils.setWidgetHeight(5)),
      width: _screenUtils.setWidgetWidth(150),
      height: _screenUtils.setWidgetHeight(168),
      decoration: new BoxDecoration(color: Colors.white, boxShadow: [
        new BoxShadow(
            offset: Offset(0.0, 16),
            color: Colors.grey,
            blurRadius: 25,
            spreadRadius: -30)
      ]),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new ClipRRect(
                child: new FadeInImage.assetNetwork(
                    width: _screenUtils.setWidgetWidth(150),
                    height: _screenUtils.setWidgetHeight(90),
                    fit: BoxFit.cover,
                    placeholder: "assert/imgs/loading.gif",
                    image: businessShopListData.businessPicture),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              new Positioned(
                child: new Container(
                  margin: EdgeInsets.all(_screenUtils.setWidgetWidth(2)),
                  padding: EdgeInsets.all(_screenUtils.setWidgetWidth(1)),
                  decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(0),
                      )),
                  constraints: new BoxConstraints(
                    maxWidth: _screenUtils.setWidgetWidth(100),
                  ),
                  child: new Text(
                    businessShopListData.businessDesc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: _screenUtils.setFontSize(12),
                    ),
                  ),
                ),
                bottom: 4,
                left: 3,
              )
            ],
          ),
          new Container(
            padding: EdgeInsets.only(
                left: _screenUtils.setWidgetWidth(8),
                bottom: _screenUtils.setWidgetHeight(2),
                top: _screenUtils.setWidgetHeight(4)),
            child: new Text(
              businessShopListData.businessName,
              maxLines: 1,
              style: new TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: _screenUtils.setFontSize(14)),
            ),
          ),
          new Container(
            padding: EdgeInsets.only(
              left: _screenUtils.setWidgetWidth(8),
            ),
            child: new Text(
              businessShopListData.specialTagContent.split("|")[0].toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                  fontSize: _screenUtils.setFontSize(12), color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
