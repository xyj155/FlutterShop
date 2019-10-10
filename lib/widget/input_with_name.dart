import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/util/ScreenUtils.dart';

import 'input_text_fied.dart';

typedef void ITextFieldCallBack(String content);

class InputTextWithName extends StatefulWidget {
  final ITextFieldCallBack fieldCallBack;
  final String hint;
  final String name;

  InputTextWithName({
    Key key,
    this.hint,
    this.name,
    this.fieldCallBack,
  }) : super(key: key);

  @override
  _InputTextWithNameState createState() => _InputTextWithNameState();
}

class _InputTextWithNameState extends State<InputTextWithName>
    with SingleTickerProviderStateMixin {
  ScreenUtils screenUtils = new ScreenUtils();

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
    screenUtils.initUtil(context);
    return new Row(
      children: <Widget>[
        new Text(widget.name,style: new TextStyle(color: Colors.black,fontSize: screenUtils.setFontSize(15)),),
        new Container(
          color: Color(0xfff8f8f8),
          alignment: Alignment.center,
          height: screenUtils.setWidgetHeight(55),
          margin: EdgeInsets.only(top: screenUtils.setWidgetHeight(16)),
          child: new ITextField(
              contentHeight: screenUtils.setWidgetHeight(15),
              keyboardType: ITextInputType.number,
              hintText: widget.hint,
              deleteIcon: new Image.asset(
                "assert/imgs/icon_image_delete.png",
                width: screenUtils.setWidgetWidth(18),
                height: screenUtils.setWidgetHeight(55),
              ),
              maxLines: 1,
              textStyle: TextStyle(
                  color: Colors.black, fontSize: screenUtils.setFontSize(15)),
              inputBorder: InputBorder.none,
              fieldCallBack: (content) {
                setState(() {
                  widget.fieldCallBack(content);
                });
              }),
        )
      ],
    );
  }
}
