import 'package:flutter/material.dart';
class SquareShopWearPage extends StatefulWidget {
  @override
  _SquareShopWearPageState createState() => _SquareShopWearPageState();
}

class _SquareShopWearPageState extends State<SquareShopWearPage> with SingleTickerProviderStateMixin {
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
