import 'dart:convert';
import 'dart:io';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sauce_app/util/Base64.dart';

import 'package:platform/platform.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
import 'package:sauce_app/widget/bubble.dart';
import 'package:sauce_app/widget/common_dialog.dart';

class SingleConversationPage extends StatefulWidget {
  final String userId;
  final String username;
  final String avatar;

  SingleConversationPage(
      {Key key,
      @required this.avatar,
      @required this.userId,
      @required this.username})
      : super(key: key);

  @override
  _SingleConversationPageState createState() => _SingleConversationPageState();
}

class _SingleConversationPageState extends State<SingleConversationPage>
    with SingleTickerProviderStateMixin {
  JmessageFlutter jmessage;
  JMSingle kMockUser;
  ScrollController _scrollControoler = new ScrollController();
  bool _loginStatus = false;
  ScreenUtils screenUtils = new ScreenUtils();
  TextEditingController _editingController = new TextEditingController();
  String content = '';
  bool isLoading = false;
  int from = 0; // 记录开始位置
  int limit = 20; //限制
  Future loadUserMsg() async {
    print(widget.username);
    MethodChannel channel = MethodChannel('jmessage_flutter');
    jmessage = new JmessageFlutter.private(channel, LocalPlatform());
    if (jmessage != null) {
      kMockUser = JMSingle.fromJson({
        'username': widget.userId,
      });
      List<dynamic> resultList = await jmessage.getHistoryMessages(
        type: kMockUser,
        from: from,
        limit: limit,
        isDescend: true,
      );

      setState(() {
        _msgList = resultList;
        from = _msgList.length;
        scrollToBottom();
      });
      jmessage.addReceiveMessageListener(_messageListener); // 添加监听
    }
  }

  void _messageListener(dynamic message) {
    print("------------------------------");
    print(message.from.username);
    print("------------------------------");
    if (message is JMTextMessage) {
      JMTextMessage textMessage = message;
      if (textMessage.from.username == widget.userId) {
        jmessage.resetUnreadMessageCount(target: kMockUser);
        if (!mounted) return;
        setState(() {
          _msgList.insert(0, textMessage);
          from = from + 1;
        });
      }
    } else if (message is JMImageMessage) {
      jmessage.resetUnreadMessageCount(target: kMockUser);
      JMImageMessage imageMessage = message;

      if (imageMessage.from.username == widget.userId) {
        if (!mounted) return;
        setState(() {
          _msgList.insert(0, imageMessage);
          from = from + 1;
        });
      }
    } else {
      jmessage.resetUnreadMessageCount(target: kMockUser);
      JMVoiceMessage voiceMessage = message;
      print('接收到录音路径${voiceMessage.path}');
      if (voiceMessage.from.username == widget.userId) {
        if (!mounted) return;
        setState(() {
          _msgList.insert(0, voiceMessage);
          from = from + 1;
        });
      }
    }
  }

  bool isSameMessage({dynamic currentMessage, dynamic previousMessage}) {
    if (currentMessage is JMTextMessage && previousMessage is JMTextMessage) {
      JMTextMessage textMessage = currentMessage;
      JMTextMessage preTextMessage = previousMessage;
      if (textMessage.id == preTextMessage.id) {
        return true;
      } else {
        return false;
      }
    } else if (currentMessage is JMImageMessage &&
        previousMessage is JMImageMessage) {
      JMImageMessage imageMessage = currentMessage;
      JMImageMessage preImageMessage = previousMessage;
      if (imageMessage.id == preImageMessage.id) {
        return true;
      } else {
        return false;
      }
    } else {
      JMVoiceMessage voiceMessage = currentMessage;
      JMVoiceMessage preVoiceMessage = previousMessage;
      if (voiceMessage.id == preVoiceMessage.id) {
        return true;
      } else {
        return false;
      }
    }
  }

  void scrollToBottom() {
    _scrollControoler.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  List<dynamic> _msgList = new List();

  void sendMsg(String msgs) async {
    if (jmessage != null) {
      var msg = await jmessage.sendTextMessage(type: kMockUser, text: msgs);
      var isSend = msg.isSend;
      if (isSend) {
        setState(() {
          _msgList.insert(0, msg);
          from = from + 1;
          _editingController.text = '';
          print(_msgList.length);
          content = "";
        });
        scrollToBottom();
      } else {
        ToastUtil.showCommonToast("发送失败");
      }
    }
  }

  @override
  void initState() {
    getUserStatus(
      "/v1/users/17374131273/userstat",
    );
    loadUserMsg();
    _addListener();

    super.initState();
  }

  _addListener() {
    KeyboardVisibilityNotification().addNewListener(onChange: (bool visible) {
      if (visible) {
        setState(() {
//              _isShowFace = false;
//              _isShowSend = false;
//              _isShowVoice = false;
        });

        try {
          _scrollControoler.position.jumpTo(0);
        } catch (error) {
          print(error);
        }
      }
    });
    _scrollControoler.addListener(() {
      if (_scrollControoler.position.pixels ==
          _scrollControoler.position.maxScrollExtent) {
        _loadMore();
      }
    });
//    jmessage.addReceiveMessageListener(_messageListener);
  }

  @override
  void dispose() {
    super.dispose();
    jmessage.exitConversation(target: kMockUser).catchError((error) {
      ToastUtil.showCommonToast('退出会话失败');
    }).whenComplete(() {
      jmessage.removeReceiveMessageListener(_messageListener); // 移除监听
      print('退出成功了');
    });
//    jmessage.removeReceiveMessageListener(_messageListener);
//    WidgetsBinding.instance.removeObserver(this);
  }

  Future getUserStatus(url, {data, cancelToken}) async {
    BaseOptions options = BaseOptions(
      baseUrl: "https://api.im.jpush.cn",
      connectTimeout: 10000,
      receiveTimeout: 5000,
      headers: {
        "Authorization": "Basic " +
            Base642Text.encodeBase64(
                '653c79d202ad111a7925b9e2:250b8ef0b9d8d8cfc53f1772'),
        "Content-Type": "application/json; charset=utf-8",
      },
      contentType: ContentType.parse("application/json; charset=utf-8"),
      responseType: ResponseType.json,
    );
    Dio dio = Dio(options);
    Response response = await dio.get(url);
    var encode = json.decode(response.toString());
    var userStatus = UserStatus.fromJson(encode);
    setState(() {
      _loginStatus = userStatus.online;
    });
  }

  _loadMore() async {
    if (isLoading) {
      ToastUtil.showCommonToast('正在获取聊天记录中');
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        List<dynamic> temList = await jmessage.getHistoryMessages(
          type: kMockUser,
          from: from,
          limit: limit,
          isDescend: true,
        );

        if (temList.length == 0) {
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            _msgList.addAll(temList);
            from = from + temList.length;
            isLoading = false;
          });
        }
      } catch (error) {
        ToastUtil.showErrorToast('获取失败,请重试');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenUtils.initUtil(context);
    _editingController.addListener(() {
//      print(_editingController.text);
      content = _editingController.text;
    });
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.4,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Container(
              width: screenUtils.setWidgetWidth(40),
              height: screenUtils.setWidgetHeight(40),
              margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: new ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: new Image.network(widget.avatar),
              ),
//              child: CircleAvatar(
//                backgroundImage: ,
//                backgroundColor: Colors.grey[200],
//                minRadius: 30,
//              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.username,
                  style: TextStyle(color: Colors.black),
                ),
                new Row(
                  children: <Widget>[
                    _loginStatus
                        ? new Image.asset(
                            "assert/imgs/ic_online.png",
                            width: screenUtils.setWidgetWidth(10),
                            height: screenUtils.setWidgetHeight(10),
                          )
                        : new Container(),
                    new Container(
                      width: screenUtils.setWidgetWidth(4),
                    ),
                    Text(
                      _loginStatus ? "在线" : "离线",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: screenUtils.setWidgetHeight(75)),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView.builder(
                    itemCount: _msgList.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollControoler,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return setMsgListItemWidget(index, context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey[300],
                  offset: Offset(-2, 0),
                  blurRadius: 5,
                ),
              ]),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      showDialog<Null>(
                          context: context, //BuildContext对象
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return new LoadingDialog();
                          });
                      _getImage();
                    },
                    icon: Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: '说你想说的呗！',
                        border: InputBorder.none,
                      ),
                      controller: _editingController,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (content.isEmpty) {
                        ToastUtil.showCommonToast("你还没有输入文字哦！");
                      } else {
                        sendMsg(content);
                      }
                    },
                    icon: Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget setMsgListItemWidget(int position, BuildContext context) {
    var msgList = _msgList[position];
    if (msgList is JMTextMessage) {
      return msgList.from.username == "765274940"
          ? Bubble(
              message: msgList.text,
              isMe: true,
            )
          : Bubble(
              message: msgList.text,
              isMe: false,
            );
    } else if (msgList is JMImageMessage) {
      return new Hero(
          tag: msgList.serverMessageId == null ? '' : msgList.serverMessageId,
          child: new BubbleImage(
            message: msgList.thumbPath,
            isMe: msgList.from.username == "765274940" ? true : false,
          ));
    }
  }

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var sendImageMessage =
          await jmessage.sendImageMessage(type: kMockUser, path: image.path);
      var isSend = sendImageMessage.isSend;
      if (isSend) {
        setState(() {
          _msgList.insert(0, sendImageMessage);
          from = from + 1;
          Navigator.pop(context);
          print("------------------------------");
          print(_msgList.length);
        });
        scrollToBottom();
      } else {
        Navigator.pop(context);
        ToastUtil.showCommonToast("图片发送失败");
      }
    } else {
      Navigator.pop(context);
    }
  }
}

class UserStatus {
  final bool login;
  final bool online;

  UserStatus({this.login, this.online});

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(login: json['login'], online: json['online']);
  }
}
