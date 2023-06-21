import 'package:desktop_window/desktop_window.dart';
import 'package:flowerstore/flowerstore.dart';
import 'package:flutter/material.dart';
import 'package:flowerstore/base/dependency_injector.dart' as di;

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setFullScreen(true);
  await di.inject();

  runApp(FlowerStore());
}
