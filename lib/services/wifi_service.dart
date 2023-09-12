import 'package:connectivity/connectivity.dart';

class WifiService {
  static Future<bool> isWifiEnabled() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
