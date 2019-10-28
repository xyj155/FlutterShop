import 'dart:async';
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
  @override
  void initState() {
    queryUserShopCarByUserId();
    super.initState();
  }

  @override
  void dispose() {
    _timer = null;
    countdownTimer?.cancel();
    _timer?.cancel();
    countdownTimer = null;
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
    var response = await HttpUtil.getInstance().post(
        Api.QUERY_SHOP_CAR_COUNT_AND_PRICE,
        data: {"userId": instance.getInt("id").toString()});
    if (response != null) {
      var decode = json.decode(response.toString());
      var userShopCarEntity = UserShopCarEntity.fromJson(decode);
      var price = userShopCarEntity.data.price;
      var count = userShopCarEntity.data.shopCarCount;
      Map<String, String> _goods = new Map();
      for (int i = 0; i < userShopCarEntity.data.goods.length; i++) {
        userShopCarEntity.data.goods[i].tasty.foodsTaste;
        String goods_item_tastyId =
            userShopCarEntity.data.goods[i].tasty.foodsId.toString();
        String goods_item_price =
            userShopCarEntity.data.goods[i].tasty.tastePrice.toString();
        String goods_item_count = userShopCarEntity.data.goods[i].tasty.count;
        _goods.putIfAbsent("t", () => goods_item_tastyId);
        _goods.putIfAbsent("p", () => goods_item_price);
        _goods.putIfAbsent("c", () => goods_item_count);
        _goods_list.add(_goods);
      }

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
  List<Map> _goods_list = new List();

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
                    child: new Stack(
                      children: <Widget>[
                        new Image.asset(
                          "assert/imgs/user_address_bg.png",
                          height: screenUtils.setWidgetHeight(118),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        ),
                        new Container(
                          margin: EdgeInsets.all(6),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          //
                          alignment: Alignment.centerLeft,
                          height: screenUtils.setWidgetHeight(106),
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
                                          height:
                                              screenUtils.setWidgetHeight(27),
                                        ),
                                      ),
                                      new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          new Container(
                                            margin: EdgeInsets.only(
                                                top: screenUtils
                                                    .setWidgetHeight(25),
                                                bottom: screenUtils
                                                    .setWidgetHeight(4)),
                                            child: new Text(
                                              "${userReceiveAddressData.username}     ${userReceiveAddressData.userTel}",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  fontSize: screenUtils
                                                      .setFontSize(16)),
                                            ),
                                          ),
                                          new Container(
                                            padding: EdgeInsets.only(
                                                top: screenUtils
                                                    .setWidgetHeight(6),
                                                bottom: screenUtils
                                                    .setWidgetHeight(16)),
//                                      width:
//                                      MediaQuery.of(context).size.width -
//                                          screenUtils.setWidgetWidth(50),
                                            child: new Text(
                                              "${userReceiveAddressData.localCity} ${userReceiveAddressData.addressNum}",
                                              style: new TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: screenUtils
                                                      .setFontSize(15)),
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
                                            width:
                                                screenUtils.setWidgetWidth(25),
                                            height:
                                                screenUtils.setWidgetHeight(27),
                                          ),
                                        ),
                                        new Container(
                                          child: new Text("请选择收货地址！",
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  fontSize: screenUtils
                                                      .setFontSize(16))),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
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
                          new Container(
                            padding: EdgeInsets.only(
                                bottom: screenUtils.setWidgetHeight(4)),
                            child: new Text(
                              "备注",
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontSize: screenUtils.setFontSize(15)),
                            ),
                          ),
                          new Container(
                            color: Color(0xfffafafa),
                            padding:
                                EdgeInsets.all(screenUtils.setWidgetHeight(5)),
                            height: screenUtils.setWidgetHeight(100),
                            child: TextFormField(
                              maxLines: 999,
                              decoration: InputDecoration(
                                  hintText: "备注！",
                                  hintStyle: new TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none),
                              autofocus: false,
                              onChanged: (content) {
                                _remark = content;
                              },
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenUtils.setFontSize(15)),
                              cursorColor: Colors.black,
                              focusNode: new FocusNode(),
                              controller: _contentController,
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
          },
        ),
      ),
    );
  }

  String _remark = "";
  TextEditingController _contentController = new TextEditingController();

  Future doAliPayPayment() async {
    countdownTimer?.cancel();
    _timer?.cancel();
    if (userReceiveAddressData == null) {
      _navigationToAddressList(context);
    } else {
      print("=========================================");
      print(json.encode(_goods_list));
      print("=========================================");
      var spUtil = await SpUtil.getInstance();
      var response =
          await HttpUtil.getInstance().post(Api.ALIPAY_TRADE_PASSIVE, data: {
        "goodsName": "就酱零食小商品",
        "username": spUtil.getString("username").toString(),
        "nickname": spUtil.getString("nickname").toString(),
        "userId": spUtil.getInt("id").toString(),
        "addressId": userReceiveAddressData.id.toString(),
        "userTel": spUtil.getString("username").toString(),
        "goodsListJson": json.encode(_goods_list),
        "remark": _remark,
        "userAddress": userReceiveAddressData.localCity +
            userReceiveAddressData.addressNum,
        "receiveUsername": userReceiveAddressData.username,
        "receiveTel": userReceiveAddressData.userTel,
        "province": userReceiveAddressData.currentCity,
        "goodsPrice": priceAll,
        "goodsCount": countAll,
      });
      var decode = json.decode(response);
      var baseResponseEntity = BaseStringResponseEntity.fromJson(decode);
      if (baseResponseEntity.code == 200) {
        spUtil.putString("orderNum", baseResponseEntity.msg);
        tobias.auth(AppEncryptionUtil.verifyTokenDecode(
            baseResponseEntity.data.toString()));
        countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
          queryOrderStatus(spUtil, baseResponseEntity.msg);
          _timer = timer;
        });
      } else {
        ToastUtil.showErrorToast("提交订单失败！${baseResponseEntity.msg}");
      }
    }
  }

  Timer countdownTimer;
  Timer _timer;

  Future queryOrderStatus(SpUtil spUtil, String orderNum) async {
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_USER_ORDER_SUBMIT_STATUS,
        data: {"userId": spUtil.getInt("id").toString(), "orderNum": orderNum});
    var baseResponseEntity = BaseResponseEntity.fromJson(json.decode(response));
    print("========================================");
    print(response);
    print("========================================");
    if (baseResponseEntity.code == 200) {
      ToastUtil.showCommonToast("提交订单成功，货物将在一天之内送达！");
      Navigator.pop(context);
      countdownTimer?.cancel();
      countdownTimer = null;
    } else {
////      ToastUtil.showCommonToast("支付失败");
//      countdownTimer?.cancel();
//      countdownTimer = null;
    }
  }
}
