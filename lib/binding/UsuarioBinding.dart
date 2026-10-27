
import 'package:get/get.dart';

import '../controller/usuario_controler.dart';
import '../service/auth_service.dart';
import '../service/usuarios_service.dart';

class UsuarioBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<UsuariosService>()) {
      Get.lazyPut<UsuariosService>(
        () => UsuariosService(
          Get.find<AuthService>(),
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
