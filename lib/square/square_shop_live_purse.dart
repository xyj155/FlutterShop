import 'package:flutter/material.dart';
class SquareShopLivePage extends StatefulWidget {
  @override
  _SquareShopLivePageState createState() => _SquareShopLivePageState();
}

class _SquareShopLivePageState extends State<SquareShopLivePage> with SingleTickerProviderStateMixin {
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
    return Container();
  }
}
