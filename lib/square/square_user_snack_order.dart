import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/base_string_response_entity.dart';
import 'package:sauce_app/gson/user_receive_address_entity.dart';
import 'package:sauce_app/util/AppEncryptionUtil.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:flutter/cupertino.dart';
import 'package:sauce_app/gson/user_shop_car_entity.dart';
import 'user_address_choose_page.dart';

class SquareUserSnackOrderPage extends StatefulWidget {
  @override
  _SquareUserSnackOrderPageState createState() =>
      _SquareUserSnackOrderPageState();
}

class _SquareUserSnackOrderPageState extends State<SquareUserSnackOrderPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    queryUserShopCarByUserId();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ScreenUtils screenUtils = new ScreenUtils();
  bool isChooseAddress = false;
  UserReceiveAddressData userReceiveAddressData;

  _navigationToAddressList(BuildContext context) async {
    print("----c------");
    var result = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new UserAddressChoosePage()));
    print("----c------" + result.toString());
    if (result != null) {
      setState(() {
        isChooseAddress = true;
        userReceiveAddressData = result;
      });
    }
  }

  int countAll = 0;
  String priceAll = "";

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
        countAll = count;
        priceAll = price;
        _user_shop_list = userShopCarEntity.data.goods;
      });
    } else {
      queryUserShopCarByUserId();
    }
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

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "结算"),
      body: new Container(
        color: Colors.white,
        child: _user_shop_list.length == 0
            ? new Center(
                child: new CupertinoActivityIndicator(
                  radius: screenUtils.setWidgetHeight(13),
                ),
              )
            : new CustomScrollView(
                slivers: <Widget>[
                  new SliverToBoxAdapter(
                    child: new Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.white,
                      height: screenUtils.setWidgetHeight(95),
                      child: isChooseAddress
                          ? new GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _navigationToAddressList(context);
                              },
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.all(
                                        screenUtils.setWidgetWidth(10)),
                                    child: new Image.asset(
                                      "assert/imgs/ic_location_receive.png",
                                      width: screenUtils.setWidgetWidth(25),
                                      height: screenUtils.setWidgetHeight(27),
                                    ),
                                  ),
                                  new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Container(
                                        margin: EdgeInsets.only(
                                            top:
                                                screenUtils.setWidgetHeight(18),
                                            bottom:
                                                screenUtils.setWidgetHeight(8)),
                                        child: new Text(
                                          "${userReceiveAddressData.username}     ${userReceiveAddressData.userTel}",
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  screenUtils.setFontSize(16)),
                                        ),
                                      ),
                                      new Container(
                                        padding: EdgeInsets.only(
                                            bottom: screenUtils
                                                .setWidgetHeight(16)),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                screenUtils.setWidgetWidth(50),
                                        child: new Text(
                                          "${userReceiveAddressData.localCity} ${userReceiveAddressData.addressNum}",
                                          style: new TextStyle(
                                              color: Colors.grey,
                                              fontSize:
                                                  screenUtils.setFontSize(15)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : new GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _navigationToAddressList(context);
                              },
                              child: new Container(
                                child: new Row(
                                  children: <Widget>[
                                    new Container(
                                      padding: EdgeInsets.all(
                                          screenUtils.setWidgetWidth(10)),
                                      child: new Image.asset(
                                        "assert/imgs/ic_location_receive.png",
                                        width: screenUtils.setWidgetWidth(25),
                                        height: screenUtils.setWidgetHeight(27),
                                      ),
                                    ),
                                    new Container(
                                      child: new Text("请选择收货地址！",
                                          style: new TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  screenUtils.setFontSize(16))),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  new SliverToBoxAdapter(
                    child: new Container(
                      height: screenUtils.setWidgetHeight(10),
                      color: Color(0xfffafafa),
                    ),
                  ),
                  new SliverToBoxAdapter(
                    child: new Container(
                      margin: EdgeInsets.only(
                          left: screenUtils.setWidgetWidth(5),
                          top: screenUtils.setWidgetHeight(15),
                          bottom: screenUtils.setWidgetHeight(6)),
                      child: new Text(
                        "商品清单",
                        style: new TextStyle(
                            color: Colors.black,
                            fontSize: screenUtils.setFontSize(16)),
                      ),
                    ),
                  ),
                  new SliverToBoxAdapter(
                    child: new ListView.builder(
                      shrinkWrap: true,
                      physics: new NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext content, int postion) {
                        return userShopCarListItem(
                            context, _user_shop_list[postion]);
                      },
                      itemCount: _user_shop_list.length,
                    ),
                  ),
                  new SliverToBoxAdapter(
                    child: new Container(
                      height: screenUtils.setWidgetHeight(10),
                      color: Color(0xfffafafa),
                    ),
                  ),
                  new SliverToBoxAdapter(
                    child: new Container(
                      padding: EdgeInsets.only(
                          top: screenUtils.setWidgetHeight(10),
                          left: screenUtils.setWidgetWidth(10),
                          right: screenUtils.setWidgetWidth(10)),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(
                                top: screenUtils.setWidgetHeight(4),
                                bottom: screenUtils.setWidgetHeight(17)),
                            child: new Text(
                              "付款信息",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: screenUtils.setFontSize(16)),
                            ),
                          ),
                          new Row(
                            children: <Widget>[
                              new Text(
                                "运费（同城配送）：",
                                style: new TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenUtils.setFontSize(15)),
                              ),
                              new Expanded(
                                  child: new Container(
                                alignment: Alignment.centerRight,
                                child: new Text(
                                  "￥ 0.00",
                                  style: new TextStyle(
                                      color: Colors.grey,
                                      fontSize: screenUtils.setFontSize(15)),
                                ),
                              ))
                            ],
                          ),
                          new Container(
                            padding: EdgeInsets.only(
                                top: screenUtils.setWidgetHeight(10),
                                bottom: screenUtils.setWidgetHeight(15)),
                            child: new Row(
                              children: <Widget>[
                                new Text(
                                  "实付费（含运费）：",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: screenUtils.setFontSize(19)),
                                ),
                                new Expanded(
                                    child: new Container(
                                  alignment: Alignment.centerRight,
                                  child: new RichText(
                                      text: new TextSpan(children: <TextSpan>[
                                    new TextSpan(
                                        text: "￥",
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: screenUtils.setFontSize(13),
                                        )),
                                    new TextSpan(
                                        text: priceAll.substring(
                                          0,
                                          priceAll.indexOf("."),
                                        ),
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize:
                                                screenUtils.setFontSize(25))),
                                    new TextSpan(
                                        text: priceAll
                                            .substring(priceAll.indexOf(".")),
                                        style: new TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                screenUtils.setFontSize(17)))
                                  ])),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
      bottomNavigationBar: new Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width - 28,
        height: screenUtils.setWidgetHeight(50),
        child: new MaterialButton(
          color: Color(0xffffd300),
          textColor: Colors.white,
          child: new Text(
            "提交订单",
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            doAliPayPayment();
//            tobias.pay("alipay_sdk=alipay-sdk-php-20180705&app_id=2019090967087659&biz_content=%7B%22body%22%3A%22%5Cu5c31%5Cu9171-%5Cu96f6%5Cu98df%5Cu5c0f%5Cu5546%5Cu54c1%22%2C%22subject%22%3A%22%5Cu5c31%5Cu9171-%5Cu96f6%5Cu98df%5Cu5c0f%5Cu5546%5Cu54c1%22%2C%22timeout_express%22%3A%2230m%22%2C%22out_trade_no%22%3A%222019100850571019%22%2C%22total_amount%22%3A%2220.00%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=https%3A%2F%2Fsxystushop.xyz%2FJustLikeThis%2Fpublic%2Findex.php%2Fapi%2Fmobile%2Fdoverifypayment&sign_type=RSA2&timestamp=2019-10-08+07%3A34%3A42&version=1.0&sign=LTFNO0WpZF7tA9xONJj78lFOIfn6Gw%2FWDftoVkj%2Bz3mgACbAGbJpBKpDMx8Cffx%2FKVQYPFWzate7H7idsng8xPZoe9tP47Jcj2X%2BLtL%2FTBI7joBhVSK5h3KX0AP2eNL5im9oF41h7AAmyk3qIBVKtepWDB7PblddSNytTSZFckhWH3b8v37OE%2B1l87I48zbQS68tQAR5Ugf5Bs15LOKFY2I9OxkYdWsqRhPrpUawE1RpHSMzqp7KCemqSl1HWWl5zZmgY8A8rlJpxh9EvO%2BAfmuWQ7njup4Rfzn13c6UHoIP46xruowWpWoEcKox4pfmK%2F%2BxuaGpBi6zqc9SWpzeUg%3D%3D");
          },
        ),
      ),
    );
  }

  Future doAliPayPayment() async {
    var response =
        await HttpUtil.getInstance().post(Api.ALIPAY_TRADE_PASSIVE, data: {
      "goodsName": AppEncryptionUtil.verifyTokenEncode("就酱零食小商品"),
      "username": AppEncryptionUtil.verifyTokenEncode("就酱零食小商品"),
      "goodsPrice": priceAll,
    });
    var decode = json.decode(response);
    print(AppEncryptionUtil.verifyTokenEncode("就酱零食小商品")+"--------=====-----------------");
    print(AppEncryptionUtil.verifyTokenDecode(AppEncryptionUtil.verifyTokenEncode("就酱零食小商品"))+"------------0000-------------");
    var baseResponseEntity = BaseStringResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      tobias.auth(AppEncryptionUtil.verifyTokenDecode(
          baseResponseEntity.data.toString()));
    } else {
      ToastUtil.showErrorToast("提交订单失败！${baseResponseEntity.msg}");
    }
  }
}
