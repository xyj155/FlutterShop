import 'dart:convert';

import 'package:amap_location/amap_location.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/home_user_topic_entity.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/amap_location_util.dart';
import 'package:sauce_app/widget/list_title_right.dart';
import 'package:sauce_app/widget/loading_dialog.dart';

import 'topic_choose.dart';

class TextPostPage extends StatefulWidget {
  @override
  _TextPostPageState createState() => _TextPostPageState();
}

class _TextPostPageState extends State<TextPostPage>
    with SingleTickerProviderStateMixin {
  String _location = "";
  String _latitude = "";
  String _longitude = "";

  @override
  void initState() {
    super.initState();
    AmapUtil.startLocation((location) {
      AMapLocation aMapLocation = location;
      print("---------------------------------");
      print(aMapLocation.street);
      print(aMapLocation.longitude);
      print(aMapLocation.latitude);
      setState(() {
        _location = aMapLocation.city + " · " + aMapLocation.street;
        _latitude = aMapLocation.longitude.toString();
        _longitude = aMapLocation.longitude.toString();
      });
      print("---------------------------------");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();
  TextEditingController _contentController = new TextEditingController();
  FocusNode _contentFocusNode = FocusNode();
  String _content = "";
  String _topic_default = "@请选择话题";
  String _visible_type = "公开";
  String _topic_img_url = "";
  Color font_color = Colors.grey;
  Color bg_color = Colors.transparent;
  bool isChoose = false;
  String _topic_id = "";
  final TapGestureRecognizer recognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    _contentController.addListener(() {
      print('input ${_contentController.text}');
    });
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "发布"),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverToBoxAdapter(
            child: new Container(
              color: Colors.white,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    color: Color(0xfffafafa),
                    padding: EdgeInsets.all(_screenUtils.setWidgetHeight(15)),
                    height: _screenUtils.setWidgetHeight(250),
                    child: TextFormField(
                      maxLines: 999,
                      decoration: InputDecoration(
                          hintText: "说一点东西吧！",
                          hintStyle: new TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none),
                      autofocus: true,
                      onChanged: (content) {
                        _content = content;
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: _screenUtils.setFontSize(15)),
                      cursorColor: Colors.black,
                      focusNode: _contentFocusNode,
                      controller: _contentController,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.all(_screenUtils.setWidgetHeight(15)),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(
                                  _screenUtils.setWidgetWidth(4)),
                              topLeft: Radius.circular(
                                  _screenUtils.setWidgetWidth(4)),
                              topRight: Radius.circular(
                                  _screenUtils.setWidgetWidth(4))),
                          child: new GestureDetector(
                            onTap: () {
                              _navigationWithMsg();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: _screenUtils.setWidgetWidth(4),
                                  right: _screenUtils.setWidgetWidth(4),
                                  top: _screenUtils.setWidgetHeight(3),
                                  bottom: _screenUtils.setWidgetHeight(3)),
                              color: bg_color,
                              child: new RichText(
                                  text: new TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    _navigationWithMsg();
                                  },
                                text: _topic_default,
                                style: new TextStyle(
                                    color: font_color,
                                    fontSize: _screenUtils.setFontSize(15)),
                              )),
                            ),
                          ),
                        ),
                        isChoose
                            ? new Container(
                                margin: EdgeInsets.only(
                                    left: _screenUtils.setWidgetWidth(5),
                                    right: _screenUtils.setWidgetWidth(5)),
                                child: new ClipRRect(
                                  child: new Image.network(
                                    _topic_img_url,
                                    width: _screenUtils.setWidgetWidth(35),
                                    height: _screenUtils.setWidgetHeight(35),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          _screenUtils.setWidgetHeight(35))),
                                ),
                              )
                            : new Container(),
                      ],
                    ),
                  ),
                  new Container(
                    height: _screenUtils.setWidgetHeight(6),
                    color: Color(0xfffafafa),
                  ),
                  new Container(
                    color: Colors.white,
                    margin:
                        EdgeInsets.only(top: _screenUtils.setWidgetHeight(30)),
                    child: new RightListTitle(
                      value: _visible_type,
                      title: "谁可见",
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return new SimpleDialog(
                                title: new Text(
                                  '谁可见',
                                  style: new TextStyle(
                                      fontSize: _screenUtils.setFontSize(15)),
                                ),
                                children: <Widget>[
                                  new SimpleDialogOption(
                                    child: new Text(
                                      '仅自己',
                                      style: new TextStyle(
                                          fontSize:
                                              _screenUtils.setFontSize(17),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _visible_type = '仅自己';
                                        _visible_code = 0;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  new SimpleDialogOption(
                                    child: new Text(
                                      '公开',
                                      style: new TextStyle(
                                          fontSize:
                                              _screenUtils.setFontSize(17),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        _visible_type = '公开';
                                        _visible_code = 1;
                                      });
                                    },
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: new Container(
        width: MediaQuery.of(context).size.width,
        height: _screenUtils.setWidgetHeight(50),
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
                    text: "上传中",
                  );
                });
            submitUserTextPost();
//          Navigator.push(context, new MaterialPageRoute(builder: (_) {
//            return new ChooseGameName();
//          }));
          },
        ),
      ),
    );
  }

  int _visible_code = 1;

  Future _navigationWithMsg() async {
    var result = await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new UserTopicChoosePage()));
    if (result != null) {
//      var decode = json.decode(result);
      var homeUserTopicDataChild = HomeUserTopicDataChild.fromJson(result);
      setState(() {
        _topic_default = "@ " + homeUserTopicDataChild.topicName;
        _topic_img_url = homeUserTopicDataChild.topicPicUrl;
        isChoose = true;
        _topic_id = homeUserTopicDataChild.id.toString();
        font_color = Colors.white;
        bg_color = Color(0xff4ddfa9);
      });
    }
  }

  Future submitUserTextPost() async {
    if (_content.length < 10) {
      ToastUtil.showCommonToast("字数不可少于十个字哦！");
      Navigator.pop(context);
      return;
    }
    if (_topic_id.isEmpty) {
      ToastUtil.showCommonToast("还没有选择话题哦！");
      return;
    }
    var spUtil = await SpUtil.getInstance();
    var para={
      "userId": spUtil.getInt("id").toString(),
      "content": _content,
      "topicId": _topic_id,
      "visible": _visible_code,
      "location": _location,
      "latitude": _latitude,
      "longitude": _longitude,
    };
    var response =
        await HttpUtil.getInstance().post(Api.SUBMIT_USER_TEXT_POST, data:para );
    var decode = json.decode(response);
    print("----------------------------------------------------");
    print(para);
    print(response);
    print("----------------------------------------------------");
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ToastUtil.showCommonToast("提交失败！");
    }
  }
}
