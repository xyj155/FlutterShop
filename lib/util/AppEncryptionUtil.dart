import 'dart:convert';

class AppEncryptionUtil {



  static verifyTokenEncode(String str) {
    var content = utf8.encode(str);
    var digest = base64Encode(content);
    var length = digest.length;
    var d = length / 2;
    int middle = d.floor();
    var string_head = digest.substring(0, middle);
    var string_rear = digest.substring(middle, length);
    String total_str = string_rear + string_head;
    return reverseStr(total_str);
  }

  static verifyTokenDecode(String str){
    var reverse_str_token = reverseStr(str);
    var str_len = str.length;
    var middle = str_len / 2;
   var spite_str_head = reverse_str_token.substring(0,middle.toInt());
    var spite_str_rear = reverse_str_token.substring(middle.toInt(),str_len);
    var str_token_now = spite_str_rear + spite_str_head;
    List<int> bytes = base64Decode(str_token_now);
    String result =utf8.decode(bytes);
    return result;
  }

  static String currentTimeMillis() {
    int millisecondsSinceEpoch = new DateTime.now().millisecondsSinceEpoch;
    var content = utf8.encode(millisecondsSinceEpoch.toString().substring(0,10));
    var digest = base64Encode(content);
    return verifyTokenEncode(digest);
  }

  static String reverseStr(String string) {
    StringBuffer stringBuffer=new StringBuffer();
    for (int i = string.length - 1; i >= 0; i--) {
      stringBuffer.write(string[i]);
    }
    print(stringBuffer.toString()+'------------');
    return stringBuffer.toString();
  }
}
