import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';
class UserGameListPage extends StatefulWidget {
  @override
  _UserGameListPageState createState() => _UserGameListPageState();
}

class _UserGameListPageState extends State<UserGameListPage> with SingleTickerProviderStateMixin {
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
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "玩游戏"),
      body: new ListView.builder(
          itemBuilder: null),
    );
  }
}
