import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:flutter_tags/tag.dart';
import 'package:sauce_app/widget/input_text_fied.dart';

class UserAvatarRegisterPage extends StatefulWidget {
  String headImg;
  String nickName;
  String gender;
  bool qq;

  UserAvatarRegisterPage(
      {Key key,
      @required this.headImg,
      @required this.nickName,
      @required this.gender,
      @required this.qq})
      : super(key: key);

  @override
  _UserAvatarRegisterPageState createState() => _UserAvatarRegisterPageState();
}

class _UserAvatarRegisterPageState extends State<UserAvatarRegisterPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    setUserSex();
    _items = _list.toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _imagePath;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    setState(() {
      CompressObject compressObject =
          CompressObject(imageFile: image, path: documentsPath);
      Luban.compressImage(compressObject).then((_path) {
        setState(() {
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
  String startYear = "请选择你的性别";
  var data = ['男', '女'];

  void setUserSex() {
    for (int i = 0; i < data.length; i++) {
      list.add(new PickerItem(text: new Text(data[i]), value: data[i]));
    }
  }

  ScreenUtils screenUtil = new ScreenUtils();
  List _items = new List();

  @override
  Widget build(BuildContext context) {
    screenUtil.initUtil(context);
    // TODO: implement build
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "账号信息"),
      body: new Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new Column(children: <Widget>[
                  new Container(
                    width: screenUtil.setWidgetWidth(170),
                    child: new Text(widget.nickName,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            decoration: TextDecoration.none,
                            color: Color(0xff000000),
                            fontSize: screenUtil.setWidgetWidth(29),
                            fontWeight: FontWeight.bold)),
                  ),
                  new Container(
                    child: new Text("你在使用${widget.qq ? "QQ" : "微信"}账号登陆",
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
                ], crossAxisAlignment: CrossAxisAlignment.start)),
                new ClipOval(
                  child: Image.network(
                    widget.headImg,
                    fit: BoxFit.fill,
                    height: screenUtil.setWidgetHeight(88),
                    width: screenUtil.setWidgetWidth(82),
                  ),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            new GestureDetector(
              child: new Container(
                color: Color(0xfff8f8f8),
                padding: EdgeInsets.only(left: screenUtil.setWidgetWidth(15)),
                alignment: Alignment.centerLeft,
                height: screenUtil.setWidgetHeight(55),
                margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(16)),
                child: new Text(
                  startYear,
                  style: new TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: screenUtil.setFontSize(16),
                      color: Color(0xff8a8a8a),
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
                        startYear = "性别：" + data[value[0]];
                      });
                    });
                picker.showModal(context);
              },
            ),
            new Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              height: screenUtil.setWidgetHeight(55),
              margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(8)),
              child: new Text("选择你的性格",
                  style: new TextStyle(
                      fontSize: screenUtil.setFontSize(16),
                      color: Colors.black)),
            ),
            new Container(
              margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(10)),
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
                    title: item,
                    pressEnabled: true,
                    activeColor: Color(0xff7c7f88),
                    singleItem: false,
                    combine: ItemTagsCombine.withTextBefore,
                    textScaleFactor:
                        utf8.encode(item.substring(0, 1)).length > 2 ? 0.8 : 1,
                    textStyle: TextStyle(
                      fontSize: screenUtil.setFontSize(17),
                    ),
                    onPressed: (item) => print(item),
                  );
                },
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              height: screenUtil.setWidgetHeight(50),
              margin: EdgeInsets.only(top: screenUtil.setWidgetHeight(28)),
              child: new MaterialButton(
                color: Color(0xff7c7f88),
                textColor: Colors.white,
                child: new Text(
                  '下一步',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (_) {
                    return new UserAvatarRegisterPage();
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
            top: screenUtil.setWidgetWidth(20)),
      ),
    );
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
