import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/logutil.dart';
import 'package:sauce_app/widget/common_dialog.dart';
import 'package:sauce_app/widget/input_text_fied.dart';
import 'square_game_item_page.dart';

class SquarePlayTogetherPage extends StatefulWidget {
  @override
  _SquarePlayTogetherPageState createState() => _SquarePlayTogetherPageState();
}

class _SquarePlayTogetherPageState extends State<SquarePlayTogetherPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  final List<HomeTabList> myTabs = <HomeTabList>[
    new HomeTabList('全部', new SquareGameItemPage()),
    new HomeTabList(
        '王者',
        new SquareGameItemPage(
          param: "1",
        )),
    new HomeTabList(
        '吃鸡',
        new SquareGameItemPage(
          param: "2",
        )),
    new HomeTabList(
        '学习',
        new SquareGameItemPage(
          param: "3",
        )),
    new HomeTabList(
        '追剧',
        new SquareGameItemPage(
          param: "4",
        )),
    new HomeTabList(
        '早起',
        new SquareGameItemPage(
          param: "5",
        )),
    new HomeTabList(
        '连麦',
        new SquareGameItemPage(
          param: "6",
        )),
    new HomeTabList(
        '话痨',
        new SquareGameItemPage(
          param: "7",
        )),
    new HomeTabList(
        '找对象',
        new SquareGameItemPage(
          param: "8",
        )),
    new HomeTabList(
        '其他',
        new SquareGameItemPage(
          param: "9",
        ))
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          body: new NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  child: SliverAppBar(
                      leading: new IconButton(
                          icon: new Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      backgroundColor: Colors.white,
                      floating: true,
                      pinned: true,
                      iconTheme: new IconThemeData(color: Colors.black),
                      snap: false,
                      forceElevated: innerBoxIsScrolled,
                      title: TabBar(
                        indicatorColor: Color(0xff4ddfa9),
                        indicatorSize: TabBarIndicatorSize.label,
                        unselectedLabelStyle: new TextStyle(
                            fontSize: screenUtils.setFontSize(17)),
                        labelStyle: new TextStyle(
                            fontSize: screenUtils.setFontSize(17)),
                        labelColor: Colors.black,
                        unselectedLabelColor: Color(0xff707070),
                        indicatorWeight: screenUtils.setFontSize(5),
                        isScrollable: true,
                        tabs: myTabs.map((HomeTabList item) {
                          return new Tab(
                              text: item.text == null ? '错误' : item.text);
                        }).toList(),
                      )),
                ),
              ];
            },
            body:new Container(
              margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(60)),
              child:  TabBarView(
                children: myTabs.map((item) {
                  return item.goodList;
                }).toList(),
              ),
            )
          ),
          bottomNavigationBar: new Container(
            width: MediaQuery.of(context).size.width,
            height: screenUtils.setWidgetHeight(50),
            child: new MaterialButton(
              color: Color(0xff4ddfa9),
              textColor: Colors.white,
              child: new Text(
                '我也想找人玩',
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return new ChooseGameName();
                }));
              },
            ),
          ),
        ));
  }
}

class ChooseGameName extends StatefulWidget {
  @override
  ChooseGameNameState createState() => new ChooseGameNameState();
}

class ChooseGameNameState extends State<ChooseGameName> {
  String gameType = "";
  String gameContent = "请选择你想参与的种类";
  String gameName = "";
  ScreenUtils screenUtils = new ScreenUtils();
  List<PickerItem> list = new List();
  var data = ["王者", "吃鸡", "学习", "追剧", "早起", "连麦", "话痨", "找对象", "其他"];
  String remark = "";

  void loadDate() {
    for (int i = 0; i < data.length; i++) {
      list.add(new PickerItem(text: new Text(data[i]), value: data[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: BackUtil.NavigationBack(context, "发布"),
      body: new Container(
        margin: EdgeInsets.all(screenUtils.setWidgetHeight(8)),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                Picker picker = new Picker(
                    textStyle: new TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: screenUtils.setFontSize(12)),
                    itemExtent: screenUtils.setWidgetHeight(31),
                    adapter: PickerDataAdapter(
                      data: list,
                    ),
                    height: screenUtils.setWidgetHeight(210),
                    changeToFirst: true,
                    cancelText: "取消",
                    confirmText: "确定",
                    cancelTextStyle: new TextStyle(
                        color: Color(0xffbfbfbf),
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                    confirmTextStyle: new TextStyle(
                        color: Color(0xff19bebf),
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                    columnPadding: const EdgeInsets.all(30.0),
                    onConfirm: (Picker picker, List value) {
                      this.setState(() {
                        gameContent = "参与类别：" + data[value[0]];
                        gameName = data[value[0]];
                        gameType =
                            (data.indexOf(data[value[0]]) + 1).toString();
                        LogUtil.Log(gameName + gameType);
//                      countryCode = countryList[value[0]];
                      });
                    });
                picker.showModal(context);
              },
              child: new Container(
                color: Color(0xfff8f8f8),
                padding: EdgeInsets.only(left: screenUtils.setWidgetWidth(15)),
                alignment: Alignment.centerLeft,
                height: screenUtils.setWidgetHeight(55),
                margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(16)),
                child: new Text(
                  gameContent,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xff8a8a8a),
                      fontSize: screenUtils.setFontSize(15),
                      decoration: TextDecoration.none),
                ),
              ),
            ),
            new Container(
              color: Color(0xfff8f8f8),
              alignment: Alignment.center,
              height: screenUtils.setWidgetHeight(55),
              margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(16)),
              child: new ITextField(
                  contentHeight: screenUtils.setWidgetHeight(15),
                  keyboardType: ITextInputType.text,
                  hintText: '一句话的介绍（不得超过15个字）',
                  deleteIcon: new Image.asset(
                    "assert/imgs/icon_image_delete.png",
                    width: screenUtils.setWidgetWidth(18),
                    height: screenUtils.setWidgetHeight(55),
                  ),
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: screenUtils.setFontSize(15)),
                  inputBorder: InputBorder.none,
                  fieldCallBack: (content) {
                    setState(() {
                      remark = content;
                    });
                  }),
            ),
            new Container(
              margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(8)),
              child: new Text(
                "不得输入不合法信息，一经发现将会封号处理！",
                style: new TextStyle(
                    color: Colors.grey, fontSize: screenUtils.setFontSize(12)),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: new Container(
        width: MediaQuery.of(context).size.width,
        height: screenUtils.setWidgetHeight(50),
        child: new MaterialButton(
          color: Color(0xff4ddfa9),
          textColor: Colors.white,
          child: new Text(
            '发布',
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            showDialog<Null>(
                context: context, //BuildContext对象
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return new LoadingDialog(
                  );
                });
            submitGameInvite();
//          Navigator.push(context, new MaterialPageRoute(builder: (_) {
//            return new ChooseGameName();
//          }));
          },
        ),
      ),
    );
  }

  Future submitGameInvite() async {
    var response =
        await HttpUtil.getInstance().post(Api.SUBMIT_USER_GAME_INVITE, data: {
      "userId": "241414",
      "gameType": gameType,
      "gameName": gameName,
      "describe": remark,
    });
    var decode = json.decode(response.toString());
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if(baseResponseEntity.code==200){
      Navigator.pop(context);
      ToastUtil.showCommonToast("提交成功");
      Navigator.pop(context);
//      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_){
//        return
//      }), predicate)
    }else{
      Navigator.pop(context);
    }
    print(response);
  }

  @override
  void initState() {
    // TODO: implement initState
    loadDate();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
