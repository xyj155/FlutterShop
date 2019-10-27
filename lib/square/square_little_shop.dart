import 'dart:async';
import 'dart:convert';

import 'dart:math';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/event_bus.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/commodity_tasty_entity.dart';
import 'package:sauce_app/gson/shop_kind_list_entity.dart';
import 'package:sauce_app/gson/commodity_list_item_entity.dart';
import 'package:sauce_app/gson/user_shop_car_entity.dart';
import 'package:sauce_app/square/square_user_snack_order.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/event_bus.dart';

import 'package:sauce_app/widget/loading_dialog.dart';

//import 'package:sauce_app/widget/common_dialog.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:flutter/material.dart';

class LittleShopPage extends StatefulWidget {
  @override
  _LittleShopPageState createState() => _LittleShopPageState();
}

ScreenUtils screenUtils = new ScreenUtils();

class _LittleShopPageState extends State<LittleShopPage> {
  int index;

  @override
  void initState() {
    super.initState();
    getUserShopCar();
    getCommodityKindItem();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSet = true;
  bool isRequestShopCar = true;

  @override
  void deactivate() {
    super.deactivate();
    print("------------------------------------------");
//    if (isSet) {
    getUserShopCar();
//    }
  }

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
//    if (isSet) {
//
//    }
    EventBusUtil.getDefault().register((String i) {
      if (i == "add") {
        if (isRequestShopCar) {
          getUpdateShopCat();
          debugPrint("enent bus ${isRequestShopCar}"); //接受消息打印
        }
      }
    });

    void NavigatorGetUserShopCarList() {
      Navigator.push(context, new MaterialPageRoute(builder: (_) {
        return new UserShopCarListPage();
      }));
    }

    return Scaffold(
        appBar: BackUtil.NavigationBack(context, "小卖部"),
        body: new Stack(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      child: new ListView.builder(
                          physics: new BouncingScrollPhysics(),
                          itemCount: _commodity_kind.length,
                          itemBuilder: (BuildContext context, int position) {
                            return getCommodityKind(position);
                          }),
                    )),
                new Expanded(
                  flex: 5,
                  child: new ListView.builder(
                      shrinkWrap: false,
                      physics: new BouncingScrollPhysics(),
                      itemCount: _commodity_list.length,
                      itemBuilder: (BuildContext context, int position) {
                        return getCommodityItem(position, context);
                      }),
                ),
              ],
            ),
            new Positioned(
              child: new Stack(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(
                        left: screenUtils.setWidgetWidth(70),
                        top: screenUtils.setWidgetHeight(8)),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new RichText(
                          text: TextSpan(
                              text: "合计:",
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: screenUtils.setFontSize(19),
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: "￥",
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: screenUtils.setFontSize(14))),
                                new TextSpan(
                                    text: goodsPrice.substring(
                                        0, goodsPrice.indexOf(("."))),
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: screenUtils.setFontSize(22))),
                                new TextSpan(
                                    text: goodsPrice
                                        .substring(goodsPrice.indexOf(("."))),
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: screenUtils.setFontSize(14)))
                              ]),
                        ),
                        new Container(
                          margin: EdgeInsets.only(
                              top: screenUtils.setWidgetHeight(6)),
                          child: new Text(
                            "运费(同城)由公众号“万家直购”免费提供",
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: screenUtils.setFontSize(8)),
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff434343),
                        border:
                            Border.all(color: Color(0xff434343), width: 1.0),
                        borderRadius: BorderRadius.circular(60)),
                    width: MediaQuery.of(context).size.width -
                        screenUtils.setWidgetWidth(60),
                    height: screenUtils.setWidgetHeight(60),
                    margin: EdgeInsets.only(
                        left: screenUtils.setWidgetWidth(30),
                        right: screenUtils.setWidgetWidth(30)),
                  ),
                  new Stack(
                    children: <Widget>[
                      new Container(
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                screenUtils.setWidgetWidth(40))),
                            boxShadow: <BoxShadow>[
                              new BoxShadow(
                                color: Color(0xff434343), //阴影颜色
                                blurRadius: 3.0, //阴影大小
                              ),
                            ]),
                        margin: EdgeInsets.only(
                            left: screenUtils.setWidgetWidth(20)),
                        child: new GestureDetector(
                          onTap: () {
                            NavigatorGetUserShopCarList();
                          },
                          child: new ClipRRect(
                            child: new Image.asset(
                              "assert/imgs/ic_shop_car.png",
                              width: screenUtils.setWidgetWidth(60),
                              height: screenUtils.setWidgetHeight(62),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                screenUtils.setWidgetWidth(40))),
                          ),
                        ),
                      ),
                      goodsCount == 0
                          ? new Container()
                          : new Positioned(
                              child: new ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                child: new Container(
                                  alignment: Alignment.center,
                                  width: screenUtils.setWidgetWidth(20),
                                  height: screenUtils.setWidgetHeight(20),
                                  color: Colors.redAccent,
                                  child: new Text(
                                    goodsCount > 99
                                        ? "99"
                                        : goodsCount.toString(),
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: screenUtils.setFontSize(14)),
                                  ),
                                ),
                              ),
                              right: screenUtils.setWidgetWidth(2),
                              top: screenUtils.setWidgetHeight(2),
                            ),
                    ],
                  ),
                  new Positioned(
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (_) {
                          return new SquareUserSnackOrderPage();
                        }));
                      },
                      child: new Container(
                        height: screenUtils.setWidgetHeight(60),
                        padding: EdgeInsets.only(
                            left: screenUtils.setWidgetWidth(17),
                            right: screenUtils.setWidgetWidth(17)),
                        margin: EdgeInsets.only(
                            right: screenUtils.setWidgetWidth(30)),
                        alignment: Alignment.center,
                        decoration: new BoxDecoration(
                            color: Color(0xffffd300),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    screenUtils.setWidgetHeight(60)),
                                bottomRight: Radius.circular(
                                    screenUtils.setWidgetHeight(60)))),
                        child: new Text(
                          "去结算",
                          style: new TextStyle(
                              color: Color(0xff434343),
                              fontWeight: FontWeight.bold,
                              fontSize: screenUtils.setFontSize(17)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    right: 0,
                  )
                ],
              ),
              bottom: screenUtils.setWidgetHeight(30),
            )
          ],
        ));
  }

  List<ShopKindListData> _commodity_kind = new List();
  int shopId;

  void showUserOrderBottomSheetDialog(BuildContext context) {}

  getCommodityKindItem() async {
    var response = await HttpUtil.getInstance().get(Api.COMMODITY_KIND_ITEM);
    var decode = json.decode(response);
    var shopKindListEntity = ShopKindListEntity.fromJson(decode);
    if (shopKindListEntity.code == 200) {
      setState(() {
        _commodity_kind = shopKindListEntity.data;
        index = 0;
        shopId = shopKindListEntity.data[0].id;
        getCommodityById(shopId);
      });
    }
  }

  Widget getCommodityKind(int i) {
    return new GestureDetector(
      child: new Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
                width: 5, color: index == i ? Color(0xff4ddfa9) : Colors.white),
          ),
        ),
        child: Text(_commodity_kind[i].kindName,
            style: TextStyle(
                color: Colors.black,
                fontWeight: index == i ? FontWeight.w600 : FontWeight.w400,
                fontSize: 16)),
      ),
      onTap: () {
        setState(() {
          index = i; //记录选中的下标
          getCommodityById(_commodity_kind[i].id);
        });
      },
    );
  }

  List<CommodityListItemData> _commodity_list = new List();

  getCommodityById(int commodity) async {
    var response = await HttpUtil.getInstance()
        .get(Api.COMMODITY_ALL_BY_ID, data: {"shopId": commodity});
    var decode = json.decode(response);
    print("-----------------------------");
    print(response);
    print("-----------------------------");
    var shopKindListEntity = CommodityListItemEntity.fromJson(decode);
    if (shopKindListEntity.code == 200) {
      setState(() {
        _commodity_list = shopKindListEntity.data;
      });
    }
  }

  Widget getCommodityItem(int i, BuildContext context) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.all(screenUtils.setWidgetWidth(7)),
      child: new Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          new Row(
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assert/imgs/loading.gif",
                    image: _commodity_list[i].foodPicture,
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
                        _commodity_list[i].foodName,
                        style: new TextStyle(
                            fontSize: screenUtils.setFontSize(15),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                            color: Colors.black),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: new Container(
                        padding: EdgeInsets.all(1.5),
                        color: Color(0xffffe300),
                        child: new Text(_commodity_list[i].foodsSize,
                            style: new TextStyle(
                                fontSize: screenUtils.setFontSize(12),
                                decoration: TextDecoration.none,
                                color: Colors.white)),
                      ),
                    ),
                    new Container(
                      padding:
                          EdgeInsets.only(top: screenUtils.setWidgetHeight(6)),
                      child: new RichText(
                          text: new TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: '￥',
                            style: TextStyle(
                                fontSize: screenUtils.setFontSize(13),
                                color: Colors.black,
                                fontWeight: FontWeight.w200)),
                        TextSpan(
                            text: _commodity_list[i].foodsPrice.substring(
                                0, _commodity_list[i].foodsPrice.indexOf(".")),
                            style: TextStyle(
                                fontSize: screenUtils.setFontSize(20),
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        TextSpan(
                            text: _commodity_list[i].foodsPrice.substring(
                                _commodity_list[i].foodsPrice.indexOf(".")),
                            style: TextStyle(
                                fontSize: screenUtils.setFontSize(17),
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ])),
                    )
                  ],
                ),
              ))
            ],
          ),
          new Container(
            margin: EdgeInsets.only(bottom: screenUtils.setWidgetHeight(2)),
            child: new GestureDetector(
              child: new Image.asset(
                "assert/imgs/ic_shopcar.png",
                width: screenUtils.setWidgetWidth(22),
                height: screenUtils.setWidgetHeight(22),
              ),
              onTap: () {
                print("==========isRequestShopCar=================");
                print(isRequestShopCar);
                print("============isRequestShopCar===============");
                showDialog<Null>(
                    context: context, //BuildContext对象
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new LoadingDialog(
                        //调用对话框
                        text: '等一会哦！',
                      );
                    });
                getTastyById(_commodity_list[i], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  int tastyIndex = 0;
  List<CommodityTastyData> _tasty = new List();

  getTastyById(CommodityListItemData commodity, BuildContext context) async {
    print("-------------------------------------");

    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_COMMODITY_TASTY, data: {"commodityId": commodity.id});
    print(response.toString());
    var decode = json.decode(response);
    var commodityTastyEntity = CommodityTastyEntity.fromJson(decode);

    if (commodityTastyEntity.code == 200) {
      setState(() {
        _tasty = commodityTastyEntity.data;
        Navigator.pop(context);
        showModalBottomSheet(
            context: context,
            builder: (context) => BottomDialog(
                  commodityListItemData: commodity,
                  tasty: _tasty,
                ));
      });
    } else {
      Navigator.pop(context);
      ToastUtil.showErrorToast("获取商品信息错误");
    }
  }

  int goodsCount = 0;
  String goodsPrice = "0.00";

  Future getUserShopCar() async {
    var instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_SHOP_CAR_COUNT_AND_PRICE,
        data: {"userId": instance.getInt("id").toString()});
    if (response != null) {

      var decode = json.decode(response.toString());
      var userShopCarEntity = UserShopCarEntity.fromJson(decode);
      var price = userShopCarEntity.data.price;
      var count = userShopCarEntity.data.shopCarCount;
      print("-----------------------");
      print(userShopCarEntity.data);
      print("-----------------------");
      setState(() {
        goodsPrice = price;
        goodsCount = count;
      });
//      if (userShopCarEntity.code == 200) {
//        var price = userShopCarEntity.data.price;
//        var count = userShopCarEntity.data.shopCarCount;
//        setState(() {
//          goodsPrice = price;
//          goodsCount = count;
//        });
//      }
    } else {
      getUserShopCar();
    }
  }

  void getUpdateShopCat() async {
    var instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_SHOP_CAR_COUNT_AND_PRICE,
        data: {"userId": instance.getInt("id").toString()});
    if (response != null) {
      var decode = json.decode(response.toString());
      var userShopCarEntity = UserShopCarEntity.fromJson(decode);
      if (userShopCarEntity.code == 200) {
        setState(() {
          isSet = false;
          goodsPrice = userShopCarEntity.data.price;
          goodsCount = userShopCarEntity.data.shopCarCount;
        });
      }
    }
  }
}

