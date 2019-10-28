import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';

class UserOrderCenterPage extends StatefulWidget {
  @override
  UserOrderCenterPageState createState() => new UserOrderCenterPageState();
}

class UserOrderCenterPageState extends State<UserOrderCenterPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: BackUtil.NavigationBack(context, "订单中心"),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
