import 'dart:convert';

import 'package:sauce_app/api/Api.dart';
import 'package:sauce_app/gson/base_response_entity.dart';
import 'package:sauce_app/util/HttpUtil.dart';
import 'package:sauce_app/util/SharePreferenceUtil.dart';

class UserUtil {
  static Future submitUserViewHistory(String postId) async {
    var instance = await SpUtil.getInstance();
    var id = instance.getInt("id").toString();
    var response = await HttpUtil.getInstance()
        .get(Api.SUBMIT_USER_VIEW_HISTORY, data: {"userId": id, "postId": postId});
    print("--------------------------------------------------");
    print({"userId": id, "postId": postId});
    print("--------------------------------------------------");
    var decode = json.decode(response);
    var baseResponseEntity = BaseResponseEntity.fromJson(decode);
    if(baseResponseEntity.code==200){

    }
  }
}
