import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flowerstore/base/flowerstore_info.dart';
import 'package:flowerstore/flowerstore.dart';
import 'package:flutter/material.dart';
import 'package:flowerstore/base/dependency_injector.dart' as di;
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  // MARK: Ensure Initialized Widgets
  await WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isMacOS && Platform.isLinux) {
    await DesktopWindow.setFullScreen(true);
  }

  // MARK: Inject Dependencies
  await di.inject();
  // MARK: Initialize Thai Date
  await initializeDateFormatting('th_TH', null);
  runApp(FlowerStore(version: FlowerStoreInfo.currentVersion,));
}
