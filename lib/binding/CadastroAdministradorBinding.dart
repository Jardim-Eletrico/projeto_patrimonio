import 'package:get/get.dart';

import '../controller/login_controler.dart';
import '../controller/usuario_controler.dart';
import '../service/auth_service.dart';
import '../service/usuarios_service.dart';

class CadastroAdministradorBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UsuariosService>()) {
      Get.lazyPut<UsuariosService>(
        () => UsuariosService(
          Get.find<AuthService>(),
        ),
      );
    }

    if (!Get.isRegistered<LoginCongtroler>()) {
      Get.lazyPut<LoginCongtroler>(
        () => LoginCongtroler(
          Get.find<AuthService>(),
          Get.find<UsuariosService>(),
        ),
      );
    }

    if (!Get.isRegistered<UsuarioControler>()) {
      Get.lazyPut<UsuarioControler>(
        () => UsuarioControler(
          Get.find<UsuariosService>(),
          Get.find<AuthService>(),
        ),
      );
    }
  }
}