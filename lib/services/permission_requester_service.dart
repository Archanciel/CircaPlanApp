import 'package:permission_handler/permission_handler.dart';

class PermissionRequesterService {
  /// Requires adding the lines below to the main and debug AndroidManifest.xml
  /// files in order to work on S20 - Android 13 !
  ///     <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
  ///     <uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
  ///     <uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>
  static void requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission
          .manageExternalStorage, // Android 11 (API level 30) or higher only
      Permission.microphone,
      Permission.mediaLibrary,
      Permission.speech,
      Permission.audio,
      Permission.videos,
      Permission.notification
    ].request();

    // Vous pouvez maintenant vérifier l'état de chaque permission
    if (!statuses[Permission.storage]!.isGranted ||
        !statuses[Permission.manageExternalStorage]!.isGranted ||
        !statuses[Permission.microphone]!.isGranted ||
        !statuses[Permission.mediaLibrary]!.isGranted ||
        !statuses[Permission.speech]!.isGranted ||
        !statuses[Permission.audio]!.isGranted ||
        !statuses[Permission.videos]!.isGranted ||
        !statuses[Permission.notification]!.isGranted) {
      // Une ou plusieurs permissions n'ont pas été accordées.
      // Vous pouvez désactiver les fonctionnalités correspondantes dans
      // votre application ou montrer une alerte à l'utilisateur.
    } else {
      // Toutes les permissions ont été accordées, vous pouvez continuer avec vos fonctionnalités.
    }
  }
}