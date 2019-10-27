import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getuuid/flutter_getuuid.dart';
import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/util/HttpUtil.dart';

import 'invite_code_input_page.dart';
import 'login.dart';
class IsSubmitInviteCodePage extends StatefulWidget {
  @override
  IsSubmitInviteCodePageState createState() => new IsSubmitInviteCodePageState();
}

class IsSubmitInviteCodePageState extends State<IsSubmitInviteCodePage> {

  Future queryUserByCode() async {
    var uuid = await FlutterGetuuid.platformUid;
    print("=====================================");
    print(uuid);
    print("=====================================");
    var instance = await HttpUtil.getInstance()
        .get(Api.QUERY_USER_BY_INVITE_CODE, data: {"ime": uuid});
    return instance;
  }
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: queryUserByCode(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print('还没有开始网络请求');
            return Center(
              child: CupertinoActivityIndicator(
                radius: 14,
              ),
            );
          case ConnectionState.active:
            print('active');
            return Center(
              child: CupertinoActivityIndicator(
                radius: 14,
              ),
            );
          case ConnectionState.waiting:
            print('waiting');
            return Center(
              child: CupertinoActivityIndicator(
                radius: 14,
              ),
            );
          case ConnectionState.done:

            var decode = json.decode(snapshot.data);
            var baseResponseEntity = BaseResponseEntity.fromJson(decode);
            if (baseResponseEntity.code == 200) {
              return new UserTelVerifyPage();
            }
            return new LoginPage();

          default:
            return null;
        }
      },
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