
import 'package:connectivity_plus/connectivity_plus.dart';

/// Checks if the wifi connection is enabled. In this case, when
/// the user starts sleeping, a warning will be displayed since
/// wifi perturbates sleep quality.
class NetworkStateService {
  static Future<bool> isWifiEnabled() async {
    ConnectivityResult connectivityResult;

    try {
      connectivityResult = await (Connectivity().checkConnectivity());
    } catch (_) {
      // catching any exeption type
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

  /// Checks the connectivity status to determine if the
  /// phone is connected.
  ///
  /// Returns [true] if the phone is in connected
  /// to cellular network, and [false] otherwise.
  static Future<bool> isCellularConnectionActive() async {
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await Connectivity().checkConnectivity();
    } catch (e) {
      // Handle any potential errors here
      return false;
    }

    return connectivityResult == ConnectivityResult.mobile;
  }
}
