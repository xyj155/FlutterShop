import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/commodity_tasty_entity.dart';
import 'package:sauce_app/gson/shop_kind_list_entity.dart';
import 'package:sauce_app/gson/commodity_list_item_entity.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/widget/loading_dialog.dart';
//import 'package:sauce_app/widget/common_dialog.dart';
import 'package:tobias/tobias.dart' as tobias;
import 'package:flutter/material.dart';

class LittleShopPage extends StatefulWidget {
  @override
  _LittleShopPageState createState() => _LittleShopPageState();
}

ScreenUtils screenUtils = new ScreenUtils();

class _LittleShopPageState extends State<LittleShopPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int index;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    getCommodityKindItem();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return Scaffold(
        appBar: BackUtil.NavigationBack(context, "小卖部"),
        body: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Expanded(
                flex: 2,
                child: Container(
                  color: Colors.white,
                  child: new ListView.builder(
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
        ));
  }

  List<ShopKindListData> _commodity_kind = new List();
  int shopId;

  getCommodityKindItem() async {
    var response = await HttpUtil.getInstance().get(Api.COMMODITY_KIND_ITEM);
    var decode = json.decode(response);
    var shopKindListEntity = ShopKindListEntity.fromJson(decode);
    if (shopKindListEntity.code == 200) {
      setState(() {
        _commodity_kind = shopKindListEntity.data;
        index = 0;
        shopId = shopKindListEntity.data[0].id;
        setState(() {
          getCommodityById(shopId);
        });
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
          setState(() {
            getCommodityById(_commodity_kind[i].id);
          });
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
                showDialog<Null>(
                    context: context, //BuildContext对象
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new LoadingDialog( //调用对话框
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

  Widget getCommodityDetail(BuildContext context, int commodity,
      CommodityListItemData commodityListItemData) {
    return new Container(
        child: Stack(
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
                      image: commodityListItemData.foodPicture,
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
                    padding:
                        EdgeInsets.only(top: screenUtils.setWidgetHeight(12)),
                    child: new RichText(
                        text: new TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: '￥',
                          style: TextStyle(
                              fontSize: screenUtils.setFontSize(15),
                              color: Colors.black,
                              fontWeight: FontWeight.w200)),
                      TextSpan(
                          text: "10.",
                          style: TextStyle(
                              fontSize: screenUtils.setFontSize(24),
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: "20",
                          style: TextStyle(
                              fontSize: screenUtils.setFontSize(20),
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                    ])),
                  ),
                  new Text(
                    "库存：10000",
                    style: new TextStyle(color: Color(0xff8a8a8a)),
                  ),
                  new Container(
                    padding:
                        EdgeInsets.only(top: screenUtils.setWidgetHeight(5)),
                    child: new Text(
                      "请选择商品种类",
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
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: screenUtils.setWidgetWidth(5),
                crossAxisSpacing: screenUtils.setWidgetHeight(5),
              ),
              itemBuilder: (BuildContext context, int position) {
                return getCommodityTasty(position, context, commodity);
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
                onPressed: () {},
              ),
            ),
            alignment: Alignment.bottomCenter)
      ],
    ));
  }

  int tastyIndex = 0;
  List<CommodityTastyData> _tasty = new List();

  getTastyById(CommodityListItemData commodity, BuildContext context) async {
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
            builder: (BuildContext contexts) {
              print("----------------------++----------------------");
              return getCommodityDetail(contexts, commodity.id, commodity);
            });
      });
    } else {
      Navigator.pop(context);
      ToastUtil.showErrorToast("获取商品信息错误");
    }
  }

  Widget getCommodityTasty(int position, BuildContext context, int commodity) {
    return new Container(
      alignment: Alignment.center,
      child: new Text(_tasty[position].foodsTaste),
    );
  }
}
