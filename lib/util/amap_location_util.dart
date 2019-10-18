import 'package:amap_location/amap_location.dart';

class AmapUtil {
  static void startLocation(Function function) async {
    AMapLocation location;
    await AMapLocationClient.startup(new AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
    await AMapLocationClient.getLocation(true);

    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) {
      location = loc;
//      location.city
//      location.longitude
//      location.latitude
//      location.
      function(loc);
    });
    AMapLocationClient.startLocation();
//    return location==null?new AMapLocation():location;
  }
}
