import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef InputCompleteCallback(String content);

class CellInput extends StatefulWidget {
  int cellCount = 6;
  InputType inputType = InputType.number;
  InputCompleteCallback inputCompleteCallback;
  bool autofocus = true;
  BorderRadiusGeometry borderRadius;
  Color solidColor;
  Color strokeColor;
  Color textColor;
  double fontSize;

  CellInput(
      {Key key,
        this.cellCount = 6,
        this.inputType,
        this.autofocus = true,
        this.inputCompleteCallback,
        this.borderRadius,
        this.solidColor,
        this.strokeColor = Colors.blue,
        this.textColor,
        this.fontSize = 43})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CellInputState(
        cellCount,
        inputType,
        autofocus,
        inputCompleteCallback,
        borderRadius,
        solidColor,
        strokeColor,
        textColor,
        fontSize);
  }
}

enum InputType {
  password,
  number,
  text,
}

class _CellInputState extends State<CellInput> {
  String inputStr = "";
  int _cellCount = 6;
  InputType _inputType = InputType.number;
  InputCompleteCallback _inputCompleteCallback;
  bool _autofocus = true;
  BorderRadiusGeometry _borderRadius;
  Color _solidColor;
  Color _strokeColor;
  Color _textColor;
  double _fontSize;

  _CellInputState(
      this._cellCount,
      this._inputType,
      this._autofocus,
      this._inputCompleteCallback,
      this._borderRadius,
      this._solidColor,
      this._strokeColor,
      this._textColor,
      this._fontSize);

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 98,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getCells(),
          ),
          Container(
            height: 98,
            width: double.infinity,
            child: TextField(
              keyboardType: _keyboardType(),
              inputFormatters: [LengthLimitingTextInputFormatter(_cellCount)],
              decoration:InputDecoration(
                border: InputBorder.none,
              ),
              cursorWidth: 0,
              style: TextStyle(color: Colors.transparent),
              controller: _controller,
              autofocus: _autofocus,
              onChanged: (v) {
                setState(() {
                  inputStr = v;
                  if (v.length == _cellCount) {
                    if (_inputCompleteCallback != null) {
                      _inputCompleteCallback(v);
                    }
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  String getIndexStr(int index) {
    if (inputStr == null || inputStr.isEmpty) return "";
    if (inputStr.length > index) {
      if (_inputType == InputType.password) {
        return "●";
      } else {
        return inputStr[index];
      }
    } else {
      return "";
    }
  }

  TextInputType _keyboardType() {
    if (_inputType == InputType.number) {
      return TextInputType.number;
    } else if (_inputType == InputType.password) {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }

  List<Widget> getCells() {
    var cells = <Widget>[];
    for (var i = 0; i < _cellCount; i++) {
      cells.add(Expanded(
        flex: 1,
        child: Center(
          child: Container(
            width: 78,
            height: 78,
            margin: EdgeInsets.only(left: 2, right: 2),
            alignment: Alignment.center,
            child: Text(
              getIndexStr(i),
              style: TextStyle(
                decoration:TextDecoration.none,
                  decorationColor: Colors.transparent,
                  fontSize: _fontSize,
                  color: _textColor,
                  fontWeight: FontWeight.w600),
            ),
            decoration: BoxDecoration(
              color: Color(0xff171717),
                borderRadius: _borderRadius),
          ),
        ),
      ));
    }

    return cells;
  }

  Color getBoarderColor(int index) {
    if (inputStr == null || inputStr.isEmpty) {
      if (index == 0) {
        return _strokeColor;
      } else {
        return _solidColor;
      }
    } else {
      if (index == inputStr.length) {
        return _strokeColor;
      } else {
        return _solidColor;
      }
    }
  }
}