import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:amap_location/amap_location.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sauce_app/api/AliApi.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/gson/home_user_topic_entity.dart';
import 'package:sauce_app/util/HttpUtil.dart';

import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/util/ali_oss_upload_util.dart';
import 'package:sauce_app/util/amap_location_util.dart';
import 'package:sauce_app/widget/list_title_right.dart';
import 'package:sauce_app/widget/loading_dialog.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import 'topic_choose.dart';

class PostVideoPage extends StatefulWidget {
  PostVideoPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<PostVideoPage> with LoadingDelegate {
  String currentSelected = "";

  @override
  Widget buildBigImageLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildPreviewLoading(
      BuildContext context, AssetEntity entity, Color themeColor) {
    return Center(
      child: Container(
        width: 50.0,
        height: 50.0,
        child: CupertinoActivityIndicator(
          radius: 25.0,
        ),
      ),
    );
  }

  ScreenUtils _screenUtils = new ScreenUtils();
  TextEditingController _contentController = new TextEditingController();
  FocusNode _contentFocusNode = FocusNode();
  String _content = "";
  String _topic_default = "@请选择话题";
  String _visible_type = "公开";
  String _visible_code = "1";
  String _topic_img_url = "";
  Color font_color = Colors.grey;
  Color bg_color = Colors.transparent;
  bool isChoose = false;
  final TapGestureRecognizer recognizer = TapGestureRecognizer();

//  @override
//  void initState() {
//
//    super.initState();
//  }
  String _location = "";
  String _latitude = "";
  String _longitude = "";

  @override
  void initState() {
    super.initState();
    _checkPersmission();
    AmapUtil.startLocation((location) {
      AMapLocation aMapLocation = location;
      print("---------------------------------");
      print(aMapLocation.street);
      print(aMapLocation.longitude);
      print(aMapLocation.latitude);
      setState(() {
        _location = aMapLocation.city + " · " + aMapLocation.street;
        _latitude = aMapLocation.latitude.toString();
        _longitude = aMapLocation.longitude.toString();
      });
      print("---------------------------------");
    });
  }

  void _checkPersmission() async {
    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
    if (!hasPermission) {
      PermissionStatus requestPermissionResult =
          await SimplePermissions.requestPermission(
              Permission.WhenInUseLocation);
      if (requestPermissionResult != PermissionStatus.authorized) {
        ToastUtil.showCommonToast("申请定位权限失败");
        return;
      }
    }

    //    final options = LocationClientOptions(
//      isOnceLocation: true,
//      locatingWithReGeocode: true,
//    );
//    _amapLocation
//        .getLocation(options)
//        .then(_result.add)
//        .then((_) => setState(() {
//          print(_result[0].address);
//    }));
  }

  var _file_path = [];

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.5,
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: new Text("视频帖子", style: new TextStyle(color: Color(0xff000000))),
      ),
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
                                        _visible_code = "0";
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
                                        _visible_code = "1";
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
                    height: _screenUtils.setWidgetHeight(8),
                    color: Color(0xfffafafa),
                  ),
                  new Container(
                    margin: EdgeInsets.all(_screenUtils.setWidgetHeight(15)),
                    child: new GridView.builder(
                        shrinkWrap: true,
                        itemCount:
                            _file_path.length == 1 ? _file_path.length : 1,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 3.0,
                                crossAxisSpacing: 3.0,
                                childAspectRatio: 1.0),
                        itemBuilder: (BuildContext content, int position) {
                          if (position == _file_path.length) {
                            return new GestureDetector(
                              onTap: () {
                                _pickAsset(
                                  PickType.onlyVideo,
                                );
                              },
                              child: new Container(
                                padding: EdgeInsets.all(
                                    _screenUtils.setWidgetHeight(2)),
                                child: new ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          _screenUtils.setWidgetHeight(4))),
                                  child: new Image.asset(
                                      "assert/imgs/post_add_img.png",
                                      fit: BoxFit.contain),
                                ),
                              ),
                            );
                          } else {
                            print(_file_path.length > position
                                ? _file_path[position]
                                : _file_path.length);
                            return new Container(
                              color: Colors.black,
                              child: _file_path.length > position
                                  ? new ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              _screenUtils.setWidgetHeight(4))),
                                      child: new Chewie(
                                        controller: new ChewieController(
                                          showControls: false,
                                          videoPlayerController:
                                              videoPlayerController,
                                          aspectRatio:
                                              _video_width / _video_heiht,
                                          autoPlay: true,
                                          looping: true,
                                        ),
                                      ),
                                    )
                                  : new Container(),
                            );
                          }
                        }),
                  ),
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
                    text: "上传中...",
                  );
                });
            submitUserVideo();
