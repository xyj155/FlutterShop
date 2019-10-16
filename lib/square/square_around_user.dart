
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
class AroundUserPage extends StatefulWidget {
  @override
  _AroundUserPageState createState() => _AroundUserPageState();
}

class _AroundUserPageState extends State<AroundUserPage> with SingleTickerProviderStateMixin {

  double lat;
  double long;


  @override
  void initState() {

    super.initState();
  }




  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {

    super.dispose();
  }


  ScreenUtils screenUtils = new ScreenUtils();

  @override
  Widget build(BuildContext context) {

    screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "校园兼职"),
      body: new Stack(
        children: <Widget>[

        ],
      ),
    );
  }
}
