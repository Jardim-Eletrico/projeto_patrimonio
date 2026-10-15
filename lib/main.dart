import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projeto_patrimonio/binding/InicialBinding.dart';
import 'package:projeto_patrimonio/binding/LoginBinding.dart';
import 'package:projeto_patrimonio/ui/login_view.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Patrimônio',
      debugShowCheckedModeBanner: false,
      initialBinding: InicialBinding(),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),
      ],
    );
  }
}