import 'package:flutter/material.dart';
class SquareShopPlayPage extends StatefulWidget {
  @override
  _SquareShopPlayPageState createState() => _SquareShopPlayPageState();
}

class _SquareShopPlayPageState extends State<SquareShopPlayPage> with SingleTickerProviderStateMixin {
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
