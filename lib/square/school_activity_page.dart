import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/common_webview_page.dart';
import 'package:sauce_app/gson/school_activity_entity.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

class SchoolActivityPage extends StatefulWidget {
  @override
  _SchoolActivityPageState createState() => _SchoolActivityPageState();
}

class _SchoolActivityPageState extends State<SchoolActivityPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
ScrollController _scrollController=new ScrollController();
  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    querySchoolActivity(1);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        page=page+1;
        print(page);
        getMoreActivity(page);
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "校园活动"),
      body: new Container(
        child: new ListView.builder(
          controller: _scrollController,
          itemBuilder: (BuildContext context, int position) {
            return getSchoolInvitePage(
                context, _school_activity_list[position]);
          },
          itemCount: _school_activity_list.length,
        ),
      ),
    );
  }

  int page = 1;
  List<SchoolActivityData> _school_activity_list = new List();

  Future querySchoolActivity(int pages) async {
    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_SCHOOL_ACTIVITY_, data: {"page": pages.toString()});
    if (response != null) {
      var decode = json.decode(response.toString());
      var schoolActivityEntity = SchoolActivityEntity.fromJson(decode);
      if (schoolActivityEntity.code == 200) {
        setState(() {
          _school_activity_list = schoolActivityEntity.data;
        });
      }
    }
  }
  Future getMoreActivity(int pages) async {
    var response = await HttpUtil.getInstance()
        .get(Api.QUERY_SCHOOL_ACTIVITY_, data: {"page": pages.toString()});
    if (response != null) {
      var decode = json.decode(response.toString());
      var schoolActivityEntity = SchoolActivityEntity.fromJson(decode);
      if (schoolActivityEntity.code == 200) {
        print(response.toString());
        setState(() {
          _school_activity_list.addAll(schoolActivityEntity.data);
        });
      }
    }
  }
  Widget getSchoolInvitePage(
      BuildContext context, SchoolActivityData schoolActivityData) {
    return new GestureDetector(
      onTap: (){
        Navigator.push(context, new MaterialPageRoute(builder: (_){
          return new CommonWebViewPage(url: schoolActivityData.webUrl, title: "");
        }));
      },
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(child:   new Text(schoolActivityData.createAt,style: new TextStyle(color: Colors.grey
              ,fontSize: _screenUtils.setFontSize(12)),),
            padding: EdgeInsets.only(top: _screenUtils.setWidgetHeight(18)),
          )
          ,new Container(
            color: Colors.white,
            margin: EdgeInsets.only(
                left: _screenUtils.setWidgetWidth(10),
                right: _screenUtils.setWidgetWidth(10),
                bottom: _screenUtils.setWidgetHeight(15),
                top: _screenUtils.setWidgetHeight(10)),
            child: new ClipRRect(
              borderRadius:
              BorderRadius.all(Radius.circular(_screenUtils.setWidgetHeight(8))),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Image.network(
                    schoolActivityData.activityPictureUrl,
                    height: _screenUtils.setWidgetHeight(180),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  new Container(
                    padding: EdgeInsets.all(_screenUtils.setWidgetHeight(10)),
                    child: new Text(
                      schoolActivityData.activityName,
                      style: new TextStyle(
                          color: Colors.black87,
                          fontSize: _screenUtils.setFontSize(15)),
                    ),
                  ),
                  new Divider(
                    indent: _screenUtils.setWidgetWidth(15),
                    endIndent: _screenUtils.setWidgetWidth(15),
                  ),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                            left: _screenUtils.setWidgetHeight(12),
                            right: _screenUtils.setWidgetHeight(12),
                            bottom: _screenUtils.setWidgetHeight(12),),
                          child: new Text(
                            "查看详情",
                            style: new TextStyle(
                                color: Colors.black87,
                                fontSize: _screenUtils.setFontSize(12)),
                          )),
                      new Expanded(child: new Container(
                        padding: EdgeInsets.only(
                          left: _screenUtils.setWidgetHeight(12),
                          right: _screenUtils.setWidgetHeight(12),
                          bottom: _screenUtils.setWidgetHeight(12),),
                        alignment: Alignment.centerRight,
                        child: new Image.asset("assert/imgs/img_arrow.png",
                          width: _screenUtils.setWidgetWidth(15),
                          height: _screenUtils.setWidgetHeight(15),),
                      ))
                    ],
                  )
                ],
              ),
            ),
          )],
      ),
    );
  }
}
