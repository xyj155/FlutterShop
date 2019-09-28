import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:sauce_app/util/CommonBack.dart';

class CommonWebViewPage extends StatefulWidget {
  String url;
  String title;


  // In the constructor, require a Todo
  CommonWebViewPage({Key key, @required this.url, @required this.title}) : super(key: key);

  @override
  _CommonWebViewPageState createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
//    flutterWebviewPlugin.

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: BackUtil.NavigationBack(context, widget.title),
      url: widget.url,
      withZoom: false,
      scrollBar: true,
      clearCache: true,
      clearCookies: true,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}
