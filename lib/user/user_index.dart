import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/common/common_vide_player.dart';
import 'package:sauce_app/common/common_webview_page.dart';
import 'package:sauce_app/common/picture_preview_dialog.dart';
import 'package:sauce_app/common/user_detail_page.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/user_post_item_entity.dart';
import 'package:sauce_app/home/home_post_item_detail.dart';
import 'package:sauce_app/user/user_address_page.dart';
import 'package:sauce_app/user/user_detail_center.dart';
import 'package:sauce_app/user/user_setting.dart';
import 'package:sauce_app/util/Base64.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/user/user_observe_fans.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/TransationUtil.dart';
import 'package:sauce_app/util/relative_time_util.dart';
import 'package:sauce_app/widget/Post_detail.dart';
import 'package:share/share.dart';

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
    if (image != null) {
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
    FormData formData = new FormData.from({
      "userId": string,
      "avatar": new UploadFileInfo(new File(_avatar_path),
          Base642Text.encodeBase64(new TimeOfDay.now().toString())),
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
    String _default_thumb = _user_thumb[0];
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
                  onTap: (){

                    Navigator.push(context, new MaterialPageRoute(builder: (_){
                      return UserPostListPage();
                    }));
                  },
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
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(builder: (_){
                      return UserViewHistoryPage();
                    }));
                  },
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

class UserPostListPage extends StatefulWidget {
  @override
  _UserPostListPageState createState() => _UserPostListPageState();
}

class _UserPostListPageState extends State<UserPostListPage>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    getUserPostByUserId();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }
ScreenUtils _screenUtils=new ScreenUtils();
  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "我的发帖"),
      body: new Container(
        child: EasyRefresh(
          header: ClassicalHeader(
              enableInfiniteRefresh: false,
              refreshText: "正在刷新...",
              completeDuration: Duration(milliseconds: 500),
              refreshReadyText: "下拉我刷新哦！",
              refreshingText: "还在刷新哦！",
              refreshedText: "刷新好了哦！嘻嘻",
              refreshFailedText: "刷新失败了哦！",
              noMoreText: "没有数据了",
              infoText: "",
              bgColor: Colors.white,
              infoColor: Colors.white),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1), () {
              setState(() {
                getUserPostByUserId();
              });
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              page = page + 1;
              setState(() {
                getUserPostByUserIdNextPage(page);
              });
            });
          },
          footer: new ClassicalFooter(
              loadText: "",
              completeDuration: Duration(milliseconds: 500),
              loadReadyText: "放开我啦！",
              loadingText: "努力获取数据中",
              loadedText: "加载完成了！",
              loadFailedText: "加载失败了！",
              noMoreText: "没有数据了哦！",
              infoText: "",
              bgColor: Colors.white,
              infoColor: Colors.white),
          child: getBody(),
        ),
      ),
    );
  }

  getBody() {
    if (_user_post_list.length != 0) {
      return ListView.builder(
          itemCount: _user_post_list.length,
          itemBuilder: (BuildContext context, int position) {
            return setUserPostList(_user_post_list[position]);
          });
    } else {
      // 加载菊花
      return new Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }

  List<UserPostItemData> _user_post_list = new List();
  int page = 1;

  Future getUserPostByUserId() async {
    var instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_USER_POST_LIST_BY_USERID,
        data: {"userId": instance.getInt("id").toString(), "page": 1});
    var decode = json.decode(response);
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      _user_post_list = userPostItemEntity.data;
    });
  }

  Future getUserPostByUserIdNextPage(int pages) async {
    var instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_USER_POST_LIST_BY_USERID,
        data: {"userId": instance.getInt("id").toString(), "page": pages});
    var decode = json.decode(response);
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      _user_post_list.addAll(userPostItemEntity.data);
    });
  }

  setUserPostList(UserPostItemData index) {
    print("-------------------------------------------");
    print(index.pictures.length);
    print(index.pictures.length);
    print("-------------------------------------------");
    var like_bumlb = index.like == 1
        ? "assert/imgs/detail_like_selectedx.png"
        : "assert/imgs/person_likex.png";
    int thumb_count = int.parse(index.thumbCount);
    var _picture_list = [];
    var pictures = index.pictures;
    for (var o in pictures) {
      _picture_list.add(o.postPictureUrl);
    }
    return new GestureDetector(
      child: new Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    print("--------------------------------------");
                    print(index.user.toJson());
                    print("--------------------------------------");
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return new UserDetailPage(
                          userId: index.user.id.toString());
                    }));
                  },
                  child: new Container(
                    padding: EdgeInsets.only(
                        top: screenUtil.setWidgetHeight(20),
                        left: screenUtil.setWidgetWidth(20),
                        right: screenUtil.setWidgetWidth(6)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assert/imgs/loading.gif",
                        image: "${index.user.avatar}",
                        fit: BoxFit.cover,
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(
                          top: screenUtil.setWidgetHeight(20),
                          right: screenUtil.setWidgetWidth(6)),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            "${index.user.nickname}",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenUtil.setFontSize(15)),
                          ),
                          new Text(
                            "${RelativeDateFormat.format(index.createTime)}",
                            style: new TextStyle(
                                fontSize: screenUtil.setFontSize(11),
                                color: Color(0xff9B9B9B)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            new Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: screenUtil.setFontSize(20),
                  right: screenUtil.setFontSize(20),
                  top: screenUtil.setFontSize(14),
                  bottom: screenUtil.setFontSize(10)),
              child: new Text(
                Base642Text.decodeBase64("${index.postContent}"),
                style: new TextStyle(
                  fontSize: screenUtil.setFontSize(17),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.left,
              ),
            ),
            new Container(
                child: index.postType == 1
                    ? new GridView.builder(
                  padding: EdgeInsets.only(
                      left: screenUtil.setWidgetWidth(20),
                      right: screenUtil.setWidgetWidth(20),
                      top: screenUtil.setWidgetHeight(8),
                      bottom: screenUtil.setWidgetHeight(8)),
                  physics: new NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6.0,
                    crossAxisSpacing: 6.0,
                  ),
                  itemCount: _picture_list.length,
                  itemBuilder: (BuildContext context, int indexs) {
                    return new GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: "${_picture_list[indexs]}" +
                              "?x-oss-process=style/image_press",
                          fit: BoxFit.cover,
                          width: screenUtil.setWidgetWidth(54),
                          height: screenUtil.setWidgetWidth(54),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PhotoGalleryPage(
                                    index: indexs,
                                    photoList: _picture_list,
                                  )),
                        );
                      },
                    );
                  },
                )
                    : index.pictures.length==0
                    ? new Container()
                    : new GestureDetector(
                  onTap: () {
                    print("-------------------------------------------");
                    print(index.pictures[0].height);
                    print(index.pictures[0].weight);
                    print("-------------------------------------------");
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (_) {
                          return new CommonVideoPlayer(
                            videoUrl: index.pictures[0].postPictureUrl,
                            height: index.pictures[0].height,
                            width: index.pictures[0].weight,
                          );
                        }));
                  },
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(
                            left: screenUtil.setWidgetHeight(20)),
                        alignment: Alignment.center,
                        height: screenUtil.setWidgetHeight(200),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: "${index.pictures[0].postPictureUrl}" +
                              "?x-oss-process=video/snapshot,t_5000,f_jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                            left: screenUtil.setWidgetHeight(20)),
                        height: screenUtil.setWidgetHeight(200),
                        alignment: Alignment.center,
                        child: new Image.asset(
                          "assert/imgs/video_player.png",
                          width: screenUtil.setWidgetWidth(40),
                          height: screenUtil.setWidgetHeight(40),
                        ),
                      ),
                    ],
                  ),
                )),
            new Row(
              children: <Widget>[
                new UserPostDetailList(
                  title: "分享",
                  imagePath: "assert/imgs/person_share.png",
                  onTap: () {
                    Share.share(
                        '【玩安卓Flutter版】\n https://github.com/yechaoa/wanandroid_flutter');
                  },
                ),
                new UserPostDetailList(
                  title: "评论" + index.commentCount.toString(),
                  imagePath: "assert/imgs/person_commentx.png",
                ),
                new UserPostDetailList(
                  onTap: () {
                    if (index.like == 1) {
                      return;
                    }
                    userThumb(index).then((isSuccess) {
                      print(isSuccess);
                      if (isSuccess) {
                        setState(() {
                          like_bumlb = 'assert/imgs/detail_like_selectedx.png';
                          index.like = 1;
                          index.thumbCount =
                              (int.parse(index.thumbCount) + 1).toString();
                        });
                      }
                    });
                  },
                  title: "点赞 " + thumb_count.toString(),
                  imagePath: like_bumlb,
                ),
                new Expanded(
                    child: new Container(
                        child: new Image.asset(
                          "assert/imgs/post_more.png",
                          width: screenUtil.setWidgetWidth(24),
                          height: screenUtil.setWidgetHeight(21),
                        ),
                        alignment: Alignment.centerRight))
              ],
            ),
            new Container(
              height: screenUtil.setWidgetHeight(8),
              color: Color(0xfffafafa),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            CustomRouteSlide(
                UserPostDetailItemPage(postId: "${index.id.toString()}")));
      },
    );
  }

  Future<bool> userThumb(UserPostItemData postId) async {
    var spUtil = await SpUtil.instance;
    var id = spUtil.getInt("id");

    var reponse =
        await HttpUtil.getInstance().post(Api.USER_UPDATE_BY_POST_ID, data: {
      "userId": id.toString(),
      "postId": postId.id.toString(),
      "postUserId": postId.user.id.toString()
    });
    var decode = json.decode(reponse);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code != 200) {
      ToastUtil.showCommonToast("点赞失败！");
      return false;
    } else {
      ToastUtil.showErrorToast("点赞成功");
      return true;
    }
  }
}

