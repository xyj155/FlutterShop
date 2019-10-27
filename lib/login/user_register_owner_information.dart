import 'dart:convert';
import 'dart:io';

//import 'package:amap_base_location/amap_base_location.dart';
import 'package:amap_base_location/amap_base_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_tags/tag.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sauce_app/api/AliApi.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/user_entity.dart';
import 'package:sauce_app/util/AppEncryptionUtil.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/util/ali_oss_upload_util.dart';
import 'package:sauce_app/util/amap_location_util.dart';
import 'package:sauce_app/widget/input_text_fied.dart';
import 'package:sauce_app/widget/loading_dialog.dart';
import 'package:uuid/uuid.dart';

import '../MainPage.dart';
import 'university_choose.dart';
import 'user_register_information.dart';

class UserRegisterInformationPage extends StatefulWidget {
  @override
  _UserRegisterInformationPageState createState() =>
      _UserRegisterInformationPageState();
}

class _UserRegisterInformationPageState
    extends State<UserRegisterInformationPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    loadDate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ScreenUtils screenUtil = new ScreenUtils();

  List<PickerItem> list = new List();
  String startYear = "";
  var data = ['2019年', '2018年', '2017年', '2016年', '2015年', '2014年', '2013年'];

  void loadDate() {
    for (int i = 0; i < data.length; i++) {
      list.add(new PickerItem(text: new Text(data[i]), value: data[i]));
    }
  }

  String _avatar_path = "";
  String university = "";
  String _user_major = "";

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    return new Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: new Column(
        children: <Widget>[
          new Text("基本信息",
              style: new TextStyle(
                  decoration: TextDecoration.none,
                  color: Color(0xff000000),
                  fontSize: screenUtil.setWidgetWidth(29),
                  fontWeight: FontWeight.bold)),
          new Container(
            child: new Text("填写你的校园身份，我们帮你推荐更多的校友",
                style: new TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: screenUtil.setWidgetWidth(14),
                    color: Color(0xffb6b6b6),
                    fontWeight: FontWeight.normal)),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                top: screenUtil.setWidgetWidth(10),
                bottom: screenUtil.setWidgetWidth(30)),
          ),
          new GestureDetector(
            onTap: () {
              NavigatorWithData(context);
            },
            child: new Container(
              color: Color(0xfff8f8f8),
              padding: EdgeInsets.only(left: screenUtil.setWidgetWidth(15)),
              alignment: Alignment.centerLeft,
              height: screenUtil.setWidgetHeight(55),
              margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
              child: university == ""
                  ? new Text(
                      "请输入你的院校",
                      style: new TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Color(0xff8a8a8a),
                          fontSize: screenUtil.setFontSize(15),
                          decoration: TextDecoration.none),
                    )
                  : new Text(
                      university,
                      style: new TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: screenUtil.setFontSize(15),
                          decoration: TextDecoration.none),
                    ),
            ),
          ),
          new Container(
            color: Color(0xfff8f8f8),
            alignment: Alignment.center,
            height: screenUtil.setWidgetHeight(55),
            margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
            child: new ITextField(
                contentHeight: screenUtil.setWidgetHeight(15),
                keyboardType: ITextInputType.text,
                hintText: '请输入你的所在专业',
                deleteIcon: new Image.asset(
                  "assert/imgs/icon_image_delete.png",
                  width: screenUtil.setWidgetWidth(18),
                  height: screenUtil.setWidgetHeight(55),
                ),
                textStyle: TextStyle(
                    color: Colors.black, fontSize: screenUtil.setFontSize(15)),
                inputBorder: InputBorder.none,
                fieldCallBack: (content) {
                  setState(() {
                    _user_major = content;
                  });
                }),
          ),
          new GestureDetector(
            child: new Container(
              color: Color(0xfff8f8f8),
              padding: EdgeInsets.only(left: screenUtil.setWidgetWidth(15)),
              alignment: Alignment.centerLeft,
              height: screenUtil.setWidgetHeight(55),
              margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
              child: new Text(
                startYear.isEmpty ? "请选择你的入学年份" : startYear,
                style: new TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: screenUtil.setFontSize(16),
                    color: startYear.isEmpty ? Color(0xff8a8a8a) : Colors.black,
                    decoration: TextDecoration.none),
              ),
            ),
            onTap: () {
              Picker picker = new Picker(
                  textStyle: new TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenUtil.setFontSize(12)),
                  itemExtent: screenUtil.setWidgetHeight(31),
                  adapter: PickerDataAdapter(
                    data: list,
                  ),
                  height: screenUtil.setWidgetHeight(210),
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
                      startYear = "入学时间：" + data[value[0]];
//                      countryCode = countryList[value[0]];
                    });
                  });
              picker.showModal(context);
            },
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            height: screenUtil.setWidgetHeight(50),
            margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
            child: new MaterialButton(
              color: Color(0xff7c7f88),
              textColor: Colors.white,
              child: new Text(
                '下一步',
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                saveUserData();
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return new UserAvatarRegisterChooseAvatarPage();
                }));
              },
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: EdgeInsets.only(
          left: screenUtil.setWidgetWidth(20),
          right: screenUtil.setWidgetWidth(20),
          top: screenUtil.setWidgetWidth(50)),
    );
  }

  Future saveUserData() async {
    var spUtil = await SpUtil.getInstance();
    spUtil.putString("school", university);
    spUtil.putString("major", _user_major);
    spUtil.putString("entertime", startYear.replaceAll("入学时间：", ""));
  }

  void NavigatorWithData(BuildContext context) async {
    var result =
        await Navigator.push(context, new MaterialPageRoute(builder: (_) {
      return new SchoolChoosePage();
    }));
    if (result.isNotEmpty) {
      setState(() {
        university = result;
      });
    }
  }
}

