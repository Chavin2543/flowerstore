import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

class FlowerStoreInfo {
  static String currentVersion = "1.0.3";
}

String get platformExt {
  switch (Platform.operatingSystem) {
    case 'windows':
      {
        return 'exe';
      }

    case 'macos':
      {
        return 'dmg';
      }

    case 'linux':
      {
        return 'AppImage';
      }
    default:
      {
        return 'zip';
      }
  }
}
