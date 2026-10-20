import 'package:get/get.dart';
import '../controller/usuario_controler.dart';
import '../service/auth_service.dart';
import '../service/usuarios_service.dart';

class UsuarioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsuarioControler(
          Get.find<UsuariosService>(),
          Get.find<AuthService>(),
        ));
  }
}