//          Navigator.push(context, new MaterialPageRoute(builder: (_) {
//            return new ChooseGameName();
//          }));
          },
        ),
      ),
    );
  }

  Future submitUserVideo() async {
    var uuid = new Uuid();
    var spUtil = await SpUtil.getInstance();
    var uuid_code = uuid.v1();
    String _file = AliApi.MANGO_USER_PICTURE + uuid_code + ".mp4";
    AliUploadUtil.uploadAliOSS(
        AliApi.MANGO_USER_PICTURE, _video_choose_file, uuid_code + ".mp4");
    var string = spUtil.getInt("id").toString();
    var data = {
      "userId": string,
      "content": _content,
      "visible": _visible_code.toString(),
      "location": _location,
      "latitude": _latitude,
      "postTopic": _topic_id,
//      "postTopic": 1,
      "longitude": _longitude,
      "videoUrl": _file,
      "height": _video_heiht,
      "weight": _video_width,
      "duration": _duration
    };
    print(data);
    var response = await HttpUtil.getInstance()
        .post(Api.SUBMIT_USER_VIDEO_POST, data: data);
    var decode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if (baseResponseEntity.code == 200) {
      ToastUtil.showCommonToast("提交成功");
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      ToastUtil.showErrorToast("提交失败");
      Navigator.pop(context);
    }
  }

  var videoPlayerController;
  var _topic_id = "";

  Future _navigationWithMsg() async {
    var result = await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new UserTopicChoosePage()));
    if (result != null) {
      var homeUserTopicDataChild = HomeUserTopicDataChild.fromJson(result);
      setState(() {
        _topic_default = "@ " + homeUserTopicDataChild.topicName;
        _topic_img_url = homeUserTopicDataChild.topicPicUrl;
        _topic_id = homeUserTopicDataChild.id.toString();
        isChoose = true;
        font_color = Colors.white;
        bg_color = Color(0xff4ddfa9);
      });
    }
  }

  bool _is_choose = false;
  String _video_choose_file;
  String _duration;
  int _video_width;
  int _video_heiht;

  void _pickAsset(PickType type, {List<AssetPathEntity> pathList}) async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      context: context,
      themeColor: Colors.white,
      textColor: Colors.black,
      padding: 1.0,
      dividerColor: Colors.grey,
      disableColor: Colors.grey.shade300,
      maxSelected: 1,
      provider: I18nProvider.chinese,
      rowCount: 3,
      thumbSize: 150,
      sortDelegate: SortDelegate.common,
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
        checkColor: Color(0xff4ddfa9),
      ),
      loadingDelegate: this,
      badgeDelegate: const DurationBadgeDelegate(),
      pickType: type,
      photoPathList: pathList,
    );

    if (imgList == null) {
      currentSelected = "not select item";
    } else {
      List<String> r = [];
      for (var e in imgList) {
        var file = await e.file;
        r.add(file.absolute.path);
      }
      currentSelected = r.join("\n\n");

      List<AssetEntity> preview = [];
      preview.addAll(imgList);
      var file = await preview[0].file;
      var duration = preview[0].videoDuration.inMinutes;
      var width = preview[0].width;
      var height = preview[0].height;
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => VideoPreViewPage(
                    list: file,
                    width: width,
                    duration: duration,
                    height: height,
                  )));
      if (result != null) {
        var decode = json.decode(result);
        setState(() {
          _is_choose = true;
          _video_choose_file = decode["videoPath"];
          _video_heiht = decode["height"];
          _video_width = decode["width"];
          _duration = decode["duration"].toString();
          _file_path.add(_video_choose_file);
          videoPlayerController =
              new VideoPlayerController.file(new File(_video_choose_file));
        });
      }
      print("--------------==================--------------------");
      print(result);
      print("--------------==================--------------------");
    }
  }
}

class VideoPreViewPage extends StatefulWidget {
  final File list;
  final int width;
  final int height;
  final int duration;

  const VideoPreViewPage(
      {Key key, this.duration, this.list, this.width, this.height})
      : super(key: key);

  @override
  _VideoPreViewPageState createState() => _VideoPreViewPageState();
}

class _VideoPreViewPageState extends State<VideoPreViewPage>
    with SingleTickerProviderStateMixin {
  var chewieController;
  var videoPlayerController2;

  @override
  void initState() {
    getVideoFile();
    super.initState();
  }

  Future getVideoFile() async {
    videoPlayerController2 = new VideoPlayerController.file(widget.list);
    chewieController = new ChewieController(
      showControls: false,
      videoPlayerController: videoPlayerController2,
      aspectRatio: widget.width / widget.height,
      autoPlay: true,
      looping: true,
    );
    print("-----------------------------------");
    print(chewieController == null);
    print("-----------------------------------");
  }

  @override
  void dispose() {
    videoPlayerController2.dispose();
    chewieController.dispose();
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    return new Stack(
      children: <Widget>[
        Container(
          color: Colors.black,
          child: Center(
            child: new Chewie(
              controller: chewieController,
            ),
          ),
        ),
        new Positioned(
          child: new MaterialButton(
            color: Color(0xff4ddfa9),
            onPressed: () {
              var video_json = {
                "videoPath": widget.list.path,
                "width": widget.width,
                "duration": widget.duration,
                "height": widget.height
              };
              var encode = json.encode(video_json);
              Navigator.pop(context, encode);
            },
            child: new Text(
              "确认",
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          bottom: _screenUtils.setWidgetHeight(10),
          right: _screenUtils.setWidgetWidth(10),
        )
      ],
    );
  }
}
