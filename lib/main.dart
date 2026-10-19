import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

import 'binding/InicialBinding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {
  DevicePreview.enable(enabled: !kReleaseMode);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}