import 'dart:convert';
import 'dart:io';

//import 'package:amap_base_location/amap_base_location.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sauce_app/api/AliApi.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/home_user_topic_entity.dart';
import 'package:sauce_app/post/topic_choose.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/ali_oss_upload_util.dart';
import 'package:sauce_app/util/amap_location_util.dart';
import 'package:sauce_app/widget/list_title_right.dart';
import 'package:sauce_app/widget/loading_dialog.dart';
import 'package:uuid/uuid.dart';

class PostPicturePage extends StatefulWidget {
  @override
  _PostPicturePageState createState() => _PostPicturePageState();
}

class _PostPicturePageState extends State<PostPicturePage>
    with SingleTickerProviderStateMixin {
  String _location = "";
  String _latitude = "";
  String _longitude = "";

  @override
  void initState() {
    super.initState();
//    AmapUtil.startLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();
  TextEditingController _contentController = new TextEditingController();
  FocusNode _contentFocusNode = FocusNode();
  List<String> _file_path = new List();
  int _visible_code = 1;
  String _content = "";
  String _topic_default = "@请选择话题";
  String _visible_type = "公开";
  String _topic_img_url = "";
  Color font_color = Colors.grey;
  Color bg_color = Colors.transparent;
  bool isChoose = false;
  String _topic_id = "";

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "图片说说"),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverToBoxAdapter(
            child: new Column(children: <Widget>[
              new Container(
                color: Color(0xfffafafa),
                padding: EdgeInsets.only(
                    left: _screenUtils.setWidgetHeight(15),
                    right: _screenUtils.setWidgetHeight(15),
                    top: _screenUtils.setWidgetHeight(7),
                    bottom: _screenUtils.setWidgetHeight(10)),
                height: _screenUtils.setWidgetHeight(180),
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
                height: _screenUtils.setWidgetHeight(8),
                color: Color(0xfffafafa),
              ),
              new Container(
                color: Colors.white,
                padding: EdgeInsets.all(_screenUtils.setWidgetHeight(15)),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomRight:
                              Radius.circular(_screenUtils.setWidgetWidth(4)),
                          topLeft:
                              Radius.circular(_screenUtils.setWidgetWidth(4)),
                          topRight:
                              Radius.circular(_screenUtils.setWidgetWidth(4))),
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
                              borderRadius: BorderRadius.all(Radius.circular(
                                  _screenUtils.setWidgetHeight(35))),
                            ),
                          )
                        : new Container(),
                  ],
                ),
              ),
              new Container(
                color: Colors.white,
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
                                      fontSize: _screenUtils.setFontSize(17),
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
                                      fontSize: _screenUtils.setFontSize(17),
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
              ),
              new Container(
                margin: EdgeInsets.all(_screenUtils.setWidgetHeight(15)),
                child: new GridView.builder(
                    shrinkWrap: true,
                    itemCount: _file_path.length == 9 ? _file_path.length : 9,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 3.0,
                        crossAxisSpacing: 3.0,
                        childAspectRatio: 1.0),
                    itemBuilder: (BuildContext content, int position) {
                      if (position == _file_path.length) {
                        return new GestureDetector(
                          onTap: () {
                            showDialog<Null>(
                                context: context, //BuildContext对象
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return new LoadingDialog(
                                    text: "压缩中...",
                                  );
                                });
                            getImage();
                          },
                          child: new ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(
                                _screenUtils.setWidgetHeight(4))),
                            child: new Image.asset(
                                "assert/imgs/post_add_img.png",
                                fit: BoxFit.cover),
                          ),
                        );
                      } else {
                        print(_file_path.length > position
                            ? _file_path[position]
                            : _file_path.length);
                        return new Container(
                          child: _file_path.length > position
                              ? new ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          _screenUtils.setWidgetHeight(4))),
                                  child: new Image.file(
                                    new File(_file_path[position]),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : new Container(),
                        );
                      }
                    }),
              ),
            ]),
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
                    text: "上传中...",
                  );
                });
            submitPictureInvite();
          },
        ),
      ),
    );
  }

  final TapGestureRecognizer recognizer = TapGestureRecognizer();

  Future _navigationWithMsg() async {

    var result = await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new UserTopicChoosePage()));
    if (result != null) {
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    CompressObject compressObject =
        CompressObject(imageFile: image, path: documentsPath);
    Luban.compressImage(compressObject).then((_path) {
      Navigator.pop(context);
      setState(() {
        _file_path.add(_path);
      });
    }).catchError((e) {
      ToastUtil.showCommonToast("上传头像失败，请重新选择！" + e.toString());
    });
  }

  Future submitPictureInvite() async {
    var spUtil = await SpUtil.getInstance();
    var uuid = new Uuid();
    var _picture_list = [];
    for (var o in _file_path) {
      var file_name = uuid.v1() + ".png";
      AliUploadUtil.uploadAliOSS(AliApi.MANGO_USER_PICTURE, o, file_name);
      _picture_list.add(AliApi.MANGO_USER_PICTURE + file_name);
    }
    var response =
        await HttpUtil.getInstance().post(Api.SUBMIT_USER_PICTURE_POST, data: {
      "userId": spUtil.getInt("id").toString(),
      "content": _content,
      "postTopic ": _topic_id.toString(),
      "location": _location,
      "latitude": _latitude,
      "longitude": _longitude,
      "visible": _visible_code.toString(),
      "pictureList": json.encode(_picture_list)
    });
    var decode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      ToastUtil.showCommonToast("发表成功");
    } else {
      Navigator.pop(context);
      ToastUtil.showErrorToast(baseResponseEntity.msg);
    }
  }
}
