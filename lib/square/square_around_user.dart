import 'package:amap_base/amap_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sauce_app/util/CommonBack.dart';
import 'package:sauce_app/util/ScreenUtils.dart';
import 'package:sauce_app/util/ToastUtil.dart';
class AroundUserPage extends StatefulWidget {
  @override
  _AroundUserPageState createState() => _AroundUserPageState();
}

class _AroundUserPageState extends State<AroundUserPage> with SingleTickerProviderStateMixin {

  double lat;
  double long;
  final _amapLocation = AMapLocation();

  @override
  void initState() {
    initAmapLocation();
    super.initState();
  }

  List<Location> _result = [];

  void initAmapLocation() async {
    if (await Permissions().requestPermission()) {
      final options = LocationClientOptions(
        isOnceLocation: true,
        locatingWithReGeocode: true,
      );
      _amapLocation
          .getLocation(options)
          .then(_result.add)
          .then((_) => setState(() {
        print("-------------------locatiom-------------------");
        lat = _result[0].latitude;
        long = _result[0].longitude;
        print(lat);
        print(long);
        latng = new LatLng( lat,long);
        print("-------------------locatiom-------------------");
      }));
    } else {
      ToastUtil.showErrorToast("权限不足");
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _amapLocation.stopLocate();
    super.dispose();
  }

  var markerList = const [
    LatLng(30.742929,120.710446),
    LatLng(30.742486,120.712849),
    LatLng(30.740568,120.708901),
    LatLng(30.743077,120.708901),
    LatLng(30.742634,120.711218),
  ];
  LatLng latng;
  ScreenUtils screenUtils = new ScreenUtils();
  AMapController _controller;
  @override
  Widget build(BuildContext context) {

    screenUtils.initUtil(context);
    return Scaffold(
      appBar: BackUtil.NavigationBack(context, "校园兼职"),
      body: new Stack(
        children: <Widget>[
          new Container(
            child: latng == null
                ? new CupertinoActivityIndicator()
                : new AMapView(
              onAMapViewCreated: (controller) async {
                _controller = controller;
                _controller.markerClickedEvent.listen((marker) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(marker.toString())));
                });
                controller
                  ..addMarkers(
                    markerList
                        .map((latLng) => MarkerOptions(
                      isGps:true,
                      icon: 'assert/imgs/near_a.png',
                      position: latLng,
                    ))
                        .toList(),
                  );
              },
              amapOptions: AMapOptions(
                compassEnabled: false,
                zoomControlsEnabled: false,
                logoPosition: LOGO_POSITION_BOTTOM_RIGHT,
                camera: CameraPosition(
                  target: latng,
                  zoom: 18,
                ),
              ),
            ),
          ),
          new Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                left: screenUtils.setWidgetWidth(15),
                right: screenUtils.setWidgetWidth(15),
                top: screenUtils.setWidgetHeight(10),
                bottom: screenUtils.setWidgetHeight(10)),
            child: new ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: screenUtils.setWidgetHeight(40),
                color: Color(0xfff7f7f7),
                padding: EdgeInsets.only(
                    left: screenUtils.setWidgetWidth(15),
                    right: screenUtils.setWidgetWidth(15),
                    top: screenUtils.setWidgetHeight(10),
                    bottom: screenUtils.setWidgetHeight(10)),
                child: new Row(
                  children: <Widget>[
                    new Image.asset(
                      "assert/imgs/ic_square_search.png",
                      width: 23,
                      height: 23,
                    ),
                    new Text(
                      "    搜索你想找的工作名称",
                      style: new TextStyle(
                        color: Color(0xffdbdbdb),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