class UserViewHistoryPage extends StatefulWidget {
  @override
  _UserViewHistoryPageState createState() => _UserViewHistoryPageState();
}

class _UserViewHistoryPageState extends State<UserViewHistoryPage> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    getUserPostByUserId();
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }
ScreenUtils _screenUtils=new ScreenUtils();
  List<UserPostItemData> _user_post_list = new List();
  int page = 1;
  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "浏览历史"),
      body: new Container(
        child: EasyRefresh(
          header: ClassicalHeader(
              enableInfiniteRefresh: false,
              refreshText: "正在刷新...",
              completeDuration: Duration(milliseconds: 500),
              refreshReadyText: "下拉我刷新哦！",
              refreshingText: "还在刷新哦！",
              refreshedText: "刷新好了哦！嘻嘻",
              refreshFailedText: "刷新失败了哦！",
              noMoreText: "没有数据了",
              infoText: "",
              bgColor: Colors.white,
              infoColor: Colors.white),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1), () {
              setState(() {
                getUserPostByUserId();
              });
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              page = page + 1;
              setState(() {
                getUserPostByUserIdNextPage(page);
              });
            });
          },
          footer: new ClassicalFooter(
              loadText: "",
              completeDuration: Duration(milliseconds: 500),
              loadReadyText: "放开我啦！",
              loadingText: "努力获取数据中",
              loadedText: "加载完成了！",
              loadFailedText: "加载失败了！",
              noMoreText: "没有数据了哦！",
              infoText: "",
              bgColor: Colors.white,
              infoColor: Colors.white),
          child: getBody(),
        ),
      ),
    );
  }
  getBody() {
    if (_user_post_list.length != 0) {
      return ListView.builder(
          itemCount: _user_post_list.length,
          itemBuilder: (BuildContext context, int position) {
            return setUserPostList(_user_post_list[position]);
          });
    } else {
      // 加载菊花
      return new Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }
  setUserPostList(UserPostItemData index) {
    print("-------------------------------------------");
    print(index.pictures.length);
    print(index.pictures.length);
    print("-------------------------------------------");
    var like_bumlb = index.like == 1
        ? "assert/imgs/detail_like_selectedx.png"
        : "assert/imgs/person_likex.png";
    int thumb_count = int.parse(index.thumbCount);
    var _picture_list = [];
    var pictures = index.pictures;
    for (var o in pictures) {
      _picture_list.add(o.postPictureUrl);
    }
    return new GestureDetector(
      child: new Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new GestureDetector(
                  onTap: () {
                    print("--------------------------------------");
                    print(index.user.toJson());
                    print("--------------------------------------");
                    Navigator.push(context, new MaterialPageRoute(builder: (_) {
                      return new UserDetailPage(
                          userId: index.user.id.toString());
                    }));
                  },
                  child: new Container(
                    padding: EdgeInsets.only(
                        top: screenUtil.setWidgetHeight(20),
                        left: screenUtil.setWidgetWidth(20),
                        right: screenUtil.setWidgetWidth(6)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assert/imgs/loading.gif",
                        image: "${index.user.avatar}",
                        fit: BoxFit.cover,
                        width: 44,
                        height: 44,
                      ),
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(
                          top: screenUtil.setWidgetHeight(20),
                          right: screenUtil.setWidgetWidth(6)),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            "${index.user.nickname}",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenUtil.setFontSize(15)),
                          ),
                          new Text(
                            "${RelativeDateFormat.format(index.createTime)}",
                            style: new TextStyle(
                                fontSize: screenUtil.setFontSize(11),
                                color: Color(0xff9B9B9B)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            new Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: screenUtil.setFontSize(20),
                  right: screenUtil.setFontSize(20),
                  top: screenUtil.setFontSize(14),
                  bottom: screenUtil.setFontSize(10)),
              child: new Text(
                Base642Text.decodeBase64("${index.postContent}"),
                style: new TextStyle(
                  fontSize: screenUtil.setFontSize(17),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.left,
              ),
            ),
            new Container(
                child: index.postType == 1
                    ? new GridView.builder(
                  padding: EdgeInsets.only(
                      left: screenUtil.setWidgetWidth(20),
                      right: screenUtil.setWidgetWidth(20),
                      top: screenUtil.setWidgetHeight(8),
                      bottom: screenUtil.setWidgetHeight(8)),
                  physics: new NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 6.0,
                    crossAxisSpacing: 6.0,
                  ),
                  itemCount: _picture_list.length,
                  itemBuilder: (BuildContext context, int indexs) {
                    return new GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: "${_picture_list[indexs]}" +
                              "?x-oss-process=style/image_press",
                          fit: BoxFit.cover,
                          width: screenUtil.setWidgetWidth(54),
                          height: screenUtil.setWidgetWidth(54),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PhotoGalleryPage(
                                    index: indexs,
                                    photoList: _picture_list,
                                  )),
                        );
                      },
                    );
                  },
                )
                    : index.pictures.length==0
                    ? new Container()
                    : new GestureDetector(
                  onTap: () {
                    print("-------------------------------------------");
                    print(index.pictures[0].height);
                    print(index.pictures[0].weight);
                    print("-------------------------------------------");
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (_) {
                          return new CommonVideoPlayer(
                            videoUrl: index.pictures[0].postPictureUrl,
                            height: index.pictures[0].height,
                            width: index.pictures[0].weight,
                          );
                        }));
                  },
                  child: new Stack(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(
                            left: screenUtil.setWidgetHeight(20)),
                        alignment: Alignment.center,
                        height: screenUtil.setWidgetHeight(200),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assert/imgs/loading.gif",
                          image: "${index.pictures[0].postPictureUrl}" +
                              "?x-oss-process=video/snapshot,t_5000,f_jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                            left: screenUtil.setWidgetHeight(20)),
                        height: screenUtil.setWidgetHeight(200),
                        alignment: Alignment.center,
                        child: new Image.asset(
                          "assert/imgs/video_player.png",
                          width: screenUtil.setWidgetWidth(40),
                          height: screenUtil.setWidgetHeight(40),
                        ),
                      ),
                    ],
                  ),
                )),
            new Row(
              children: <Widget>[
                new UserPostDetailList(
                  title: "分享",
                  imagePath: "assert/imgs/person_share.png",
                  onTap: () {
                    Share.share(
                        '【玩安卓Flutter版】\n https://github.com/yechaoa/wanandroid_flutter');
                  },
                ),
                new UserPostDetailList(
                  title: "评论" + index.commentCount.toString(),
                  imagePath: "assert/imgs/person_commentx.png",
                ),
                new UserPostDetailList(
                  onTap: () {
                    if (index.like == 1) {
                      return;
                    }
                    userThumb(index).then((isSuccess) {
                      print(isSuccess);
                      if (isSuccess) {
                        setState(() {
                          like_bumlb = 'assert/imgs/detail_like_selectedx.png';
                          index.like = 1;
                          index.thumbCount =
                              (int.parse(index.thumbCount) + 1).toString();
                        });
                      }
                    });
                  },
                  title: "点赞 " + thumb_count.toString(),
                  imagePath: like_bumlb,
                ),
                new Expanded(
                    child: new Container(
                        child: new Image.asset(
                          "assert/imgs/post_more.png",
                          width: screenUtil.setWidgetWidth(24),
                          height: screenUtil.setWidgetHeight(21),
                        ),
                        alignment: Alignment.centerRight))
              ],
            ),
            new Container(
              height: screenUtil.setWidgetHeight(8),
              color: Color(0xfffafafa),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            CustomRouteSlide(
                UserPostDetailItemPage(postId: "${index.id.toString()}")));
      },
    );
  }
  Future getUserPostByUserId() async {
    var instance = await SpUtil.getInstance();

    var response = await HttpUtil.getInstance().get(
        Api.QUERY_USER_VIEW_HISTORY,
        data: {"userId": instance.getInt("id").toString(), "page": 1});
    print("------------------------------------------");
    print(response);
    print("------------------------------------------");
    var decode = json.decode(response);
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      _user_post_list = userPostItemEntity.data;
    });
  }

  Future getUserPostByUserIdNextPage(int pages) async {
    var instance = await SpUtil.getInstance();
    var response = await HttpUtil.getInstance().get(
        Api.QUERY_USER_VIEW_HISTORY,
        data: {"userId": instance.getInt("id").toString(), "page": pages});
    var decode = json.decode(response);
    var userPostItemEntity = UserPostItemEntity.fromJson(decode);
    setState(() {
      _user_post_list.addAll(userPostItemEntity.data);
    });
  }

  Future<bool> userThumb(UserPostItemData postId) async {
    var spUtil = await SpUtil.instance;
    var id = spUtil.getInt("id");

    var reponse =
    await HttpUtil.getInstance().post(Api.USER_UPDATE_BY_POST_ID, data: {
      "userId": id.toString(),
      "postId": postId.id.toString(),
      "postUserId": postId.user.id.toString()
    });
    var decode = json.decode(reponse);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code != 200) {
      ToastUtil.showCommonToast("点赞失败！");
      return false;
    } else {
      ToastUtil.showErrorToast("点赞成功");
      return true;
    }
  }
}
