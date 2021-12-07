import 'package:package_info/package_info.dart';

class VersionCheckerService {
  static Future versionCheck({String configAppVersion}) async {
    final PackageInfo info = await PackageInfo.fromPlatform();

    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    double newVersion = double.parse(configAppVersion.replaceAll(".", ""));

    return Future.value({
      'current_version': info.version.trim(),
      'new_version': configAppVersion,
      'update_version': currentVersion < newVersion
    });
  }
}
