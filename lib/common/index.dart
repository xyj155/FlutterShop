import 'package:flutter/material.dart';
import 'package:sauce_app/home/home_index.dart';
import 'package:sauce_app/login/login.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainPage.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    queryUserLoginState();
  }

  void queryUserLoginState() async {
    SpUtil instance = await SpUtil.instance;
    if (instance.getBool("login")!=null) {
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_) {
        return new MainPage();
      }), (route) => route == null);
    } else {
      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_) {
        return new LoginPage();
      }), (route) => route == null);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
