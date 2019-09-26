import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dropdown_menu/dropdown_menu.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/part_job_name_kind.dart';
import 'package:sauce_app/gson/part_time_job_list_entity.dart';
import 'dart:math' as math;

import 'dart:convert';

import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';

import 'part_time_job_detail_page.dart';

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
