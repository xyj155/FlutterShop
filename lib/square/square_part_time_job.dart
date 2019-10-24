import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/part_job_name_kind.dart';
import 'package:sauce_app/gson/part_time_job_list_entity.dart';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/gson/single_part_time_job_detail_entity.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';

import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'dart:convert';

import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/widget/input_text_fied.dart';
import 'package:sauce_app/widget/loading_dialog.dart';

class PartTimeJobPage extends StatefulWidget {
  PartTimeJobPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

const List<Map<String, dynamic>> JOB_TYPE = [
  {"title": "全部兼职", "id": "0"},
  {"title": "优质兼职", "id": "1"},
  {"title": "工资金额", "id": "2"},
  {"title": "最新兼职", "id": "3"},
];

const List<Map<String, dynamic>> LOCATION = [
  {"title": "全部地区", "id": "964"},
  {"title": "南湖区", "id": "965"},
  {"title": "秀洲区", "id": "966"},
  {"title": "嘉善县", "id": "967"},
  {"title": "海盐县", "id": "968"},
  {"title": "海宁市", "id": "969"},
  {"title": "平湖市", "id": "970"},
  {"title": "桐乡市", "id": "971"},
];

const int LOCATION_INDEX = 0;

const int TYPE_INDEX = 0;
const int KIND_INDEX = 0;

class _MyHomePageState extends State<PartTimeJobPage> {
  ScrollController scrollController;
  var JOB_JSON = "";
  List JOB_LIST = new List();
  ScreenUtils screenUtils = new ScreenUtils();

  @override
  void initState() {
    scrollController = new ScrollController();
    globalKey = new GlobalKey();
    setDropJobKindMenu();
    getPartTimeJobByPage(PARAM_LOCATION, PARAM_JOBTYPE, PARAM_JOBKIND);
    super.initState();
  }

  List<PartTimeJobListData> _job_list = new List();
  var PARAM_LOCATION = "964";
  var PARAM_JOBKIND = "2";
  var PARAM_JOBTYPE = "0";

  Future getPartTimeJobByPage(
      String location, String jobType, String jobKind) async {
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_PARTTIME_JOB_BY_PAGE,
        data: {"location": location, "jobType": jobType, "jobKind": jobKind});

    var decode = json.decode(response);

    var partTimeJobListEntity = PartTimeJobListEntity.fromJson(decode);
    print("------------------------------");
    print({"location": location, "jobType": jobType, "jobKind": jobKind});
    print(partTimeJobListEntity.data.length);
    print("------------------------------");
    _job_list.clear();
    if (partTimeJobListEntity.code == 200) {
      setState(() {
        _job_list = partTimeJobListEntity.data;
      });
    } else {
      ToastUtil.showCommonToast("没有对应的兼职信息哦！");
    }
  }

  Future setDropJobKindMenu() async {
    var response =
        await HttpUtil.getInstance().get(Api.QUERY_PARTTIME_JOB_KIND);

    var decode = json.decode(response);
    var partJobKindEntity = PartJobNameEntity.fromJson(decode);
    if (partJobKindEntity.code == 200) {
      setState(() {
        JOB_JSON = json.encode(partJobKindEntity.data);
        JOB_LIST = json.decode(JOB_JSON);
      });
    } else {
      ToastUtil.showErrorToast("请求失败");
    }
  }