class UserAvatarRegisterChooseAvatarPage extends StatefulWidget {
  @override
  _UserAvatarRegisterChooseAvatarPageState createState() =>
      _UserAvatarRegisterChooseAvatarPageState();
}

class _UserAvatarRegisterChooseAvatarPageState
    extends State<UserAvatarRegisterChooseAvatarPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Location> _result = [];

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    setUserSex();
    _items = _list.toList();

//
//    AmapUtil.startLocation()
//        .then(_result.add)
//        .then((_) => setState(() {
//          print("============================================");
//          print(_items[0]);
//          print("============================================");
//    }));
    initLocation();
  }

  num latitude;
  num longitude;
  String cityName;

  Future initLocation() async {
    final options = LocationClientOptions(
      isOnceLocation: true,
      locatingWithReGeocode: true,
    );
    final _amapLocation = AMapLocation();
    if (await Permissions().requestPermission()) {
      _amapLocation
          .getLocation(options)
          .then(_result.add)
          .then((_) => setState(() {
                setState(() {
                  latitude = _result[0].latitude;
                  longitude = _result[0].longitude;
                  cityName = _result[0].city;
                });
              }));
    } else {
      ToastUtil.showCommonToast('权限不足');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _imagePath = "";

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    setState(() {
      CompressObject compressObject =
          CompressObject(imageFile: image, path: documentsPath);
      Luban.compressImage(compressObject).then((_path) {
        setState(() {
          Navigator.pop(context);
          print("------------------------------");
          print(_path);
          _imagePath = _path;
          print("------------------------------");
        });
      });
//      _image = image;
    });
  }

  List<PickerItem> list = new List();
  String userSex = "请选择你的性别";
  String userBirth = "请选择你的生日";
  var data = ['男', '女'];

  void setUserSex() {
    for (int i = 0; i < data.length; i++) {
      list.add(new PickerItem(text: new Text(data[i]), value: data[i]));
    }
  }

  String _nickname = "";

  ScreenUtils screenUtil = new ScreenUtils();
  List _items = new List();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: BackUtil.NavigationBack(context, "账号信息"),
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverToBoxAdapter(
            child: new Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Column(children: <Widget>[
                        new Container(
                          child: new Text("完善你的个人信息",
                              style: new TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: screenUtil.setWidgetWidth(14),
                                  color: Color(0xffb6b6b6),
                                  fontWeight: FontWeight.normal)),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              bottom: screenUtil.setWidgetWidth(8)),
                        ),
                        new Container(
                            width: screenUtil.setWidgetWidth(170),
                            child: new TextField(
                              decoration: InputDecoration.collapsed(
                                  hintText: "请输入昵称",
                                  hintStyle: new TextStyle(fontSize: 23)),
                              maxLength: 10,
                              //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
                              maxLines: 1,
                              //最大行数
                              autocorrect: true,
                              //是否自动更正
                              autofocus: false,
                              //是否自动对焦
                              textAlign: TextAlign.left,
                              //文本对齐方式
                              style:
                                  TextStyle(fontSize: 23, color: Colors.black),
                              //输入文本的样式的输入格式
                              onChanged: (text) {
                                //内容改变的回调
                                print('change $text');
                                _nickname = text;
                              },
                              onSubmitted: (text) {
                                //内容提交(按回车)的回调
                                print('submit $text');
                              },
                              enabled: true, //是否禁用
                            )),
                      ], crossAxisAlignment: CrossAxisAlignment.start)),
                      new ClipOval(
                        child: _imagePath.isEmpty
                            ? new GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return new LoadingDialog(
                                          text: "加载中...",
                                        );
                                      });
                                  getImage();
                                },
                                child: Image.asset(
                                  "assert/imgs/icon_head.png",
                                  fit: BoxFit.cover,
                                  height: screenUtil.setWidgetHeight(88),
                                  width: screenUtil.setWidgetWidth(82),
                                ),
                              )
                            : new GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return new LoadingDialog(
                                          text: "加载中...",
                                        );
                                      });
                                  getImage();
                                },
                                child: Image.file(
                                  new File(_imagePath),
                                  fit: BoxFit.cover,
                                  height: screenUtil.setWidgetHeight(88),
                                  width: screenUtil.setWidgetWidth(82),
                                ),
                              ),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  new GestureDetector(
                    child: new Container(
                      color: Color(0xfff8f8f8),
                      padding:
                          EdgeInsets.only(left: screenUtil.setWidgetWidth(15)),
                      alignment: Alignment.centerLeft,
                      height: screenUtil.setWidgetHeight(55),
                      margin:
                          EdgeInsets.only(top: screenUtil.setWidgetHeight(9)),
                      child: new Text(
                        userSex == "请选择你的性别" ? "请选择你的性别" : userSex,
                        style: new TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenUtil.setFontSize(16),
                            color: userSex == "请选择你的性别"
                                ? Color(0xff8a8a8a)
                                : Colors.black,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    onTap: () {
                      Picker picker = new Picker(
                          textStyle: new TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: screenUtil.setFontSize(12)),
                          itemExtent: screenUtil.setWidgetHeight(31),
                          adapter: PickerDataAdapter(
                            data: list,
                          ),
                          height: screenUtil.setWidgetHeight(210),
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
                              userSex = "性别：" + data[value[0]];
                            });
                          });
                      picker.showModal(context);
                    },
                  ),
                  new GestureDetector(
                    child: new Container(
                      color: Color(0xfff8f8f8),
                      padding:
                          EdgeInsets.only(left: screenUtil.setWidgetWidth(15)),
                      alignment: Alignment.centerLeft,
                      height: screenUtil.setWidgetHeight(55),
                      margin:
                          EdgeInsets.only(top: screenUtil.setWidgetHeight(9)),
                      child: new Text(
                        userBirth == "请选择你的生日" ? "请选择你的生日" : userBirth,
                        style: new TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: screenUtil.setFontSize(16),
                            color: userBirth == "请选择你的生日"
                                ? Color(0xff8a8a8a)
                                : Colors.black,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    onTap: () {
                      new Picker(
                        adapter: new DateTimePickerAdapter(
                          type: PickerDateTimeType.kYMD,
                          isNumberMonth: true,
                          yearSuffix: "年",
                          yearEnd: 2019,
                          monthSuffix: "月",
                          daySuffix: "日",
                        ),
                        cancelText: "取消",
                        confirmText: "确定",
                        textAlign: TextAlign.right,
                        cancelTextStyle: new TextStyle(
                            color: Color(0xffbfbfbf),
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        confirmTextStyle: new TextStyle(
                            color: Color(0xff19bebf),
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                        selectedTextStyle: TextStyle(color: Colors.black),
                        onConfirm: (Picker picker, List value) {
                          print(picker.adapter.text);
                          this.setState(() {
                            userBirth =
                                "生日：" + picker.adapter.text.substring(0, 10);
                          });
                        },
                      ).show(_scaffoldKey.currentState);
                    },
                  ),
                  new Container(
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    height: screenUtil.setWidgetHeight(55),
                    margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(8)),
                    child: new Text("选择你的标签",
                        style: new TextStyle(
                            fontSize: screenUtil.setFontSize(16),
                            color: Colors.black)),
                  ),
                  new Container(
                    margin:
                        EdgeInsets.only(top: screenUtil.setWidgetHeight(10)),
                    child: new Tags(
                      symmetry: false,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      columns: 7,
                      horizontalScroll: false,
                      //verticalDirection: VerticalDirection.up, textDirection: TextDirection.rtl,
                      heightHorizontalScroll: 60 * (14 / 14),
                      itemCount: _items.length,
                      itemBuilder: (index) {
                        final item = _items[index];
                        return ItemTags(
                          key: Key(index.toString()),
                          index: index,
                          elevation: 0,
                          borderRadius:
                              new BorderRadius.all(Radius.circular(0)),
                          title: item,
                          textActiveColor: Colors.black,
                          border: Border.all(color: Colors.grey, width: 0.3),
                          textColor: Colors.white,
                          activeColor: Colors.white,
                          color: Color(0xff4ddfa9),
                          pressEnabled: true,
                          singleItem: false,
                          combine: ItemTagsCombine.withTextBefore,
                          textScaleFactor:
                              utf8.encode(item.substring(0, 1)).length > 2
                                  ? 0.8
                                  : 1,
                          textStyle: TextStyle(
                            fontSize: screenUtil.setFontSize(17),
                          ),
                          onPressed: (item) {
                            _tags.putIfAbsent(item.title, () => item.title);
                          },
                          onRemoved: () {
                            print(item);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              padding: EdgeInsets.only(
                  left: screenUtil.setWidgetWidth(20),
                  right: screenUtil.setWidgetWidth(20),
                  top: screenUtil.setWidgetWidth(20)),
            ),
          )
        ],
      ),
      bottomNavigationBar: new Container(
        width: MediaQuery.of(context).size.width,
        height: screenUtil.setWidgetHeight(50),
        margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(28)),
        child: new MaterialButton(
          color: Color(0xff7c7f88),
          textColor: Colors.white,
          child: new Text(
            '注册',
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            saveUserData();
//            Navigator.push(context, new MaterialPageRoute(builder: (_) {
//              return new UserAvatarRegisterPage();
//            }));
          },
        ),
      ),
    );
  }

  void saveLoginUserData(UserData userData) async {
    print("=============================================================");
    print(userData.nickname);
    print("=============================================================");
    var instance = await SpUtil.getInstance();
    instance.putString("username", userData.username);
    instance.putString("avatar", userData.avatar);
    instance.putString("sex", userData.sex);
    instance.putString("latitude", userData.latitude);
    instance.putString("longitude", userData.longitude);
    instance.putString("currentCity", userData.currentCity);
    instance.putInt("page", userData.page);
    instance.putString("city", userData.city);
    instance.putString("signature", userData.signature);
    instance.putString("fans", userData.fans);
    instance.putString("score", userData.score);
    instance.putString("login", "1");
    instance.putString("school", userData.school);
    instance.putString("nickname", Base642Text.decodeBase64(userData.nickname));
    instance.putString("major", userData.major);
    instance.putString("observe", userData.observe);
    instance.putInt("id", userData.id);
  }

  Map<String, String> _tags = new Map();

  Future saveUserData() async {
    print(userSex.replaceAll("性别：", ""));
    List<String> _character = new List();
    _character.addAll(_tags.values);
    var spUtil = await SpUtil.getInstance();
    spUtil.putString("sex", userSex.replaceAll("性别：", ""));
    spUtil.putString("nickname", _nickname);
    spUtil.putString("birth", userBirth.replaceAll("生日：", ""));
    spUtil.putString("tag", json.encode(_character));
    var uuid = new Uuid();

    var file_name = uuid.v1() + ".png";
    AliUploadUtil.uploadAliOSS(AliApi.MANGO_USER_AVATAR, _imagePath, file_name)
        .then((response) async {
      var _image_url = AliApi.MANGO_USER_AVATAR + file_name;
      print(response.toString());
      if (response.toString().isEmpty) {
        var response = await HttpUtil.getInstance()
            .post(Api.USER_REGISTER_BY_USERNAME, data: {
          "school": spUtil.getString("school"),
          "avatar": _image_url,
          "sex": spUtil.getString("sex"),
          "username": spUtil.getString("username"),
          "major": spUtil.getString("major"),
          "birth": spUtil.getString("birth"),
          "invite": spUtil.getString("invite"),
          "nickname": Base642Text.encodeBase64(spUtil.getString("nickname")),
          "city": spUtil.getString("city"),
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "city": cityName,
          "enterSchoolDate":
              spUtil.getString("entertime").toString().replaceAll("年", ""),
          "character": spUtil.getString("tag"),
        });
        var baseResponseEntity =
            BaseResponseEntity.fromJson(json.decode(response));
        if (baseResponseEntity.code == 200) {
          var post = await HttpUtil.getInstance()
              .post(Api.USER_LOGIN_BY_USERNAME, data: {
            "username": AppEncryptionUtil.verifyTokenEncode(
                spUtil.getString("username"))
          });

          var decode = json.decode(post.toString());
          var userEntity = UserEntity.fromJson(decode);
          if (userEntity.code == 200) {
            print("--------------------------------------------------------");
            print("--------------------------------------------------------");
            print("--------------------------------------------------------");
            print(decode);
            print("--------------------------------------------------------");
            print("--------------------------------------------------------");
            print("--------------------------------------------------------");
            print("--------------------------------------------------------");

            saveLoginUserData(userEntity.data[0]);
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(context,
                new CustomRouteSlide(new MainPage()), (route) => route == null);
          } else {
            ToastUtil.showCommonToast("用户信息获取错误或用户不存在！");
            Navigator.pop(context);
          }
        } else {
          ToastUtil.showCommonToast("注册失败");
        }
        print(response);
      } else {
        ToastUtil.showCommonToast("注册失败");
      }
    });
  }

  final List<String> _list = [
    '活泼',
    '健谈',
    "内向",
    "腹黑",
    "御姐型",
    "黑萝莉",
    "动漫控",
    "声控",
    "颜控",
    "马甲线",
    "安静",
    "热血",
    "理想主义",
    "厚道老实",
    "霸道",
    "强迫症",
    "萌萌哒",
    "吃货",
    "逗比",
    "敢爱敢恨",
    "选择恐惧症",
    "呆萌"
  ];
}
