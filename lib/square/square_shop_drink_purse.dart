import 'package:flutter/material.dart';
class SquareShopDrinkPage extends StatefulWidget {
  @override
  _SquareShopDrinkPageState createState() => _SquareShopDrinkPageState();
}

class _SquareShopDrinkPageState extends State<SquareShopDrinkPage> with SingleTickerProviderStateMixin {
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
