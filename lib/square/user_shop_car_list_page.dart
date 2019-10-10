import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/MainPage.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/gson/user_shop_car_entity.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/widget/loading_dialog.dart';

class UserShopCarListPage extends StatefulWidget {
  @override
  UserShopCarListPageState createState() => new UserShopCarListPageState();
}

class UserShopCarListPageState extends State<UserShopCarListPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "用户购物车"),
      body: new ListView.builder(
        itemBuilder: (BuildContext content, int postion) {
          return userShopCarListItem(context, _user_shop_list[postion]);
        },
        itemCount: _user_shop_list.length,
      ),
    );
  }

  Widget userShopCarListItem(
      BuildContext context, UserShopCarDataGood userShopCarDataGood) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(screenUtils.setWidgetHeight(7)),
      margin: EdgeInsets.only(bottom: screenUtils.setWidgetHeight(1)),
      child: new Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          new Row(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assert/imgs/loading.gif",
                    image: userShopCarDataGood.foodPicture,
                    fit: BoxFit.cover,
                    width: screenUtils.setWidgetWidth(74),
                    height: screenUtils.setFontSize(74),
                  )),
              new Expanded(
                  child: new Container(
                padding: EdgeInsets.only(left: screenUtils.setWidgetHeight(6)),
                alignment: Alignment.centerLeft,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(
                          top: screenUtils.setWidgetHeight(6),
                          bottom: screenUtils.setWidgetHeight(6),
                          right: screenUtils.setWidgetHeight(6)),
                      child: new Text(
                        userShopCarDataGood.foodName,
                        style: new TextStyle(
                            fontSize: screenUtils.setFontSize(18),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                            color: Colors.black),
                      ),
                    ),
                    new Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: new Container(
                            padding: EdgeInsets.all(1.5),
                            color: Color(0xffffe300),
                            child: new Text(userShopCarDataGood.foodsSize,
                                style: new TextStyle(
                                    fontSize: screenUtils.setFontSize(12),
                                    decoration: TextDecoration.none,
                                    color: Colors.white)),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(
                              left: screenUtils.setWidgetWidth(5)),
                          child: new Text(
                            "口味：${userShopCarDataGood.tasty.foodsTaste}",
                            style: new TextStyle(color: Colors.grey),
                          ),
                        )
                      ],
                    ),
                    new Container(
                      padding:
                          EdgeInsets.only(top: screenUtils.setWidgetHeight(6)),
                      child: new Row(
                        children: <Widget>[
                          new RichText(
                              text: new TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: '￥',
                                style: TextStyle(
                                    fontSize: screenUtils.setFontSize(13),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200)),
                            TextSpan(
                                text: userShopCarDataGood.foodsPrice.substring(
                                    0,
                                    userShopCarDataGood.foodsPrice
                                        .indexOf(".")),
                                style: TextStyle(
                                    fontSize: screenUtils.setFontSize(20),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: userShopCarDataGood.foodsPrice.substring(
                                    userShopCarDataGood.foodsPrice
                                        .indexOf(".")),
                                style: TextStyle(
                                    fontSize: screenUtils.setFontSize(17),
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ])),
                          new Expanded(
                              child: new Container(
                                  alignment: Alignment.centerRight,
                                  child: new Text(
                                    "数量：" +
                                        userShopCarDataGood.tasty.count
                                            .toString(),
                                    style: new TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenUtils.setFontSize(14)),
                                  )))
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
          new Container(
            margin: EdgeInsets.only(bottom: screenUtils.setWidgetHeight(2)),
            child: new Container(),
          ),
        ],
      ),
    );
  }

  List<UserShopCarDataGood> _user_shop_list = new List();

  Future queryUserShopCarByUserId() async {
    var instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_SHOP_CAR_COUNT_AND_PRICE,
        data: {"userId": instance.getInt("id").toString()});
    if (response != null) {
      var decode = json.decode(response.toString());
      var userShopCarEntity = UserShopCarEntity.fromJson(decode);
      var price = userShopCarEntity.data.price;
      var count = userShopCarEntity.data.shopCarCount;
      setState(() {
        _user_shop_list = userShopCarEntity.data.goods;
      });
    } else {
      queryUserShopCarByUserId();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryUserShopCarByUserId();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(UserShopCarListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}
