import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

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

  @override
  Widget build(BuildContext context) {
    _screenUtils.initUtil(context);
    _contentController.addListener(() {
      print('input ${_contentController.text}');
    });
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "发布"),
      body: new Container(
        color: Colors.white,
        child: Container(
          color: Color(0xfffafafa),
          padding: EdgeInsets.all(_screenUtils.setWidgetHeight(15)),
          height: _screenUtils.setWidgetHeight(250),
          child: TextFormField(
            maxLines: 999,
            decoration: InputDecoration(hintText: "说一点东西吧！"
            ,hintStyle: new TextStyle(
                  color: Colors.grey,
                ),border:  InputBorder.none),
            autofocus: true,
            onChanged: (content) {},
            style: TextStyle(
                color: Colors.black, fontSize: _screenUtils.setFontSize(15)),
            cursorColor: Colors.black,
            focusNode: _contentFocusNode,
            controller: _contentController,
          ),
        ),
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
}
