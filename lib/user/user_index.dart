import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/common_webview_page.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/user/user_address_page.dart';
import 'package:sauce_app/user/user_detail_center.dart';
import 'package:sauce_app/user/user_setting.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/user/user_observe_fans.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/widget/Post_detail.dart';

import 'user_game_list.dart';
import 'user_receive_added_page.dart';

ScreenUtils screenUtil = new ScreenUtils();

class UserPageIndex extends StatefulWidget {
  @override
  _UserPageIndexState createState() => _UserPageIndexState();
}

class _UserPageIndexState extends State<UserPageIndex> {
  @override
  void initState() {
    loadUserData();
    print("///////////////////////////");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String instance = "";
  String nickname = "";
  String avatar = "";
  String signature = "";
  String observe = "";
  String fans = "";
  String score = "";

  void loadUserData() async {
    var instance = await SpUtil.getInstance();
    setState(() {
      nickname = instance.getString("nickname");
      avatar = instance.getString("avatar");
      print("══════════════****══════════════════════");
      print(avatar);
      print("══════════════****══════════════════════");
      signature = instance.getString("signature");
      observe = instance.getString("observe");
      fans = instance.getString("fans");
      score = instance.getString("score");
    });
  }

  String _avatar_path = "";

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      Directory documentsDir = await getApplicationDocumentsDirectory();
      String documentsPath = documentsDir.path;
      CompressObject compressObject =
      CompressObject(imageFile: image, path: documentsPath);
      Luban.compressImage(compressObject).then((_path) {
        setState(() {
          print(_path);
          _avatar_path = _path;
          uploadAvatar();
        });
      }).catchError((e) {
        ToastUtil.showCommonToast("上传头像失败，请重新选择！" + e.toString());
      });
    }

  }

  Future uploadAvatar() async {
    var spUtil = await SpUtil.getInstance();
    var string = spUtil.getInt("id").toString();
    FormData formData = new FormData.fromMap({
      "userId": string,
      "avatar": await MultipartFile.fromFileSync(_avatar_path),
    });
    var response = await HttpUtil.getInstance()
        .getDio()
        .post(Api.UPDATE_USER_AVATAR, data: formData);
    var decode = json.decode(response.toString());
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      setState(() {
        avatar = baseResponseEntity.msg;
        spUtil.putString("avatar", avatar);
        loadUserData();
      });
      ToastUtil.showCommonToast("头像设置成功");
    } else {
      ToastUtil.showErrorToast("上传头像失败" + baseResponseEntity.msg);
    }
  }
  var _user_thumb = [
    "assert/imgs/person_likex.png",
    "assert/imgs/detail_like_selectedx.png"
  ];

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    String _default_thumb =_user_thumb[0];
    int thumb_count = 3;
    return new CustomScrollView(
      physics: ScrollPhysics(),
      slivers: <Widget>[
        new SliverToBoxAdapter(
          child: new Container(
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: new EdgeInsets.only(
                      top: screenUtil.setWidgetHeight(15),
                      left: screenUtil.setWidgetWidth(20),
                      bottom: screenUtil.setWidgetHeight(15)),
                  child: new Text("我的",
                      style: TextStyle(
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  alignment: Alignment.topLeft,
                ),
                new GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return new UserDetailCenterPage();
                    }));
                  },
                  child: new Container(
                    padding: new EdgeInsets.only(
                        left: screenUtil.setWidgetWidth(20),
                        bottom: screenUtil.setWidgetHeight(5),
                        right: screenUtil.setWidgetWidth(20)),
                    child: new Row(
                      children: <Widget>[
                        new GestureDetector(
                          child: new ClipRRect(
                            child: Image.network(
                              avatar,
                              fit: BoxFit.cover,
                              height: screenUtil.setWidgetHeight(74),
                              width: screenUtil.setWidgetWidth(72),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(screenUtil.setWidgetHeight(74)),
                            ),
                          ),
                          onTap: () {
                            getImage();
                          },
                        ),
                        new Expanded(
                            child: new Container(
                          padding: EdgeInsets.only(left: 20),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  nickname,
                                  style: new TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                                new Divider(
                                  color: Colors.transparent,
                                  height: 10,
                                ),
                                new Text(
                                  signature,
                                  style: new TextStyle(
                                      fontSize: 14, color: Color(0xff8a8a8a)),
                                ),
                              ]),
                        )),
                        new Image.asset(
                          "assert/imgs/person_arrow_right_grayx.png",
                          width: 15,
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                new Divider(
                    indent: 20, height: 16.0, color: Colors.transparent),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: new Column(
                          children: <Widget>[
                            new Text(
                              fans,
                              style: new TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000)),
                            ),
                            new Text(
                              "粉丝",
                              style: new TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (_) {
                            return new UserObserveFansPage(
                              type: "0",
                            );
                          }));
                        },
                      ),
                    ),
                    new Expanded(
                      child: new GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: new Column(
                          children: <Widget>[
                            new Text(
                              observe,
                              style: new TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000)),
                            ),
                            new Text(
                              "关注",
                              style: new TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (_) {
                            return new UserObserveFansPage(
                              type: "1",
                            );
                          }));
                        },
                      ),
                    ),
                    new Expanded(
                        child: new GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            score,
                            style: new TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000)),
                          ),
                          new Text(
                            "积分",
                            style: new TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
                new Container(
                  height: 5.0,
                  color: Color(0xfffafafa),
                  margin: EdgeInsets.only(top: 16),
                ),
                new ListTile(
                  title: new Text(
                    "我的发帖",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/person_arrow_right_grayx.png",
                    height: 15,
                    width: 15,
                  ),
                  leading: new Image.asset(
                    "assert/imgs/ic_user_post_collection.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                new ListTile(
                  title: new Text(
                    "我的收藏",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/person_arrow_right_grayx.png",
                    height: 15,
                    width: 15,
                  ),
                  leading: new Image.asset(
                    "assert/imgs/ic_user_collection.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                new ListTile(
                  title: new Text(
                    "浏览历史",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/person_arrow_right_grayx.png",
                    height: 15,
                    width: 15,
                  ),
                  leading: new Image.asset(
                    "assert/imgs/ic_user_view_history.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                new Container(
                    height: screenUtil.setWidgetHeight(10),
                    color: Color(0xfffafafa)),
                new ListTile(
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return UserAddressPage();
                    }));
                  },
                  title: new Text(
                    "收货地址",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/person_arrow_right_grayx.png",
                    height: 15,
                    width: 15,
                  ),
                  leading: new Image.asset(
                    "assert/imgs/ic_user_location.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                new Container(
                    height: screenUtil.setWidgetHeight(10),
                    color: Color(0xfffafafa)),
                new ListTile(
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return new CommonWebViewPage(
                          title: "抽奖",
                          url:
                              "http://sxystushop.xyz/JustLikeThis/public/luckdraw/default.html");
                    }));
                  },
                  title: new Text(
                    "抽奖",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/person_arrow_right_grayx.png",
                    height: 15,
                    width: 15,
                  ),
                  leading: new Image.asset(
                    "assert/imgs/ic_user_prize.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                new ListTile(
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return new UserGameListPage();
                    }));
                  },
                  title: new Text(
                    "玩游戏 送礼品",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/person_arrow_right_grayx.png",
                    height: 15,
                    width: 15,
                  ),
                  leading: new Image.asset(
                    "assert/imgs/ic_user_game.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                new ListTile(
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return new CommonWebViewPage(
                          url:
                              'http://47.98.122.133/Admini/app/inviteFriend.html',
                          title: "邀请好友");
                    }));
                  },
                  title: new Text(
                    "邀请",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/person_arrow_right_grayx.png",
                    height: 15,
                    width: 15,
                  ),
                  leading: new Image.asset(
                    "assert/imgs/ic_user_invite.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                new Container(
                    height: screenUtil.setWidgetHeight(10),
                    color: Color(0xfffafafa)),
                new ListTile(
                  onTap: () {
                    Navigator.push(context,
                        new CustomRouteSlide(new UserSettingPageIndex()));
                  },
                  title: new Text(
                    "设置",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  trailing: new Image.asset(
                    "assert/imgs/person_arrow_right_grayx.png",
                    height: 15,
                    width: 15,
                  ),
                  leading: new Image.asset(
                    "assert/imgs/ic_user_setting.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
