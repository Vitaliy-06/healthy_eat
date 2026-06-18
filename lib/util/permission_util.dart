import 'package:permission_handler/permission_handler.dart';

abstract class PermissionUtil {

  static Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();

  if (status.isGranted) {
    return true;
  }

  if (status.isDenied) {
    return false;
  }

  if (status.isPermanentlyDenied) {
    await openAppSettings();
    return false;
  }

  return false;
}

}