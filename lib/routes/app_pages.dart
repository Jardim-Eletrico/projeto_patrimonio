import 'package:get/get.dart';
import 'package:projeto_patrimonio/view/patrimonios/adicionar_patrimonio_page.dart';
import 'package:projeto_patrimonio/view/patrimonios/detalhes_patrimonio_page.dart';
import '../binding/InicialBinding.dart';
import '../binding/LoginBinding.dart';
import '../binding/PatrimonioBinding.dart';
import '../binding/UsuarioBinding.dart';

import '../view/login/login_page.dart';
import '../view/patrimonios/patrimonios_page.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
      ),

    GetPage(
    name: AppRoutes.patrimonios,
    page: () => const PatrimoniosPage(),
    binding: PatrimonioBinding(),
    ),

    GetPage(
      name: '/patrimonios/detalhes',
      page: () => const DetalhesPatrimonioPage(),
      binding: PatrimonioBinding(),
      ),

      GetPage(
        name: '/patrimonio/adicionar',
        page: () => const AdicionarPatrimonioPage(),
        binding: PatrimonioBinding()
        )
  ];
}