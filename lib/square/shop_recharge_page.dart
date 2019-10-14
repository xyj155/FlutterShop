import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/common_webview_page.dart';
import 'package:sauce_app/gson/square_banner_entity.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/widget/page_indicator.dart';

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
    new HomeTabList('全城', new ShopRechargePage()),
    new HomeTabList('附近', new ShopRechargePage()),
    new HomeTabList('水果', new ShopRechargePage()),
    new HomeTabList('小吃快餐', new ShopRechargePage()),
    new HomeTabList('自助餐', new ShopRechargePage()),
    new HomeTabList('奶茶蛋糕', new ShopRechargePage()),
    new HomeTabList('家常菜', new ShopRechargePage()),
    new HomeTabList('薯条披萨', new ShopRechargePage()),
  ];

  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);

    return Scaffold(
      appBar:AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.5,
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title:  TabBar(
          controller: controller,
          indicatorColor: Color(0xff4ddfa9),
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelStyle: new TextStyle(
              fontSize: _screenUtils.setFontSize(15),
              fontWeight: FontWeight.bold),
          labelStyle: new TextStyle(
              fontSize: _screenUtils.setFontSize(15),
              fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          unselectedLabelColor: Color(0xff707070),
          indicatorWeight: _screenUtils.setFontSize(5),
          isScrollable: true,
          tabs: myTabs.map((HomeTabList item) {
            return new Tab(
                text: item.text == null ? '错误' : item.text);
          }).toList(),
        ),
      ),
      body:  TabBarView(
        controller: controller, //配置控制器
        children: myTabs.map((item) {
          return item.goodList;
        }).toList(),
      ),
    );
  }
}
class ShopRechargePage extends StatefulWidget {
  @override
  ShopRechargePageState createState() => new ShopRechargePageState();
}

class ShopRechargePageState extends State<ShopRechargePage> {
  @override
  Widget build(BuildContext context) {
    return new Container();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}
