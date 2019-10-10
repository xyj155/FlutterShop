import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';
class UserDetailPage extends StatefulWidget {
  UserDetailPage({Key key,String userId}): super(key: key);
  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> with SingleTickerProviderStateMixin {


  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "用户"),
      body: new Container(

      ),
    );
  }
}
