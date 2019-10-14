import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/gson/home_user_topic_entity.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/widget/list_title_right.dart';

import 'topic_choose.dart';

class TextPostPage extends StatefulWidget {
  @override
  _TextPostPageState createState() => _TextPostPageState();
}

class _TextPostPageState extends State<TextPostPage>
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
  TextEditingController _contentController = new TextEditingController();
  FocusNode _contentFocusNode = FocusNode();
  String _content = "";
  String _topic_default="@请选择话题";
  String _visible_type="公开";
  String _topic_img_url="";
  Color font_color = Colors.grey;
  Color bg_color = Colors.transparent;
  bool isChoose=false;
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
                  new  Container(
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
                    padding: EdgeInsets.all(_screenUtils.setWidgetHeight(15)),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomRight:Radius.circular(_screenUtils.setWidgetWidth(4)),
                              topLeft: Radius.circular(_screenUtils.setWidgetWidth(4)),
                              topRight:  Radius.circular(_screenUtils.setWidgetWidth(4))),
                          child:new GestureDetector(
                            onTap: (){
                              _navigationWithMsg();
                            },
                            child:  Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: _screenUtils.setWidgetWidth(4)
                                  ,right: _screenUtils.setWidgetWidth(4),
                                  top: _screenUtils.setWidgetHeight(3),
                                  bottom: _screenUtils.setWidgetHeight(3)),
                              color:bg_color,
                              child: new RichText(
                                  text: new TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        _navigationWithMsg();
                                      },
                                    text:_topic_default ,
                                    style: new TextStyle(
                                        color: font_color,
                                        fontSize: _screenUtils.setFontSize(15)),)),
                            ),
                          ),
                        ),isChoose?
                        new Container(
                          margin: EdgeInsets.only(left: _screenUtils.setWidgetWidth(5),right: _screenUtils.setWidgetWidth(5)),
                          child: new ClipRRect(
                            child: new Image.network(_topic_img_url,width: _screenUtils.setWidgetWidth(35),height: _screenUtils.setWidgetHeight(35),fit: BoxFit.cover,),
                            borderRadius: BorderRadius.all(Radius.circular(_screenUtils.setWidgetHeight(35))),
                          ),
                        ):new Container()
                        ,
                      ],
                    ),
                  ),
                  new Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: _screenUtils.setWidgetHeight(30)),
                    child: new RightListTitle(
                      value: _visible_type,
                      title: "谁可见",
                      onTap: (){
                       showDialog(context: context,builder: (BuildContext context){
                         return new SimpleDialog(
                           title: new Text('谁可见',style: new TextStyle(
                               fontSize: _screenUtils.setFontSize(15)
                           ),),
                           children: <Widget>[
                             new SimpleDialogOption(
                               child: new Text('仅自己',style: new TextStyle(
                                 fontSize: _screenUtils.setFontSize(17),
                                 fontWeight: FontWeight.bold
                               ),),
                               onPressed: () {
                                 setState(() {
                                   _visible_type='仅自己';

                                 });
                                 Navigator.of(context).pop();
                               },
                             ),
                             new SimpleDialogOption(
                               child: new Text('公开',style: new TextStyle(
                                   fontSize: _screenUtils.setFontSize(17),
                                   fontWeight: FontWeight.bold
                               ),),
                               onPressed: () {
                                 Navigator.of(context).pop();
                                 setState(() {
                                   _visible_type='公开';
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
  Future _navigationWithMsg() async {
    var result = await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new UserTopicChoosePage()));
    if(result!=null){
//      var decode = json.decode(result);
      var homeUserTopicDataChild = HomeUserTopicDataChild.fromJson(result);
      setState(() {
        _topic_default="@ "+homeUserTopicDataChild.topicName;
        _topic_img_url=homeUserTopicDataChild.topicPicUrl;
        isChoose=true;
        font_color=Colors.white;
        bg_color=Color(0xff4ddfa9);
      });
    }

  }

}
