import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

const APPBAE_SCROLL_OFFSET = 100;

class TopicPostPage extends StatefulWidget {
  String topicId;
  String topicPicture;String topicName;

  TopicPostPage({Key key, this.topicId, this.topicPicture, this.topicName}) : super();

  @override
  _TopicPostPageState createState() => _TopicPostPageState();
}

class _TopicPostPageState extends State<TopicPostPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  double alphaAppBar = 0;

  _onScroll(offset) {
    double alpha = offset / APPBAE_SCROLL_OFFSET;
    if (alpha <= 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      alphaAppBar = alpha;
    });
    print(alphaAppBar);
  }

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    var d = (MediaQuery.of(context).size.width - 12) / 3;

    return Scaffold(
      body: new Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: NotificationListener(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification) {
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                        return false;
                      },
                      child: new ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          new Stack(
                            children: <Widget>[
                              new Column(
                                children: <Widget>[
                                  new Container(
                                      height: _screenUtils.setWidgetHeight(160),
                                      color: Colors.black54,
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            widget.topicPicture,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                            height: _screenUtils
                                                .setWidgetHeight(160),
                                          ),
                                          BackdropFilter(
                                            filter: new ImageFilter.blur(
                                                sigmaX: 8, sigmaY: 8),
                                            child: new Container(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: _screenUtils
                                                  .setWidgetHeight(160),
                                            ),
                                          ),
                                          new Container(
                                            padding: EdgeInsets.only(
                                                top:
                                                    ScreenUtil.statusBarHeight),
                                            child: new AppBar(
                                              leading: new IconButton(
                                                  icon: new Icon(
                                                      Icons.arrow_back_ios),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                              elevation: 0.5,
                                              iconTheme: new IconThemeData(
                                                  color: Colors.white),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                          new Positioned(
                                              left: _screenUtils
                                                  .setWidgetWidth(110),
                                              bottom: 10,
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  new Text(
                                                    widget.topicName,
                                                    style: new TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: _screenUtils
                                                            .setFontSize(26)),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                  new Container(
                                    padding: EdgeInsets.only(
                                        left: _screenUtils.setWidgetWidth(110),
                                        top: _screenUtils.setWidgetHeight(15)),
                                    height: _screenUtils.setWidgetHeight(80),
                                    color: Colors.white,
                                    child: new Row(
                                      children: <Widget>[
                                        new Column(
                                          children: <Widget>[
                                            new Text(
                                              "10",
                                              style: new TextStyle(
                                                  fontSize: _screenUtils
                                                      .setFontSize(23),
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            new Text(
                                              "已加入",
                                              style: new TextStyle(
                                                  fontSize: _screenUtils
                                                      .setFontSize(13),
                                                  color: Colors.grey,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )
                                          ],
                                        ),
                                        new Container(
                                          width:
                                              _screenUtils.setWidgetWidth(15),
                                        ),
                                        new Expanded(
                                            child: new Container(
                                          padding: EdgeInsets.only(
                                              right: _screenUtils
                                                  .setWidgetWidth(15)),
                                          alignment: Alignment.centerRight,
                                          child: new ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(_screenUtils
                                                    .setWidgetWidth(35))),
                                            child: new Container(
                                              padding: EdgeInsets.only(
                                                  left: _screenUtils
                                                      .setWidgetWidth(15),
                                                  right: _screenUtils
                                                      .setWidgetWidth(15),
                                                  bottom: _screenUtils
                                                      .setWidgetHeight(5),
                                                  top: _screenUtils
                                                      .setWidgetHeight(5)),
                                              color: Color(0xff4ddfa9),
                                              child: new Text(
                                                "+ 加入",
                                                style: new TextStyle(
                                                    color: Colors.white,
                                                    fontSize: _screenUtils
                                                        .setFontSize(15)),
                                              ),
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              new Positioned(
                                child: new ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      _screenUtils.setWidgetHeight(55)),
                                  child: new Image.network(
                                    widget.topicPicture,
                                    width: _screenUtils.setWidgetHeight(76),
                                    height: _screenUtils.setWidgetHeight(76),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                bottom: _screenUtils.setWidgetHeight(52),
                                left: _screenUtils.setWidgetWidth(20),
                              ),
                            ],
                          ),
                          new Container(
                            color: Color(0xfffafafa),
                            height: _screenUtils.setWidgetHeight(8),
                          ),
                          new Container(
                            padding: EdgeInsets.only(
                                top: _screenUtils.setWidgetHeight(9),
                                bottom: _screenUtils.setWidgetHeight(14),
                                left: _screenUtils.setWidgetWidth(14)),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Container(
                                  padding: EdgeInsets.only(
                                      top: _screenUtils.setWidgetHeight(12),
                                      bottom: _screenUtils.setWidgetHeight(9)),
                                  child: new Text(
                                    "话题简介",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: _screenUtils.setFontSize(19),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.only(
                                      top: _screenUtils.setWidgetHeight(4),
                                      bottom: _screenUtils.setWidgetHeight(5)),
                                  child: new Text(
                                    "",
                                    style: new TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          new Container(
                            color: Color(0xfffafafa),
                            height: _screenUtils.setWidgetHeight(8),
                          ),
                        ],
                      ))),
              Opacity(
                opacity: alphaAppBar,
                child: Container(
                  height: _screenUtils.setWidgetHeight(90),
                  decoration: BoxDecoration(color: Colors.white),
                  child: new AppBar(
                    leading: new IconButton(
                        icon: new Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    elevation: 0.5,
                    iconTheme: new IconThemeData(color: Colors.black),
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
