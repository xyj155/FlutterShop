import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtils {
  factory ScreenUtils() => _getInstance();

  static ScreenUtils get instance => _getInstance();
  static ScreenUtils _instance;

  ScreenUtils._internal();

  static ScreenUtils _getInstance() {
    if (_instance == null) {
      _instance = new ScreenUtils._internal();
    }
    return _instance;
  }

  void initUtil(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 375, height: 785,allowFontScaling: true)..init(context);

  }

  setWidgetWidth(int width) {
    return ScreenUtil().setWidth(width.toDouble());
  }

  setWidgetHeight(int height) {
    return ScreenUtil().setHeight(height.toDouble());
  }

  setFontSize(int size) {
    return ScreenUtil().setSp(size.toDouble());
  }
}
