import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:platform/platform.dart';

class SingleConversationPage extends StatefulWidget {
  final String userId;
  final String username;

  SingleConversationPage(
      {Key key, @required this.userId, @required this.username})
      : super(key: key);

  @override
  _SingleConversationPageState createState() => _SingleConversationPageState();
}

class _SingleConversationPageState extends State<SingleConversationPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List> initMessageList() async {
    MethodChannel channel = MethodChannel('jmessage_flutter');
    JmessageFlutter jmessage =
    new JmessageFlutter.private(channel, LocalPlatform());
    jmessage.login(username: "17374131273", password: "xuyijie19971016");
    final JMSingle kMockUser = JMSingle.fromJson({
      'username': "xuyijie",
    });
    JMConversationInfo conversation =
    await jmessage.createConversation(target: kMockUser);
    var initMessageList2 = initMessageList();
    List _messageList = new List();
    initMessageList2.then(_messageList.add).then((_) =>
        setState(() {
          _messageListAll.addAll(_messageList);
        }));
  }

  List _messageListAll = new List();

  @override
  Widget build(BuildContext context) {
    initMessageList();
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, widget.username),
      body: new Container(
        child: new Column( //Column使消息记录和消息输入框垂直排列
            children: <Widget>[
              new Flexible(
                //子控件可柔性填充，如果下方弹出输入框，使消息记录列表可适当缩小高度
                  child: new ListView.builder(
                    //可滚动显示的消息列表
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    //反转排序，列表信息从下至上排列
                    itemBuilder: (_, int index) => _messageListAll[index],
                    //插入聊天信息控件
                    itemCount: _messageListAll.length,
                  )),
              new Divider(height: 1.0), //聊天记录和输入框之间的分隔
              new Container(
                decoration: new BoxDecoration(color: Theme
                    .of(context)
                    .cardColor),
                child: _buildTextComposer(), //页面下方的文本输入控件
              ),
            ]),
      ),
    );
//  }

//  void _handleSubmitted(String text) {
//    _textController.clear();
//    setState(() {                                                    //new  你们懂的
//      _isComposing = false;                                          //new  重置_isComposing 值
//    });                                                              //new
//    ChatMessage message = new ChatMessage(
//      text: text,
//      animationController: new AnimationController(
//        duration: new Duration(milliseconds: 700),
//        vsync: this,
//      ),
//    );
//    setState(() {
//      _messages.insert(0, message);
//    });
//    message.animationController.forward();
//  }
  }

  TextEditingController _textController = new TextEditingController();

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme
          .of(context)
          .accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (
                    String text) { //new  通过onChanged事件更新_isComposing 标志位的值
                  setState(() { //new  调用setState函数重新渲染受到_isComposing变量影响的IconButton控件
//                    _isComposing =
//                        text.length > 0; //new  如果文本输入框中的字符串长度大于0则允许发送消息
                  }); //new
                }, //new
//                onSubmitted:,
                decoration:
                new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
//              child: new IconButton(
//                icon: new Icon(Icons.send),
//                onPressed: _isComposing
//                    ? () => _handleSubmitted(_textController.text) //modified
//                    : null, //modified  当没有为onPressed绑定处理函数时，IconButton默认为禁用状态
//              ),
            ),
          ],
        ),
      ),
    );
  }
}
