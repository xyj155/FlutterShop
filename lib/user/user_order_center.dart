import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/user_snack_order_entity.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';

class UserOrderCenterPage extends StatefulWidget {
  @override
  UserOrderCenterPageState createState() => new UserOrderCenterPageState();
}

class UserOrderCenterPageState extends State<UserOrderCenterPage>
    with SingleTickerProviderStateMixin {
  ScreenUtils screenUtil = new ScreenUtils();
  final List<HomeTabList> myTabs = <HomeTabList>[
    new HomeTabList('全部订单', new UserOrderStatusAll()),
    new HomeTabList('已支付 ', new UserOrderStatusFinishPay()),
    new HomeTabList(' 配送中 ', new UserOrderStatusDeliver()),
    new HomeTabList(' 已完成 ', new UserOrderStatusHadFinish()),
  ];

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "订单中心"),
      body: new Scaffold(
        primary: false,
        backgroundColor: Colors.white,
        appBar: TabBar(
          controller: tabController,
          indicatorColor: Color(0xff4ddfa9),
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelStyle: new TextStyle(
              fontSize: screenUtil.setFontSize(14),
              fontWeight: FontWeight.normal),
          labelStyle: new TextStyle(
              fontSize: screenUtil.setFontSize(14),
              fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          unselectedLabelColor: Color(0xff707070),
          indicatorWeight: screenUtil.setFontSize(5),
          isScrollable: false,
          tabs: myTabs.map((HomeTabList item) {
            return new Tab(text: item.text == null ? '错误' : item.text);
          }).toList(),
        ),
        body: new TabBarView(
          children: myTabs.map((item) {
            return item.goodList;
          }).toList(),
          controller: tabController,
        ),
      ),
    );
  }

  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    tabController =
        TabController(vsync: this, length: myTabs.length, initialIndex: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
class UserOrderStatusAll extends StatefulWidget {
  @override
  UserOrderStatusAllState createState() => new UserOrderStatusAllState();
}

class UserOrderStatusAllState extends State<UserOrderStatusAll> {
  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new ListView.builder(
      itemCount: _user_order_list.length,
      itemBuilder: (BuildContext context, int position) {
        var user_order_list = _user_order_list[position];
        return userOrderItem(context, position, user_order_list);
      },
    );
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  Widget userOrderItem(BuildContext context, int position,
      UserSnackOrderData userSnackOrderData) {
    print("===========================================");
    print(userSnackOrderData.status);
    print("===========================================");
    String _totalMoney = userSnackOrderData.totalMoney.toString();
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: _screenUtils.setWidgetWidth(8),
              right: _screenUtils.setWidgetWidth(8),
              top: _screenUtils.setWidgetHeight(3),
              bottom: _screenUtils.setWidgetHeight(3)),
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 9, bottom: 9),
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "自营旗舰店",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    new Expanded(
                        child: new Container(
                          alignment: Alignment.centerRight,
                          child: new Image.asset(
                            "assert/imgs/person_arrow_right_grayx.png",
                            width: _screenUtils.setWidgetHeight(16),
                            height: _screenUtils.setWidgetHeight(16),
                          ),
                        ))
                  ],
                ),
              ),
              new ListView.builder(
                physics: new NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: userSnackOrderData.goods.length,
                itemBuilder: (BuildContext context, int position) {
                  return goodsItemWidget(userSnackOrderData.goods[position]);
                },
              ),
              new Container(
                padding: EdgeInsets.only(top: 4),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      color: Color(0xfffd2963),
                      padding: EdgeInsets.only(
                          left: 3, right: 3, bottom: 0.5, top: 0.5),
                      child: new Text(
                        "优惠",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 8),
                      child: new Text(
                        "已享受同城购物优惠",
                        style: new TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 8, bottom: 10),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text(
                      "合计：",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: _screenUtils.setFontSize(16)),
                    ),
                    new RichText(
                        text: new TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: '￥',
                              style: TextStyle(
                                  fontSize: _screenUtils.setFontSize(13),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200)),
                          TextSpan(
                              text: _totalMoney.substring(
                                  0, _totalMoney.indexOf(".")),
                              style: TextStyle(
                                  fontSize: _screenUtils.setFontSize(20),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                          TextSpan(
                              text: _totalMoney.substring(_totalMoney.indexOf(".")),
                              style: TextStyle(
                                  fontSize: _screenUtils.setFontSize(17),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          TextSpan(
                              text: "  (同城免配送费)",
                              style: TextStyle(
                                  fontSize: _screenUtils.setFontSize(13),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w200)),
                        ]))
                  ],
                ),
              )
            ],
          ),
        ),
        userSnackOrderData.status=="1"?new Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: _screenUtils.setWidgetWidth(10),
          bottom: _screenUtils.setWidgetHeight(9)),
          child: new ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(_screenUtils.setWidgetHeight(30))),
                border: new Border.all(width: 1, color: Color(0xff4ddfa9)),
              ),
              padding: EdgeInsets.only(left: _screenUtils.setWidgetWidth(16),
              right: _screenUtils.setWidgetWidth(16)
              ,bottom: _screenUtils.setWidgetHeight(5),
              top: _screenUtils.setWidgetHeight(5)),
              child: new Text("配送信息",style: new TextStyle(
                  color: Color(0xff4ddfa9),
                  fontWeight: FontWeight.w500,
                  fontSize: 14
              ),
            ),
          ),
        )):new Container(),
        new Container(
          height: 6,
          color: Color(0xfffafafa),
        )
      ],
    );
  }

  Widget goodsItemWidget(UserSnackOrderDataGood userSnackOrderDataGood) {
    String _totalMoney = userSnackOrderDataGood.totalPrice.toString();
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Container(
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: new Image.network(
                    userSnackOrderDataGood.foodPicture,
                    fit: BoxFit.cover,
                    width: _screenUtils.setWidgetWidth(90),
                    height: _screenUtils.setWidgetHeight(70),
                  ),
                ),
                margin: EdgeInsets.only(
                    left: _screenUtils.setWidgetWidth(3),
                    right: _screenUtils.setWidgetWidth(3),
                    top: _screenUtils.setWidgetHeight(6),
                    bottom: _screenUtils.setWidgetHeight(6)),
              ),
              new Expanded(
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(left: 6),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              userSnackOrderDataGood.foodName,
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: _screenUtils.setFontSize(15),
                                  fontWeight: FontWeight.bold),
                            ),
                            new Container(
                              margin: EdgeInsets.only(top: 4, bottom: 4),
                              child: new Text(
                                userSnackOrderDataGood.foodsSize+"   ${userSnackOrderDataGood.tastyName}",
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(bottom: 4),
                              child: new RichText(
                                  text: new TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: '￥',
                                        style: TextStyle(
                                            fontSize: _screenUtils.setFontSize(13),
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w200)),
                                    TextSpan(
                                        text: _totalMoney.substring(
                                            0, _totalMoney.indexOf(".")),
                                        style: TextStyle(
                                            fontSize: _screenUtils.setFontSize(20),
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w800)),
                                    TextSpan(
                                        text: _totalMoney
                                            .substring(_totalMoney.indexOf(".")),
                                        style: TextStyle(
                                            fontSize: _screenUtils.setFontSize(17),
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w600)),
                                  ])),
                            )
                          ],
                        ),
                      ),
                      new Positioned(
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "数量：",
                              style: new TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            new Text(
                              userSnackOrderDataGood.tastyCount.toString(),
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )
                          ],
                        ),
                        right: 6,
                        bottom: 6,
                      )
                    ],
                  ))
            ],
          ),
          new Container(
            height: 1,
            color: Color(0xfffafafa),
          )
        ],
      ),
    );
  }

  List<UserSnackOrderData> _user_order_list = new List();

  Future getUserOrderStatus() async {
    var spUtil = await SpUtil.getInstance();
    var response =
    await HttpUtil.getInstance().get(Api.QUERY_USER_ORDER_STATUS, data: {
      "userId": spUtil.getInt("id").toString(),
      "status": "5",
      "page": "1",
    });
    var userSnackOrderEntity =
    UserSnackOrderEntity.fromJson(json.decode(response));
    if (userSnackOrderEntity.code == 200) {
      setState(() {
        _user_order_list = userSnackOrderEntity.data;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserOrderStatus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}
class UserOrderStatusFinishPay extends StatefulWidget {
  @override
  UserOrderStatusFinishPayState createState() =>
      new UserOrderStatusFinishPayState();
}

class UserOrderStatusFinishPayState extends State<UserOrderStatusFinishPay> {
  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new ListView.builder(
      itemCount: _user_order_list.length,
      itemBuilder: (BuildContext context, int position) {
        var user_order_list = _user_order_list[position];
        return userOrderItem(context, position, user_order_list);
      },
    );
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  Widget userOrderItem(BuildContext context, int position,
      UserSnackOrderData userSnackOrderData) {
    String _totalMoney = userSnackOrderData.totalMoney.toString();
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: _screenUtils.setWidgetWidth(8),
              right: _screenUtils.setWidgetWidth(8),
              top: _screenUtils.setWidgetHeight(3),
              bottom: _screenUtils.setWidgetHeight(3)),
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 9, bottom: 9),
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "自营旗舰店",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    new Expanded(
                        child: new Container(
                      alignment: Alignment.centerRight,
                      child: new Image.asset(
                        "assert/imgs/person_arrow_right_grayx.png",
                        width: _screenUtils.setWidgetHeight(16),
                        height: _screenUtils.setWidgetHeight(16),
                      ),
                    ))
                  ],
                ),
              ),
              new ListView.builder(
                physics: new NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: userSnackOrderData.goods.length,
                itemBuilder: (BuildContext context, int position) {
                  return goodsItemWidget(userSnackOrderData.goods[position]);
                },
              ),
              new Container(
                padding: EdgeInsets.only(top: 4),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      color: Color(0xfffd2963),
                      padding: EdgeInsets.only(
                          left: 3, right: 3, bottom: 0.5, top: 0.5),
                      child: new Text(
                        "优惠",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 8),
                      child: new Text(
                        "已享受同城购物优惠",
                        style: new TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 8, bottom: 10),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text(
                      "合计：",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: _screenUtils.setFontSize(16)),
                    ),
                    new RichText(
                        text: new TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: '￥',
                          style: TextStyle(
                              fontSize: _screenUtils.setFontSize(13),
                              color: Colors.black,
                              fontWeight: FontWeight.w200)),
                      TextSpan(
                          text: _totalMoney.substring(
                              0, _totalMoney.indexOf(".")),
                          style: TextStyle(
                              fontSize: _screenUtils.setFontSize(20),
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      TextSpan(
                          text: _totalMoney.substring(_totalMoney.indexOf(".")),
                          style: TextStyle(
                              fontSize: _screenUtils.setFontSize(17),
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: "  (同城免配送费)",
                          style: TextStyle(
                              fontSize: _screenUtils.setFontSize(13),
                              color: Colors.grey,
                              fontWeight: FontWeight.w200)),
                    ]))
                  ],
                ),
              )
            ],
          ),
        ),
        new Container(
          height: 6,
          color: Color(0xfffafafa),
        )
      ],
    );
  }

  Widget goodsItemWidget(UserSnackOrderDataGood userSnackOrderDataGood) {
    String _totalMoney = userSnackOrderDataGood.totalPrice.toString();
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Container(
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: new Image.network(
                    userSnackOrderDataGood.foodPicture,
                    fit: BoxFit.cover,
                    width: _screenUtils.setWidgetWidth(90),
                    height: _screenUtils.setWidgetHeight(70),
                  ),
                ),
                margin: EdgeInsets.only(
                    left: _screenUtils.setWidgetWidth(3),
                    right: _screenUtils.setWidgetWidth(3),
                    top: _screenUtils.setWidgetHeight(6),
                    bottom: _screenUtils.setWidgetHeight(6)),
              ),
              new Expanded(
                  child: new Stack(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(left: 6),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          userSnackOrderDataGood.foodName,
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: _screenUtils.setFontSize(15),
                              fontWeight: FontWeight.bold),
                        ),
                        new Container(
                          margin: EdgeInsets.only(top: 4, bottom: 4),
                          child: new Text(
                            userSnackOrderDataGood.foodsSize+"   ${userSnackOrderDataGood.tastyName}",
                            style: new TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(bottom: 4),
                          child: new RichText(
                              text: new TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: '￥',
                                style: TextStyle(
                                    fontSize: _screenUtils.setFontSize(13),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w200)),
                            TextSpan(
                                text: _totalMoney.substring(
                                    0, _totalMoney.indexOf(".")),
                                style: TextStyle(
                                    fontSize: _screenUtils.setFontSize(20),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w800)),
                            TextSpan(
                                text: _totalMoney
                                    .substring(_totalMoney.indexOf(".")),
                                style: TextStyle(
                                    fontSize: _screenUtils.setFontSize(17),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600)),
                          ])),
                        )
                      ],
                    ),
                  ),
                  new Positioned(
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          "数量：",
                          style: new TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        new Text(
                          userSnackOrderDataGood.tastyCount.toString(),
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )
                      ],
                    ),
                    right: 6,
                    bottom: 6,
                  )
                ],
              ))
            ],
          ),
          new Container(
            height: 1,
            color: Color(0xfffafafa),
          )
        ],
      ),
    );
  }

  List<UserSnackOrderData> _user_order_list = new List();

  Future getUserOrderStatus() async {
    var spUtil = await SpUtil.getInstance();
    var response =
        await HttpUtil.getInstance().get(Api.QUERY_USER_ORDER_STATUS, data: {
      "userId": spUtil.getInt("id").toString(),
      "status": "0",
      "page": "1",
    });
    var userSnackOrderEntity =
        UserSnackOrderEntity.fromJson(json.decode(response));
    if (userSnackOrderEntity.code == 200) {
      setState(() {
        _user_order_list = userSnackOrderEntity.data;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserOrderStatus();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class UserOrderStatusDeliver extends StatefulWidget {
  @override
  UserOrderStatusDeliverState createState() =>
      new UserOrderStatusDeliverState();
}

class UserOrderStatusDeliverState extends State<UserOrderStatusDeliver> {
  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new ListView.builder(
      itemBuilder: (BuildContext context, int position) {
        return userOrderItem(context, position, _user_order_list[position]);
      },
      itemCount: _user_order_list.length,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserOrderStatus();
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  Widget userOrderItem(BuildContext context, int position,
      UserSnackOrderData userSnackOrderData) {
    String _totalMoney = userSnackOrderData.totalMoney.toString();
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: _screenUtils.setWidgetWidth(8),
              right: _screenUtils.setWidgetWidth(8),
              top: _screenUtils.setWidgetHeight(3),
              bottom: _screenUtils.setWidgetHeight(3)),
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 9, bottom: 9),
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "自营旗舰店",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    new Expanded(
                        child: Container(
                      alignment: Alignment.centerRight,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(right: 10),
                            child: new Text(
                              "配送中",
                              style: new TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          new Image.asset(
                            "assert/imgs/person_arrow_right_grayx.png",
                            width: _screenUtils.setWidgetHeight(16),
                            height: _screenUtils.setWidgetHeight(16),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              new ListView.builder(
                physics: new NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: userSnackOrderData.goods.length,
                itemBuilder: (BuildContext context, int position) {
                  return goodsItemWidget(userSnackOrderData.goods[position]);
                },
              ),
              new Container(
                padding: EdgeInsets.only(top: 4),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      color: Color(0xfffd2963),
                      padding: EdgeInsets.only(
                          left: 3, right: 3, bottom: 0.5, top: 0.5),
                      child: new Text(
                        "优惠",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 8),
                      child: new Text(
                        "已享受同城购物优惠",
                        style: new TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 8, bottom: 10),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text(
                      "合计：",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: _screenUtils.setFontSize(16)),
                    ),
                    new RichText(
                        text: new TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: '￥',
                          style: TextStyle(
                              fontSize: _screenUtils.setFontSize(13),
                              color: Colors.black,
                              fontWeight: FontWeight.w200)),
                      TextSpan(
                          text: _totalMoney.substring(
                              0, _totalMoney.indexOf(".")),
                          style: TextStyle(
                              fontSize: _screenUtils.setFontSize(20),
                              color: Colors.black,
                              fontWeight: FontWeight.w800)),
                      TextSpan(
                          text: _totalMoney.substring(_totalMoney.indexOf(".")),
                          style: TextStyle(
                              fontSize: _screenUtils.setFontSize(17),
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: "  (同城免配送费)",
                          style: TextStyle(
                              fontSize: _screenUtils.setFontSize(13),
                              color: Colors.grey,
                              fontWeight: FontWeight.w200)),
                    ]))
                  ],
                ),
              ),
              new Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: _screenUtils.setWidgetWidth(10),
                      bottom: _screenUtils.setWidgetHeight(9)),
                  child: new ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(_screenUtils.setWidgetHeight(30))),
                        border: new Border.all(width: 1, color: Color(0xff4ddfa9)),
                      ),
                      padding: EdgeInsets.only(left: _screenUtils.setWidgetWidth(16),
                          right: _screenUtils.setWidgetWidth(16)
                          ,bottom: _screenUtils.setWidgetHeight(5),
                          top: _screenUtils.setWidgetHeight(5)),
                      child: new Text("配送信息",style: new TextStyle(
                          color: Color(0xff4ddfa9),
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        new Container(
          height: 6,
          color: Color(0xfffafafa),
        )
      ],
    );
  }

  Widget goodsItemWidget(UserSnackOrderDataGood userSnackOrderDataGood) {
    String _totalMoney = userSnackOrderDataGood.totalPrice.toString();
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Container(
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: new Image.network(
                    userSnackOrderDataGood.foodPicture,
                    fit: BoxFit.cover,
                    width: _screenUtils.setWidgetWidth(90),
                    height: _screenUtils.setWidgetHeight(70),
                  ),
                ),
                margin: EdgeInsets.only(
                    left: _screenUtils.setWidgetWidth(3),
                    right: _screenUtils.setWidgetWidth(3),
                    top: _screenUtils.setWidgetHeight(6),
                    bottom: _screenUtils.setWidgetHeight(6)),
              ),
              new Expanded(
                  child: new Stack(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(left: 6),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          userSnackOrderDataGood.foodName,
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: _screenUtils.setFontSize(15),
                              fontWeight: FontWeight.bold),
                        ),
                        new Container(
                          margin: EdgeInsets.only(top: 4, bottom: 4),
                          child: new Text(
                            userSnackOrderDataGood.foodsSize+"   ${userSnackOrderDataGood.tastyName}",
                            style: new TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(bottom: 4),
                          child: new RichText(
                              text: new TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: '￥',
                                style: TextStyle(
                                    fontSize: _screenUtils.setFontSize(13),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w200)),
                            TextSpan(
                                text: _totalMoney.substring(
                                    0, _totalMoney.indexOf(".")),
                                style: TextStyle(
                                    fontSize: _screenUtils.setFontSize(20),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w800)),
                            TextSpan(
                                text: _totalMoney
                                    .substring(_totalMoney.indexOf(".")),
                                style: TextStyle(
                                    fontSize: _screenUtils.setFontSize(17),
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600)),
                          ])),
                        )
                      ],
                    ),
                  ),
                  new Positioned(
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text(
                          "数量：",
                          style: new TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        new Text(
                          userSnackOrderDataGood.tastyCount.toString(),
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )
                      ],
                    ),
                    right: 6,
                    bottom: 6,
                  )
                ],
              ))
            ],
          ),
          new Container(
            height: 1,
            color: Color(0xfffafafa),
          )
        ],
      ),
    );
  }

  List<UserSnackOrderData> _user_order_list = new List();

  Future getUserOrderStatus() async {
    var spUtil = await SpUtil.getInstance();
    var response =
        await HttpUtil.getInstance().get(Api.QUERY_USER_ORDER_STATUS, data: {
      "userId": spUtil.getInt("id").toString(),
      "status": "1",
      "page": "1",
    });
    var userSnackOrderEntity =
        UserSnackOrderEntity.fromJson(json.decode(response));
    if (userSnackOrderEntity.code == 200) {
      setState(() {
        _user_order_list = userSnackOrderEntity.data;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class UserOrderStatusHadFinish extends StatefulWidget {
  @override
  UserOrderStatusHadFinishState createState() =>
      new UserOrderStatusHadFinishState();
}

class UserOrderStatusHadFinishState extends State<UserOrderStatusHadFinish> {
  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new ListView.builder(
      itemBuilder: (BuildContext context, int position) {
        return userOrderItem(context, position, _user_order_list[position]);
      },
      itemCount: _user_order_list.length,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserOrderStatus();
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  Widget userOrderItem(BuildContext context, int position,
      UserSnackOrderData userSnackOrderData) {
    String _totalMoney = userSnackOrderData.totalMoney.toString();
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: _screenUtils.setWidgetWidth(8),
              right: _screenUtils.setWidgetWidth(8),
              top: _screenUtils.setWidgetHeight(3),
              bottom: _screenUtils.setWidgetHeight(3)),
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top: 9, bottom: 9),
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "自营旗舰店",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    new Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.only(right: 10),
                                child: new Text(
                                  "配送中",
                                  style: new TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              new Image.asset(
                                "assert/imgs/person_arrow_right_grayx.png",
                                width: _screenUtils.setWidgetHeight(16),
                                height: _screenUtils.setWidgetHeight(16),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              new ListView.builder(
                physics: new NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: userSnackOrderData.goods.length,
                itemBuilder: (BuildContext context, int position) {
                  return goodsItemWidget(userSnackOrderData.goods[position]);
                },
              ),
              new Container(
                padding: EdgeInsets.only(top: 4),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      color: Color(0xfffd2963),
                      padding: EdgeInsets.only(
                          left: 3, right: 3, bottom: 0.5, top: 0.5),
                      child: new Text(
                        "优惠",
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: 8),
                      child: new Text(
                        "已享受同城购物优惠",
                        style: new TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w300),
                      ),
                    )
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 8, bottom: 10),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text(
                      "合计：",
                      style: new TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: _screenUtils.setFontSize(16)),
                    ),
                    new RichText(
                        text: new TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: '￥',
                              style: TextStyle(
                                  fontSize: _screenUtils.setFontSize(13),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200)),
                          TextSpan(
                              text: _totalMoney.substring(
                                  0, _totalMoney.indexOf(".")),
                              style: TextStyle(
                                  fontSize: _screenUtils.setFontSize(20),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                          TextSpan(
                              text: _totalMoney.substring(_totalMoney.indexOf(".")),
                              style: TextStyle(
                                  fontSize: _screenUtils.setFontSize(17),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          TextSpan(
                              text: "  (同城免配送费)",
                              style: TextStyle(
                                  fontSize: _screenUtils.setFontSize(13),
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w200)),
                        ]))
                  ],
                ),
              ),
              new Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(right: _screenUtils.setWidgetWidth(10),
                      bottom: _screenUtils.setWidgetHeight(9)),
                  child: new ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(_screenUtils.setWidgetHeight(30))),
                        border: new Border.all(width: 1, color: Color(0xff4ddfa9)),
                      ),
                      padding: EdgeInsets.only(left: _screenUtils.setWidgetWidth(16),
                          right: _screenUtils.setWidgetWidth(16)
                          ,bottom: _screenUtils.setWidgetHeight(5),
                          top: _screenUtils.setWidgetHeight(5)),
                      child: new Text("问题反馈",style: new TextStyle(
                          color: Color(0xff4ddfa9),
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                      ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
        new Container(
          height: 6,
          color: Color(0xfffafafa),
        )
      ],
    );
  }

  Widget goodsItemWidget(UserSnackOrderDataGood userSnackOrderDataGood) {
    String _totalMoney = userSnackOrderDataGood.totalPrice.toString();
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Container(
                child: new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: new Image.network(
                    userSnackOrderDataGood.foodPicture,
                    fit: BoxFit.cover,
                    width: _screenUtils.setWidgetWidth(90),
                    height: _screenUtils.setWidgetHeight(70),
                  ),
                ),
                margin: EdgeInsets.only(
                    left: _screenUtils.setWidgetWidth(3),
                    right: _screenUtils.setWidgetWidth(3),
                    top: _screenUtils.setWidgetHeight(6),
                    bottom: _screenUtils.setWidgetHeight(6)),
              ),
              new Expanded(
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(left: 6),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              userSnackOrderDataGood.foodName,
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: _screenUtils.setFontSize(15),
                                  fontWeight: FontWeight.bold),
                            ),
                            new Container(
                              margin: EdgeInsets.only(top: 4, bottom: 4),
                              child: new Text(
                                userSnackOrderDataGood.foodsSize+"   ${userSnackOrderDataGood.tastyName}",
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(bottom: 4),
                              child: new RichText(
                                  text: new TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: '￥',
                                        style: TextStyle(
                                            fontSize: _screenUtils.setFontSize(13),
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w200)),
                                    TextSpan(
                                        text: _totalMoney.substring(
                                            0, _totalMoney.indexOf(".")),
                                        style: TextStyle(
                                            fontSize: _screenUtils.setFontSize(20),
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w800)),
                                    TextSpan(
                                        text: _totalMoney
                                            .substring(_totalMoney.indexOf(".")),
                                        style: TextStyle(
                                            fontSize: _screenUtils.setFontSize(17),
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w600)),
                                  ])),
                            )
                          ],
                        ),
                      ),
                      new Positioned(
                        child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Text(
                              "数量：",
                              style: new TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            new Text(
                              userSnackOrderDataGood.tastyCount.toString(),
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )
                          ],
                        ),
                        right: 6,
                        bottom: 6,
                      )
                    ],
                  ))
            ],
          ),
          new Container(
            height: 1,
            color: Color(0xfffafafa),
          )
        ],
      ),
    );
  }

  List<UserSnackOrderData> _user_order_list = new List();

  Future getUserOrderStatus() async {
    var spUtil = await SpUtil.getInstance();
    var response =
    await HttpUtil.getInstance().get(Api.QUERY_USER_ORDER_STATUS, data: {
      "userId": spUtil.getInt("id").toString(),
      "status": "3",
      "page": "1",
    });
    var userSnackOrderEntity =
    UserSnackOrderEntity.fromJson(json.decode(response));
    if (userSnackOrderEntity.code == 200) {
      setState(() {
        _user_order_list = userSnackOrderEntity.data;
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
