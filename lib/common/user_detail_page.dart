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
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0.5,
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: new Container(
        child: new CustomScrollView(
          slivers: <Widget>[

          ],
        ),
      ),
      bottomNavigationBar: new Container(
        child: new Row(
          children: <Widget>[
            new Expanded(child: new Container(
              color: Color(0xff1fb5c6),
              child: new Text("私聊",style:new TextStyle(
                color: Colors.white
              )),
            )),
            new Expanded(child: new Container(
              color: Color(0xff00caa4),
              child: new Text("关注",style:new TextStyle(
                  color: Colors.white
              )),
            )),
          ],
        ),
      ),
    );
  }
}
