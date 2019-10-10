import 'package:flutter/material.dart';
class SquareShopAllPage extends StatefulWidget {
  @override
  _SquareShopAllPageState createState() => _SquareShopAllPageState();
}

class _SquareShopAllPageState extends State<SquareShopAllPage> with SingleTickerProviderStateMixin {
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
