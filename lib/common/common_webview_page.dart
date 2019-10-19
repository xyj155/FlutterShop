import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ToastUtil.dart';

class CommonWebViewPage extends StatefulWidget {
  String url;
  String title;

  // In the constructor, require a Todo
  CommonWebViewPage({Key key, @required this.url, @required this.title})
      : super(key: key);

  @override
  _CommonWebViewPageState createState() => _CommonWebViewPageState();
}

class _CommonWebViewPageState extends State<CommonWebViewPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
//    flutterWebviewPlugin.

    super.initState();
//    WebViewStateChanged(type, url, navigationType)
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        if (state.type == WebViewState.finishLoad) {
          loadJS();
        }
      }
    });

  }
  @override
  void dispose() {
    super.dispose();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
  }


  StreamSubscription<WebViewStateChanged> _onStateChanged;
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  String _title = "";

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      appBar: BackUtil.NavigationBack(context, _title),
      url: widget.url,
      withZoom: false,
      scrollBar: true,
      clearCache: true,
      clearCookies: true,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
String title="45454";
  void loadJS() async {
    flutterWebviewPlugin.evalJavascript('ale()').then((result) {
      print(result);

    });

    flutterWebviewPlugin.evalJavascript("window.document.title").then((result) {
      print(result);
      setState(() {
        _title = result.replaceAll("\"", "");
      });
    });
  }
}
