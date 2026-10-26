
import 'package:get/get.dart';

import '../controller/patrimoniocontroller.dart';
import '../controller/usuario_controler.dart';
import '../service/auth_service.dart';
import '../service/patrimonio_service.dart';
import '../service/usuarios_service.dart';

class PatrimonioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(
      () => AuthService(),
    );

    Get.lazyPut<PatrimonioService>(
      () => PatrimonioService(
        Get.find<AuthService>(),
      ),
    );

    Get.lazyPut<UsuariosService>(
      () => UsuariosService(
        Get.find<AuthService>(),
      ),
    );

    Get.lazyPut<Patrimoniocontroller>(
      () => Patrimoniocontroller(
        Get.find<PatrimonioService>(),
        Get.find<AuthService>(),
      ),
    );

    Get.lazyPut<UsuarioControler>(
      () => UsuarioControler(
        Get.find<UsuariosService>(),
        Get.find<AuthService>(),
      ),
    );
  }
}
