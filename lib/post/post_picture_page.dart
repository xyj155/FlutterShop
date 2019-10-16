import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

class PostPicturePage extends StatefulWidget {
  @override
  _PostPicturePageState createState() => _PostPicturePageState();
}

class _PostPicturePageState extends State<PostPicturePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ScreenUtils _screenUtils = new ScreenUtils();
  TextEditingController _contentController = new TextEditingController();
  FocusNode _contentFocusNode = FocusNode();
  List<String> _file_path = new List();

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
                  onChanged: (content) {},
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
//            showDialog<Null>(
//                context: context, //BuildContext对象
//                barrierDismissible: false,
//                builder: (BuildContext context) {
//                  return new LoadingDialog();
//                });
//            submitGameInvite();
//          Navigator.push(context, new MaterialPageRoute(builder: (_) {
//            return new ChooseGameName();
//          }));
          },
        ),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file_path.add(image.path);
    });
  }
}
