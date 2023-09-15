import 'package:connectivity/connectivity.dart';

class WifiService {
  static Future<bool> isWifiEnabled() async {
    ConnectivityResult connectivityResult;

    try {
      connectivityResult = await (Connectivity().checkConnectivity());
    } catch (_) { // catching any exeption type
      // the case when running the app on Windows where
      // Connectivity().checkConnectivity() is not supported.
      return false;
    }

    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