  DropdownMenu buildDropdownMenu() {
    return new DropdownMenu(maxMenuHeight: kDropdownMenuItemHeight * 10,
        //  activeIndex: activeIndex,
        menus: [
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: LOCATION_INDEX,
                  data: LOCATION,
                  itemBuilder: buildCheckItem,
                );
              },
              height: kDropdownMenuItemHeight * LOCATION.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownListMenu(
                  selectedIndex: TYPE_INDEX,
                  data: JOB_TYPE,
                  itemBuilder: buildCheckItem,
                );
              },
              height: kDropdownMenuItemHeight * JOB_TYPE.length),
          new DropdownMenuBuilder(
              builder: (BuildContext context) {
                return new DropdownTreeMenu(
                  selectedIndex: 0,
                  subSelectedIndex: 0,
                  itemExtent: screenUtils.setWidgetHeight(45),
                  background: Colors.white,
                  subBackground: Colors.white,
                  itemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    if (!selected) {
                      return new DecoratedBox(
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: Divider.createBorderSide(context))),
                          child: new Padding(
                              padding: EdgeInsets.only(
                                  left: screenUtils.setWidgetHeight(15)),
                              child: new Row(
                                children: <Widget>[
                                  new Text(
                                    data['title'],
                                    style: new TextStyle(),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )));
                    } else {
                      return new DecoratedBox(
                          decoration: new BoxDecoration(
                              border: new Border(
                                  top: Divider.createBorderSide(context),
                                  bottom: Divider.createBorderSide(context))),
                          child: new Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                      color: Theme.of(context).primaryColor,
                                      width: 3.0,
                                      height: 20.0),
                                  new Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              screenUtils.setWidgetHeight(15)),
                                      child: new Text(
                                        data['title'],
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              )));
                    }
                  },
                  subItemBuilder:
                      (BuildContext context, dynamic data, bool selected) {
                    Color color = selected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.body1.color;

                    return new Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: screenUtils.setWidgetHeight(15)),
                      height: screenUtils.setWidgetHeight(45),
                      child: new Text(data['title'],
                          style: new TextStyle(color: color),
                          textAlign: TextAlign.start),
                    );
                  },
                  getSubData: (dynamic data) {
                    return data['children'];
                  },
                  data: JOB_LIST,
                );
              },
              height: screenUtils.setWidgetHeight(350))
        ]);
  }

  DropdownHeader buildDropdownHeader({DropdownMenuHeadTapCallback onTap}) {
    return new DropdownHeader(
      onTap: onTap,
      titles: [
        LOCATION[LOCATION_INDEX],
        JOB_TYPE[TYPE_INDEX],
        JOB_LIST[KIND_INDEX]['children'][0]
      ],
    );
  }

  Widget buildFixHeaderDropdownMenu() {
    return new DefaultDropdownMenuController(
      child: new Column(
        children: <Widget>[
          new Container(
            color: Colors.white,
            child: buildDropdownHeader(),
          ),
          new Expanded(
              child: new Stack(
            children: <Widget>[
              new ListView.builder(
                physics: new ClampingScrollPhysics(),
                itemCount: _job_list.length,
                itemBuilder: (BuildContext context, int position) {
                  return setJobItem(context, position);
                },
              ),
              buildDropdownMenu()
            ],
          ))
        ],
      ),
      onSelected: ({int menuIndex, int index, int subIndex, dynamic data}) {
        _job_list.clear();
        switch (menuIndex) {
          case 0:
            setState(() {
              PARAM_LOCATION = LOCATION[index]["id"];
              getPartTimeJobByPage(
                  PARAM_LOCATION, PARAM_JOBTYPE, PARAM_JOBKIND);
            });
            break;
          case 1:
            setState(() {
              PARAM_JOBTYPE = JOB_TYPE[index]["id"];
              getPartTimeJobByPage(
                  PARAM_LOCATION, PARAM_JOBTYPE, PARAM_JOBKIND);
            });
            break;
          case 2:
            setState(() {
              PARAM_JOBKIND =
                  JOB_LIST[index]['children'][subIndex]["id"].toString();
              getPartTimeJobByPage(
                  PARAM_LOCATION, PARAM_JOBTYPE, PARAM_JOBKIND);
            });
            break;
        }
      },
    );
  }

  GlobalKey globalKey;

  Widget setJobItem(BuildContext buildContext, int position) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new CustomRouteSlide(new PartTimeJobDetailPage(
              jobId: _job_list[position].id.toString(),
            )));
      },
      child: new Stack(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(bottom: screenUtils.setWidgetHeight(10)),
            color: Colors.white,
            padding: EdgeInsets.only(
                left: screenUtils.setWidgetWidth(15),
                bottom: screenUtils.setWidgetHeight(10)),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Text(
                    _job_list[position].jobName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: screenUtils.setFontSize(17)),
                    textAlign: TextAlign.left,
                  ),
                  width: screenUtils.setWidgetWidth(250),
                  height: screenUtils.setWidgetHeight(45),
                  alignment: Alignment.centerLeft,
                ),
                new Container(
                  padding:
                      EdgeInsets.only(bottom: screenUtils.setWidgetHeight(8)),
                  child: new Text(
                    _job_list[position].jobShop,
                    style: new TextStyle(
                        color: Colors.black54,
                        fontSize: screenUtils.setFontSize(15)),
                  ),
                ),
                new Row(
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      child: new Container(
                        padding: EdgeInsets.only(
                            left: screenUtils.setWidgetWidth(5),
                            right: screenUtils.setWidgetWidth(5),
                            top: screenUtils.setWidgetHeight(3),
                            bottom: screenUtils.setWidgetHeight(3)),
                        child: new Text(
                          _job_list[position].location,
                          style: new TextStyle(
                              color: Colors.black38,
                              fontSize: screenUtils.setFontSize(12)),
                        ),
                        color: Color(0xfff4f4f4),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(
                          left: screenUtils.setWidgetWidth(10),
                          right: screenUtils.setWidgetWidth(10)),
                      child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        child: new Container(
                          padding: EdgeInsets.only(
                              left: screenUtils.setWidgetWidth(5),
                              right: screenUtils.setWidgetWidth(5),
                              top: screenUtils.setWidgetHeight(3),
                              bottom: screenUtils.setWidgetHeight(3)),
                          child: new Text(
                            _job_list[position].jobKind,
                            style: new TextStyle(
                                color: Colors.black38,
                                fontSize: screenUtils.setFontSize(12)),
                          ),
                          color: Color(0xfff4f4f4),
                        ),
                      ),
                    ),
                    new ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      child: new Container(
                        padding: EdgeInsets.only(
                            left: screenUtils.setWidgetWidth(5),
                            right: screenUtils.setWidgetWidth(5),
                            top: screenUtils.setWidgetHeight(3),
                            bottom: screenUtils.setWidgetHeight(3)),
                        child: new Text(
                          _job_list[position].jobDays,
                          style: new TextStyle(
                              color: Colors.black38,
                              fontSize: screenUtils.setFontSize(12)),
                        ),
                        color: Color(0xfff4f4f4),
                      ),
                    ),
                  ],
                ),
                new Container(
                  padding: EdgeInsets.only(top: screenUtils.setWidgetHeight(7)),
                  child: new RichText(
                    text: TextSpan(
                        style: new TextStyle(color: Colors.black45),
                        children: <TextSpan>[
                          new TextSpan(
                              text: "￥",
                              style: new TextStyle(color: Colors.redAccent)),
                          new TextSpan(
                              text: _job_list[position].jobPay,
                              style: new TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: screenUtils.setFontSize(19))),
                          new TextSpan(
                              text: " / " + _job_list[position].payUnit,
                              style: new TextStyle(
                                  color: Colors.black45,
                                  fontSize: screenUtils.setFontSize(13)))
                        ]),
                  ),
                )
              ],
            ),
          ),
          new Positioned(
            right: screenUtils.setWidgetHeight(10),
            bottom: screenUtils.setWidgetHeight(20),
            child: new Image.asset(
              "assert/imgs/part_job_vertify.png",
              width: screenUtils.setWidgetWidth(18),
              height: screenUtils.setWidgetHeight(18),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "兼职"),
      body: JOB_JSON.isEmpty ? new Container() : buildFixHeaderDropdownMenu(),
    );
  }
}

