import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:sauce_app/util/CommonBack.dart';
class CommonWebViewPage extends StatefulWidget {
  String url;
  String title;


  // In the constructor, require a Todo
  CommonWebViewPage({Key key, @required this.url,this.title}) : super(key: key);

  @override
  _CommonWebViewPageState createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage>
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

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url:widget.url,
      // 登录的URL
      appBar:BackUtil.NavigationBack(context, widget.title),
      withZoom: false,
      scrollBar: true,
      clearCache: true,
      clearCookies: true,
      withLocalStorage: true,
      withJavascript: true,
    );

  }
}
