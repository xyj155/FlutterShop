import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/gson/single_part_time_job_detail_entity.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';

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
                          new Container(height: screenUtil.setWidgetHeight(8),color: Color(0xfffafafa),),
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
          onPressed: () {},
        ),
      ),
    );
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