class PartTimeJobDetailPage extends StatefulWidget {
  String jobId;

//  PartTimeJobDetailPage({Key key, this.jobId}) : super(key: key);
  PartTimeJobDetailPage({Key key, @required this.jobId}) : super(key: key);

  @override
  _PartTimeJobDetailPageState createState() => _PartTimeJobDetailPageState();
}

class _PartTimeJobDetailPageState extends State<PartTimeJobDetailPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getJobDetailById();
    getUserInformation();
  }

  SinglePartTimeJobDetailData singlePartTimeJobDetailData;
  List<SinglePartTimeJobDetailDataPursejob> _job_list = new List();

  void getJobDetailById() async {
    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_PARTTIME_JOB_BY_ID, data: {"jobId": widget.jobId});
    print(response);
    var decode = json.decode(response);
    var singlePartTimeJobDetailEntity =
        SinglePartTimeJobDetailEntity.fromJson(decode);
    var code = singlePartTimeJobDetailEntity.code;

    if (code == 200) {
      setState(() {
        singlePartTimeJobDetailData = singlePartTimeJobDetailEntity.data[0];
        _job_list = singlePartTimeJobDetailData.purseJob;
      });
    } else {
      ToastUtil.showErrorToast("获取数据信息失败!");
    }
  }

  ScreenUtils screenUtil = new ScreenUtils();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "详情"),
      body: new Container(
        color: Colors.white,
        child: singlePartTimeJobDetailData == null
            ? new Center(
                child: new CupertinoActivityIndicator(
                    radius: screenUtil.setWidgetHeight(16)),
              )
            : new CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  new SliverPadding(
                    padding: EdgeInsets.only(
                        left: screenUtil.setWidgetWidth(15),
                        right: screenUtil.setWidgetWidth(15),
                        top: screenUtil.setWidgetHeight(8)),
                    sliver: new SliverList(
                      delegate: new SliverChildListDelegate(
                        <Widget>[
                          new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.only(
                                    top: screenUtil.setWidgetHeight(10),
                                    bottom: screenUtil.setWidgetHeight(10)),
                                alignment: Alignment.centerLeft,
                                child: new Text(
                                  singlePartTimeJobDetailData.jobName,
                                  textAlign: TextAlign.start,
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenUtil.setFontSize(19)),
                                ),
                              ),
                              new Text(
                                "工作地点：${singlePartTimeJobDetailData.jobAddress}",
                                textAlign: TextAlign.start,
                                style: new TextStyle(
                                    color: Colors.black45,
                                    fontSize: screenUtil.setFontSize(15)),
                              ),
                              new Container(
                                margin: EdgeInsets.only(
                                    top: screenUtil.setWidgetHeight(15),
                                    bottom: screenUtil.setWidgetHeight(15)),
                                child: new Row(
                                  children: <Widget>[
                                    new RichText(
                                      text: new TextSpan(
                                          style: new TextStyle(
                                              color: Colors.black45,
                                              fontSize:
                                                  screenUtil.setFontSize(15)),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text:
                                                    singlePartTimeJobDetailData
                                                        .jobPay,
                                                style: new TextStyle(
                                                    color: Colors.red,
                                                    fontSize: screenUtil
                                                        .setFontSize(24))),
                                            new TextSpan(
                                                text: "元",
                                                style: new TextStyle(
                                                    color: Colors.red,
                                                    fontSize: screenUtil
                                                        .setFontSize(12))),
                                            new TextSpan(
                                                text:
                                                    " / ${singlePartTimeJobDetailData.payUnit}  ",
                                                style: new TextStyle(
                                                    color: Colors.red,
                                                    fontSize: screenUtil
                                                        .setFontSize(12))),
                                          ]),
                                    ),
                                    new Container(
                                      margin: EdgeInsets.only(
                                          left: screenUtil.setWidgetWidth(10)),
                                      child: new ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        child: new Container(
                                          padding: EdgeInsets.only(
                                              left:
                                                  screenUtil.setWidgetWidth(5),
                                              right:
                                                  screenUtil.setWidgetWidth(5),
                                              top:
                                                  screenUtil.setWidgetHeight(3),
                                              bottom: screenUtil
                                                  .setWidgetHeight(3)),
                                          child: new Text(
                                            singlePartTimeJobDetailData.jobDays,
                                            style: new TextStyle(
                                                color: Colors.black38,
                                                fontSize:
                                                    screenUtil.setFontSize(12)),
                                          ),
                                          color: Color(0xfff4f4f4),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              new Container(
                                height: screenUtil.setWidgetHeight(8),
                                color: Color(0xfffafafa),
                              ),
                              new Container(
                                padding: EdgeInsets.only(
                                    bottom: screenUtil.setWidgetHeight(4),
                                    top: screenUtil.setWidgetHeight(4)),
                                child: new Text("工作详情",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: screenUtil.setFontSize(18),
                                        fontWeight: FontWeight.bold)),
                              ),
                              new Container(
                                padding: EdgeInsets.only(
                                    top: screenUtil.setWidgetHeight(8),
                                    bottom: screenUtil.setWidgetHeight(8)),
                                child: new Text(
                                  "${singlePartTimeJobDetailData.jobDescription}",
                                  textAlign: TextAlign.start,
                                  style: new TextStyle(
                                      color: Colors.black45,
                                      fontSize: screenUtil.setFontSize(15)),
                                ),
                              ),
                              new Container(
                                height: screenUtil.setWidgetHeight(8),
                                color: Color(0xfffafafa),
                              ),
                              new Container(
                                padding: EdgeInsets.only(
                                    top: screenUtil.setWidgetHeight(8),
                                    bottom: screenUtil.setWidgetHeight(8)),
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Container(
                                      margin: EdgeInsets.only(
                                          bottom:
                                              screenUtil.setWidgetHeight(9)),
                                      child: new Text(
                                        "提供者信息",
                                        style: new TextStyle(
                                            color: Colors.black54,
                                            fontSize:
                                                screenUtil.setFontSize(16)),
                                      ),
                                    ),
                                    new Container(
                                      child: new Row(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  "assert/imgs/loading.gif",
                                              image:
                                                  "${singlePartTimeJobDetailData.avatar}",
                                              fit: BoxFit.cover,
                                              width:
                                                  screenUtil.setWidgetWidth(56),
                                              height: screenUtil
                                                  .setWidgetHeight(56),
                                            ),
                                          ),
                                          new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              new Text(
                                                "提供者：${singlePartTimeJobDetailData.providerName}",
                                                style: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize: screenUtil
                                                        .setFontSize(16)),
                                              ),
                                              new Container(
                                                height: screenUtil
                                                    .setWidgetHeight(4),
                                              ),
                                              new Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                    child: new Container(
                                                      padding: EdgeInsets.only(
                                                          left: screenUtil
                                                              .setWidgetWidth(
                                                                  4),
                                                          right: screenUtil
                                                              .setWidgetWidth(
                                                                  4),
                                                          top: screenUtil
                                                              .setWidgetHeight(
                                                                  2),
                                                          bottom: screenUtil
                                                              .setWidgetHeight(
                                                                  2)),
                                                      color: Color(0xff4fe1b1),
                                                      child: new Text(
                                                        singlePartTimeJobDetailData
                                                                    .isVerify ==
                                                                1
                                                            ? "已认证"
                                                            : "未认证",
                                                        style: new TextStyle(
                                                            color: Colors.white,
                                                            fontSize: screenUtil
                                                                .setFontSize(
                                                                    8)),
                                                      ),
                                                    ),
                                                  ),
                                                  new Container(
                                                    width: screenUtil
                                                        .setWidgetWidth(5),
                                                  ),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            28),
                                                    child: new Container(
                                                      padding: EdgeInsets.only(
                                                          left: screenUtil
                                                              .setWidgetWidth(
                                                                  4),
                                                          right: screenUtil
                                                              .setWidgetWidth(
                                                                  4),
                                                          top: screenUtil
                                                              .setWidgetHeight(
                                                                  2),
                                                          bottom: screenUtil
                                                              .setWidgetHeight(
                                                                  2)),
                                                      color: Color(0xfffed257),
                                                      child: new Text(
                                                        "提供职位:${singlePartTimeJobDetailData.provideCount}",
                                                        style: new TextStyle(
                                                            color: Colors.white,
                                                            fontSize: screenUtil
                                                                .setFontSize(
                                                                    8)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                height: screenUtil.setWidgetHeight(8),
                                color: Color(0xfffafafa),
                              ),
                              new Container(
                                margin: EdgeInsets.only(
                                    top: screenUtil.setWidgetHeight(10),
                                    bottom: screenUtil.setWidgetHeight(10)),
                                child: new Stack(
                                  children: <Widget>[
                                    new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Container(
                                          child: new Row(
                                            children: <Widget>[
                                              new Image.asset(
                                                "assert/imgs/part_time_job_alert.png",
                                                height: screenUtil
                                                    .setWidgetHeight(15),
                                                width: screenUtil
                                                    .setWidgetWidth(15),
                                              ),
                                              new Text(
                                                "  温馨提示",
                                                style: new TextStyle(
                                                    color: Colors.red,
                                                    fontSize: screenUtil
                                                        .setFontSize(12)),
                                              )
                                            ],
                                          ),
                                          margin: EdgeInsets.only(
                                              bottom: screenUtil
                                                  .setWidgetHeight(4)),
                                        ),
                                        new Text(
                                          "若商家要求缴纳中介费或押金，请勿支付并且向我们平台举报！",
                                          style: new TextStyle(
                                              color: Colors.red,
                                              fontSize:
                                                  screenUtil.setFontSize(9)),
                                        ),
                                      ],
                                    ),
                                    new Align(
                                      alignment: Alignment.centerRight,
                                      child: new ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        child: new Container(
                                          padding: EdgeInsets.only(
                                              left:
                                                  screenUtil.setWidgetWidth(5),
                                              right:
                                                  screenUtil.setWidgetWidth(5),
                                              top:
                                                  screenUtil.setWidgetHeight(3),
                                              bottom: screenUtil
                                                  .setWidgetHeight(3)),
                                          child: new Text(
                                            "举报",
                                            style: new TextStyle(
                                                color: Colors.black38,
                                                fontSize:
                                                    screenUtil.setFontSize(15)),
                                          ),
                                          color: Color(0xfff4f4f4),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          new Container(
                            height: screenUtil.setWidgetHeight(8),
                            color: Color(0xfffafafa),
                          ),
                          new ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _job_list.length,
                            itemBuilder: (BuildContext context, int position) {
                              return setJobItem(context, position);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: new Container(
        width: MediaQuery.of(context).size.width,
        height: screenUtil.setWidgetHeight(50),
        child: new MaterialButton(
          color: Color(0xff4ddfa9),
          textColor: Colors.white,
          child: new Text(
            '报名',
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return new Container(
                    child: new Stack(
                      children: <Widget>[
                        new Container(
                          height: 30.0,
                          width: double.infinity,
                          color: Colors.black54,
                        ),
                        new Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                        ),
                        new Container(
                          padding: EdgeInsets.only(top: screenUtil.setWidgetHeight(9)),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Container(
                                    margin: EdgeInsets.only(
                                        left: screenUtil.setWidgetWidth(20),
                                        right: screenUtil.setWidgetWidth(10),
                                        bottom: screenUtil.setWidgetHeight(8),
                                        top: screenUtil.setWidgetHeight(10)),
                                    child: new ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              screenUtil.setWidgetHeight(56))),
                                      child: new Image.network(
                                        _avatar,
                                        width: screenUtil.setWidgetHeight(55),
                                        height: screenUtil.setWidgetHeight(58),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  new Expanded(
                                      child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        _nickname,
                                        style: new TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                screenUtil.setFontSize(20)),
                                      ),
                                      new Text(
                                        _school,
                                        style: new TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.normal,
                                            fontSize:
                                                screenUtil.setFontSize(15)),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                              new Container(
                                color: Color(0xfff8f8f8),
                                alignment: Alignment.center,
                                height: screenUtil.setWidgetHeight(55),
                                margin: EdgeInsets.only(
                                    top: screenUtil.setWidgetHeight(16),
                                    left: screenUtil.setWidgetWidth(25),
                                    right: screenUtil.setWidgetWidth(25)),
                                child: new ITextField(
                                    contentHeight:
                                        screenUtil.setWidgetHeight(15),
                                    keyboardType: ITextInputType.number,
                                    hintText: '请输入联系方式',
                                    deleteIcon: new Image.asset(
                                      "assert/imgs/icon_image_delete.png",
                                      width: screenUtil.setWidgetWidth(18),
                                      height: screenUtil.setWidgetHeight(55),
                                    ),
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenUtil.setFontSize(15)),
                                    inputBorder: InputBorder.none,
                                    fieldCallBack: (content) {
//                                      telPhone = content;
                                      _user_tel = content;
//                                      LogUtil.Log(telPhone);
                                    }),
                              ),
                              new Container(
                                color: Color(0xfff8f8f8),
                                alignment: Alignment.center,
                                height: screenUtil.setWidgetHeight(55),
                                margin: EdgeInsets.only(
                                    top: screenUtil.setWidgetHeight(7),
                                    left: screenUtil.setWidgetWidth(25),
                                    right: screenUtil.setWidgetWidth(25)),
                                child: new ITextField(
                                    contentHeight:
                                        screenUtil.setWidgetHeight(15),
                                    keyboardType: ITextInputType.emailAddress,
                                    hintText: '请输入你的邮箱',
                                    deleteIcon: new Image.asset(
                                      "assert/imgs/icon_image_delete.png",
                                      width: screenUtil.setWidgetWidth(18),
                                      height: screenUtil.setWidgetHeight(55),
                                    ),
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenUtil.setFontSize(15)),
                                    inputBorder: InputBorder.none,
                                    fieldCallBack: (content) {
//                                      telPhone = content;
                                      _user_email = content;
//                                      LogUtil.Log(telPhone);
                                    }),
                              ),
                              new Container(
                                color: Color(0xfff8f8f8),
                                alignment: Alignment.center,
                                height: screenUtil.setWidgetHeight(55),
                                margin: EdgeInsets.only(
                                    top: screenUtil.setWidgetHeight(7),
                                    left: screenUtil.setWidgetWidth(25),
                                    right: screenUtil.setWidgetWidth(25)),
                                child: new ITextField(
                                    contentHeight:
                                        screenUtil.setWidgetHeight(15),
                                    keyboardType: ITextInputType.text,
                                    hintText: '请输入你的真实姓名',
                                    deleteIcon: new Image.asset(
                                      "assert/imgs/icon_image_delete.png",
                                      width: screenUtil.setWidgetWidth(18),
                                      height: screenUtil.setWidgetHeight(55),
                                    ),
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenUtil.setFontSize(15)),
                                    inputBorder: InputBorder.none,
                                    fieldCallBack: (content) {
                                      _user_name = content;
//                                      telPhone = content;
//                                      LogUtil.Log(telPhone);
                                    }),
                              ),
                            ],
                          ),
                        ),
                        new Positioned(
                            left: screenUtil.setWidgetWidth(25),
                            right: screenUtil.setWidgetWidth(25),
                            bottom: screenUtil.setWidgetHeight(10),
                            child: new Container(
                              width: MediaQuery.of(context).size.width -
                                  screenUtil.setWidgetWidth(50),
                              color: Color(0xff7c7f88),
                              child: new MaterialButton(
                                child: new Text(
                                  "提交申请",
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: screenUtil.setFontSize(16),
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return new LoadingDialog(
                                          text: "提交中...",
                                        );
                                      });
                                  submitUserApply();
                                },
                              ),
                            ))
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Future submitUserApply() async {
    RegExp exp_tel = new RegExp(r"1[0-9]\d{9}$");
    bool tel_matched = exp_tel.hasMatch(_user_tel.toString());

    if (!tel_matched) {
      Navigator.pop(context);
      ToastUtil.showCommonToast("你输入的手机号码不对哦！");
      return;
    }
    RegExp exp_email = new RegExp(
        r"^([a-zA-Z0-9]+[_|\-|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\-|\.]?)*[a-zA-Z0-9]+(\.[a-zA-Z]{2,3})+$");
    bool email_matched = exp_email.hasMatch(_user_email.toString());
    print(email_matched);
    print(!email_matched);
    print(_user_email.toString());
    if (!email_matched) {
      Navigator.pop(context);
      ToastUtil.showCommonToast("你输入的邮箱不对哦！");
      return;
    }
    if (_user_name.toString().isEmpty) {
      Navigator.pop(context);
      ToastUtil.showCommonToast("你的名字还没有输入哦！");
      return;
    }
    var httpUtil = await HttpUtil.getInstance()
        .post(Api.SUBMIT_USER_PART_JOB_APPLY, data: {
      "userId": _userId.toString(),
      "emailBox": _user_email.toString(),
      "username": _user_name.toString(),
      "tel": _user_tel.toString(),
      "jobId": widget.jobId.toString(),
    });
    print({
      "userId": _userId.toString(),
      "emailBox": _user_email.toString(),
      "username": _user_name.toString(),
      "tel": _user_tel.toString(),
      "jobId": widget.jobId.toString(),
    });
    var decode = json.decode(httpUtil);
    print(httpUtil);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtil.showCommonToast("申请成功");
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtil.showCommonToast(baseResponseEntity.msg);
    }
  }

  String _user_tel = "";
  String _user_email = "";
  String _user_name = "";
  String _userId = "";
  String _nickname = "";
  String _avatar = "";
  String _school = "";

  Future getUserInformation() async {
    var instance = await SpUtil.getInstance();
    setState(() {
      _userId = instance.getInt("id").toString();
      _avatar = instance.getString("avatar");
      _nickname = instance.getString("nickname");
      _school = instance.getString("school");
    });
  }

  Widget setJobItem(BuildContext buildContext, int position) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
            buildContext,
            new CustomRouteSlide(new PartTimeJobDetailPage(
              jobId: _job_list[position].id.toString(),
            )));
      },
      child: new Container(
        margin: EdgeInsets.only(bottom: screenUtil.setWidgetHeight(10)),
        color: Colors.white,
        padding: EdgeInsets.only(
            left: screenUtil.setWidgetWidth(15),
            bottom: screenUtil.setWidgetHeight(10)),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new Text(
                _job_list[position].jobName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenUtil.setFontSize(17)),
                textAlign: TextAlign.left,
              ),
              width: screenUtil.setWidgetWidth(250),
              height: screenUtil.setWidgetHeight(45),
              alignment: Alignment.centerLeft,
            ),
            new Container(
              padding: EdgeInsets.only(bottom: screenUtil.setWidgetHeight(8)),
              child: new Text(
                _job_list[position].jobShop,
                style: new TextStyle(
                    color: Colors.black54,
                    fontSize: screenUtil.setFontSize(15)),
              ),
            ),
            new Row(
              children: <Widget>[
                new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  child: new Container(
                    padding: EdgeInsets.only(
                        left: screenUtil.setWidgetWidth(5),
                        right: screenUtil.setWidgetWidth(5),
                        top: screenUtil.setWidgetHeight(3),
                        bottom: screenUtil.setWidgetHeight(3)),
                    child: new Text(
                      _job_list[position].location,
                      style: new TextStyle(
                          color: Colors.black38,
                          fontSize: screenUtil.setFontSize(12)),
                    ),
                    color: Color(0xfff4f4f4),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(
                      left: screenUtil.setWidgetWidth(10),
                      right: screenUtil.setWidgetWidth(10)),
                  child: new ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    child: new Container(
                      padding: EdgeInsets.only(
                          left: screenUtil.setWidgetWidth(5),
                          right: screenUtil.setWidgetWidth(5),
                          top: screenUtil.setWidgetHeight(3),
                          bottom: screenUtil.setWidgetHeight(3)),
                      child: new Text(
                        _job_list[position].jobKind,
                        style: new TextStyle(
                            color: Colors.black38,
                            fontSize: screenUtil.setFontSize(12)),
                      ),
                      color: Color(0xfff4f4f4),
                    ),
                  ),
                ),
                new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  child: new Container(
                    padding: EdgeInsets.only(
                        left: screenUtil.setWidgetWidth(5),
                        right: screenUtil.setWidgetWidth(5),
                        top: screenUtil.setWidgetHeight(3),
                        bottom: screenUtil.setWidgetHeight(3)),
                    child: new Text(
                      _job_list[position].jobDays,
                      style: new TextStyle(
                          color: Colors.black38,
                          fontSize: screenUtil.setFontSize(12)),
                    ),
                    color: Color(0xfff4f4f4),
                  ),
                ),
              ],
            ),
            new Container(
              padding: EdgeInsets.only(top: screenUtil.setWidgetHeight(7)),
              child: new RichText(
                text: TextSpan(
                    style: new TextStyle(color: Colors.black45),
                    children: <TextSpan>[
                      new TextSpan(
                          text: "￥",
                          style: new TextStyle(color: Colors.redAccent)),
                      new TextSpan(
                          text: _job_list[position].jobPay,
                          style: new TextStyle(
                              color: Colors.redAccent,
                              fontSize: screenUtil.setFontSize(19))),
                      new TextSpan(
                          text: " / " + _job_list[position].payUnit,
                          style: new TextStyle(
                              color: Colors.black45,
                              fontSize: screenUtil.setFontSize(13)))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
