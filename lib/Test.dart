import 'package:flutter/material.dart';

class ImageStackPage extends StatelessWidget {
  final double sizeW = 50.0;
  final double offsetW = 20.0;

  int _getSpaceStackFlex(BuildContext context, int imageNumber) {
    int maxNum = (MediaQuery.of(context).size.width - 16).toInt();
    int num = (offsetW * (imageNumber - 1) + sizeW).toInt();
    return maxNum - num + 1;
  }

  int _getImageStackFlex(BuildContext context, int imageNumber) {
    int num = (offsetW * (imageNumber - 1) + sizeW).toInt();
    return num;
  }

  double _getImageStackWidth(int imageNumber) {
    return offsetW * (imageNumber - 1) + sizeW;
  }

  List<Widget> _getStackItems(int count) {
    List<Widget> _list = new List<Widget>();
    for (var i = 0; i < count; i++) {
      double off = 20.0 * i;
      _list.add(Positioned(
        left: off,
        child: CircleAvatar(
          child: Image(
            image: AssetImage("assert/imgs/message_chat.png.png"),
            width: sizeW,
            height: sizeW,
          ),
        ),
      ));
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('头像堆叠'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: 40,
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: _getImageStackWidth(8),
                      height: double.infinity,
                      child: Stack(
                        children: _getStackItems(8),
                      ),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                )),
            Container(
                height: 40,
                child: Container(
                  color: Colors.teal,
                  child: Stack(
                    children: _getStackItems(8),
                  ),
                )),
            Container(
                color: Colors.grey,
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      flex: _getSpaceStackFlex(context, 8),
                      child: Container(
                        color: Colors.yellow,
                        height: 40,
                      ),
                    ),
                    Expanded(
                      flex: _getImageStackFlex(context, 8),
                      child: Container(
                        color: Colors.red,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: <Widget>[
                            CircleAvatar(
                              child: Image(
                                image: AssetImage("assert/imgs/message_chat.png"),
                                width: sizeW,
                                height: sizeW,
                              ),
                            ),
                            Positioned(
                              right: 20,
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage("assert/imgs/message_chat.png.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 40,
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage("assert/imgs/message_chat.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 60,
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage("assert/imgs/message_chat.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 80,
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage("assert/imgs/message_chat.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 100,
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage("assert/imgs/message_chat.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 120,
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage("assert/imgs/message_chat.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 140,
                              child: CircleAvatar(
                                child: Image(
                                  image: AssetImage("assert/imgs/message_chat.png"),
                                  width: sizeW,
                                  height: sizeW,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
