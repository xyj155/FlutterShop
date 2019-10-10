import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/business_shop_list_entity.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/logutil.dart';
import 'package:sauce_app/widget/rating_bar.dart';
class SquareShopLivePage extends StatefulWidget {
  @override
  _SquareShopLivePageState createState() => _SquareShopLivePageState();
  String param;

  SquareShopLivePage({Key key, this.param}) : super(key: key);
}

class _SquareShopLivePageState extends State<SquareShopLivePage> with AutomaticKeepAliveClientMixin  {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  void initState() {
    getShopByType();
    super.initState();
  }

  void getShopByType() async {
    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_SHOP_BUSINESS_BY_TYPE, data: {"type": widget.param.toString()});
    if (response != null) {
      var decode = json.decode(response.toString());
      var businessShopListEntity = BusinessShopListEntity.fromJson(decode);
      LogUtil.Log(
          '======================' + businessShopListEntity.code.toString());
      if (businessShopListEntity.code == 200) {
        setState(() {
          _shop_list = businessShopListEntity.data;
          LogUtil.Log('==================================================' +
              _shop_list.length.toString());
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }


  ScreenUtils screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return Container(
      color: Colors.white,
      child: new ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int position) {
          BusinessShopListData _business_shop_data = _shop_list[position];
          List<String> _item_tag = _business_shop_data.shopTag.split(",");
          var color = _business_shop_data.special;
          return new Column(
            children: <Widget>[new Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: screenUtils.setWidgetHeight(1)),
              padding: EdgeInsets.only(left:screenUtils.setWidgetHeight(11),top: screenUtils.setWidgetHeight(11)),
              child: new Row(
                children: <Widget>[
                  new ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    child: new FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        width: screenUtils.setWidgetWidth(80),
                        height: screenUtils.setWidgetHeight(65),
                        placeholder: "assert/imgs/loading.gif",
                        image: _business_shop_data.businessPicture),
                  ),
                  new Container(
                    width: screenUtils.setWidgetWidth(260),
                    padding:
                    EdgeInsets.only(left: screenUtils.setWidgetHeight(8)),
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
                              fontSize: screenUtils.setFontSize(16),
                              fontWeight: FontWeight.bold),
                        ),
                        new Text(
                          _business_shop_data.businessDesc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              color: Colors.grey,
                              fontSize: screenUtils.setFontSize(13)),
                        ),
                        new Container(
                          height: screenUtils.setWidgetHeight(15),
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
                                    fontSize: screenUtils.setFontSize(10)),
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
                margin: EdgeInsets.only(left: screenUtils.setWidgetWidth(95)),
                child:  new ListView.builder(
                    shrinkWrap: true, //解决无限高度问题
                    physics:NeverScrollableScrollPhysics(),//禁用滑动事件
                    itemCount: color.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext b, int position) {
//                     print(int.parse(color[position].bgColor));
                      return new Container(
                        margin: EdgeInsets.all(screenUtils.setWidgetHeight(2)),
                        child:  new Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                              child:   new Container(
                                alignment: Alignment.center,
                                width: screenUtils.setWidgetWidth(15),
                                height: screenUtils.setWidgetHeight(15),
                                color: hexToColor(color[position].bgColor),
                                child: new Text(
                                  color[position].tagShortName,
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: screenUtils.setFontSize(12)),
                                ),
                              ),
                            ),new Container(
                              margin: EdgeInsets.only(left: screenUtils.setWidgetWidth(5)),
                              child: new Text(color[position].content,style:
                              new TextStyle(color: Colors.grey,fontSize: screenUtils.setFontSize(13)),),
                            )
                          ],
                        ),
                      );
                    }),
              )],
          );
        },
        itemCount: _shop_list.length,
      ),
    );
  }
  Color hexToColor(String s) {
    if (s == null || s.length != 7 || int.tryParse(s.substring(1, 7), radix: 16) == null) {
      s = '#999999';
    }
    return new Color(int.parse(s.substring(1, 7), radix: 16) + 0xFF000000);
  }
  List<BusinessShopListData> _shop_list = new List();
}
