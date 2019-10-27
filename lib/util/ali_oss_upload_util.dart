import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class AliUploadUtil{

  static Future<dynamic> uploadAliOSS(String bucketName,String filePath,String fileName) async {
    String policyText =
        '{"expiration": "2025-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';
    List<int> policyText_utf8 = utf8.encode(policyText);
    String policy_base64 = base64.encode(policyText_utf8);
    List<int> policy = utf8.encode(policy_base64);
    String accesskey= 'tW3BmS6mZRobC1RgBqrcKVoqtwXiQe';
    List<int> key = utf8.encode(accesskey);
    List<int> signature_pre  = new Hmac(sha1, key).convert(policy).bytes;
    String signature = base64.encode(signature_pre);
    BaseOptions options = new BaseOptions();
    options.responseType = ResponseType.plain;
    options.contentType = ContentType.parse("multipart/form-data");
    Dio dio = new Dio(options);
    FormData data = new FormData.from({
      'chunk': '0',
      'key' :  fileName,
      'policy': policy_base64,
      'Access-Control-Allow-Origin': '*',
      'OSSAccessKeyId': 'LTAIrucI0zt6hsPe',
      'success_action_status' : '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'file':  new UploadFileInfo(new File(filePath), fileName)
    });
    Response response = await dio.post(bucketName,data: data);
    return response;
  }
  static uploadUserAvatarAliOSS(String bucketName,String filePath,String fileName) async {
    String policyText =
        '{"expiration": "2025-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, 1048576000]]}';
    List<int> policyText_utf8 = utf8.encode(policyText);
    String policy_base64 = base64.encode(policyText_utf8);
    List<int> policy = utf8.encode(policy_base64);
    String accesskey= 'tW3BmS6mZRobC1RgBqrcKVoqtwXiQe';
    List<int> key = utf8.encode(accesskey);
    List<int> signature_pre  = new Hmac(sha1, key).convert(policy).bytes;
    String signature = base64.encode(signature_pre);
    BaseOptions options = new BaseOptions();
    options.responseType = ResponseType.plain;
    options.contentType = ContentType.parse("multipart/form-data");
    Dio dio = new Dio(options);
    FormData data = new FormData.from({
      'chunk': '0',
      'key' :  fileName,
      'policy': policy_base64,
      'Access-Control-Allow-Origin': '*',
      'OSSAccessKeyId': 'LTAIrucI0zt6hsPe',
      'success_action_status' : '200', //让服务端返回200，不然，默认会返回204
      'signature': signature,
      'file':  new UploadFileInfo(new File(filePath), fileName)
    });
    Response response = await dio.post(bucketName,data: data);
    return response;
  }
}