class BottomDialog extends StatefulWidget {
  CommodityListItemData commodityListItemData;
  List<CommodityTastyData> tasty;

  BottomDialog({Key key, this.commodityListItemData, this.tasty})
      : super(key: key);

  @override
  BottomDialogState createState() => new BottomDialogState();
}

class BottomDialogState extends State<BottomDialog> {
  int tastyPosition = 0;
  String storeCount = "请选择口味";
  List<CommodityTastyData> _tasty = new List();
  String tastyPrice = "";

  @override
  Widget build(BuildContext context) {
    _tasty = widget.tasty;
    tastyPrice = _tasty[0].tastePrice;
    print(tastyPrice);
    return new Container(
        child: new Stack(
      children: <Widget>[
        Container(
          height: 30.0,
          width: double.infinity,
          color: Colors.black54,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )),
        ),
        Stack(
          children: <Widget>[
            new Align(
              alignment: Alignment.topLeft,
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: new ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: widget.commodityListItemData.foodPicture,
                          fit: BoxFit.cover,
                          width: screenUtils.setWidgetWidth(74),
                          height: screenUtils.setFontSize(74),
                        )),
                    margin: EdgeInsets.all(screenUtils.setWidgetHeight(10)),
                  ),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(
                            top: screenUtils.setWidgetHeight(12)),
                        child: new RichText(
                            text: new TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: '￥',
                              style: TextStyle(
                                  fontSize: screenUtils.setFontSize(15),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w200)),
                          TextSpan(
                              text: tastyPrice.substring(
                                      0, tastyPrice.indexOf(".")) +
                                  ".",
                              style: TextStyle(
                                  fontSize: screenUtils.setFontSize(24),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500)),
                          TextSpan(
                              text: tastyPrice.substring(
                                  tastyPrice.indexOf(".") + 1,
                                  tastyPrice.length),
                              style: TextStyle(
                                  fontSize: screenUtils.setFontSize(20),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ])),
                      ),
                      new Text(
                        "库存：${storeCount}",
                        style: new TextStyle(color: Color(0xff8a8a8a)),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                            top: screenUtils.setWidgetHeight(5)),
                        child: new Text(
                          tastyName,
                          style: new TextStyle(
                              color: Color(0xff515151),
                              fontWeight: FontWeight.normal,
                              fontSize: screenUtils.setFontSize(15)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            new Container(
              margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(98)),
              child: new GridView.builder(
                  itemCount: _tasty.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 5 / 1.5,
                    crossAxisCount: 3,
                    mainAxisSpacing: screenUtils.setWidgetWidth(2),
                    crossAxisSpacing: screenUtils.setWidgetHeight(2),
                  ),
                  itemBuilder: (BuildContext context, int positions) {
                    return getCommodityTasty(
                        positions, context, widget.commodityListItemData.id);
                  }),
            ),
            new Align(
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: screenUtils.setWidgetHeight(50),
                  margin: EdgeInsets.only(
                      bottom: screenUtils.setWidgetHeight(15),
                      top: screenUtils.setWidgetHeight(16),
                      left: screenUtils.setWidgetWidth(20),
                      right: screenUtils.setWidgetWidth(20)),
                  child: new MaterialButton(
                    color: Color(0xff4ddfa9),
                    textColor: Colors.white,
                    child: new Text(
                      '加入购物车',
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      submitSnack(_tasty[tastyPosition].id.toString(), false);
                    },
                  ),
                ),
                alignment: Alignment.bottomCenter)
          ],
        )
      ],
    ));
  }

  Future submitSnack(String snackId, bool isDelete) async {
    var instance = await SpUtil.getInstance();

    var response =
        await HttpUtil.getInstance().post(Api.USER_SUBIMT_SHOP_SNACK, data: {
      "snackId": snackId,
      "userId": instance.getInt("id").toString(),
    });
    print("-------------------------");
    print(response);
    print("-------------------------");
    var encode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(encode);
    if (baseResponseEntity.code != 200) {
      ToastUtil.showErrorToast("添加商品失败");
      Navigator.pop(context);
    } else {
      EventBusUtil.getDefault().post("add"); //发送EnentBus消息
      Navigator.pop(context);
    }
  }

  String tastyName = "请选择商品种类";

  Widget getCommodityTasty(int position, BuildContext context, int commodity) {
    return new GestureDetector(
      onTap: () {
        print("--------------tastyPosition----------------");
        print(tastyPosition);
        print("--------------tastyPosition----------------");
        setState(() {
          tastyPosition = position;
          storeCount = _tasty[position].storeCount.toString();
          tastyName = _tasty[position].foodsTaste;
        });
      },
      child: new Container(
        margin: EdgeInsets.all(screenUtils.setWidgetHeight(2)),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 3,
        height: screenUtils.setWidgetHeight(45),
        decoration: new BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(screenUtils.setWidgetHeight(5))),
          border: new Border.all(
            //添加边框
            width: 1.3, //边框宽度
            color: tastyPosition == position ? Color(0xff4ddfa9) : Colors.white,
          ),
        ),
        child: new Text(
          _tasty[position].foodsTaste,
          style: new TextStyle(
              color:
                  tastyPosition == position ? Color(0xff4ddfa9) : Colors.grey,
              fontSize: screenUtils.setFontSize(15)),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

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
        physics: new BouncingScrollPhysics(),
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
                      width: MediaQuery.of(context).size.width,
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
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new GestureDetector(
                                    child: new Image.asset(
                                      "assert/imgs/img_shop_car_reduce.png",
                                      width: screenUtils.setWidgetWidth(22),
                                      height: screenUtils.setWidgetHeight(22),
                                    ),
                                    onTap: () {
                                      shopCarManagerByUserId(
                                          0,
                                          userShopCarDataGood.tasty.id
                                              .toString());
                                    },
                                  ),
                                  new Container(
                                      alignment: Alignment.center,
                                      width: screenUtils.setWidgetWidth(20),
                                      height: screenUtils.setWidgetHeight(24),
                                      child: new Text(
                                        userShopCarDataGood.tasty.count
                                            .toString(),
                                        style: new TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                screenUtils.setFontSize(14)),
                                      )),
                                  new GestureDetector(
                                    onTap: () {
                                      shopCarManagerByUserId(
                                          1,
                                          userShopCarDataGood.tasty.id
                                              .toString());
                                    },
                                    child: new Image.asset(
                                      "assert/imgs/ic_shopcar.png",
                                      width: screenUtils.setWidgetWidth(22),
                                      height: screenUtils.setWidgetHeight(22),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
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

  Future shopCarManagerByUserId(int type, String snackId) async {
    var instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance()
        .post(Api.SHOP_CAR_MANAGER_BY_USERID, data: {
      "snackId": snackId,
      "type": type.toString(),
      "userId": instance.getInt("id").toString()
    });

    print("ppppppppppppppppppppppppppppppppppppppppppp");
    print(response.toString());
    print("ppppppppppppppppppppppppppppppppppppppppppp");
    var decode = json.decode(response.toString());
    queryUserShopCarByUserId();
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

//  @override
//  void deactivate(){
//
//  }

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
