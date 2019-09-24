import 'package:flutter/material.dart';
class SquareShopFoodsPage extends StatefulWidget {
  @override
  _SquareShopFoodsPageState createState() => _SquareShopFoodsPageState();
}

class _SquareShopFoodsPageState extends State<SquareShopFoodsPage> with SingleTickerProviderStateMixin {
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
