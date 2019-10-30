import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';
class CommonShopDetailPage extends StatefulWidget {
  @override
  CommonShopDetailPageState createState() => new CommonShopDetailPageState();
}

class CommonShopDetailPageState extends State<CommonShopDetailPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:  BackUtil.NavigationBack(context, ""),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

        ],
      ),
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