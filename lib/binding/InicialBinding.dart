import 'package:get/get.dart';
import '../service/auth_service.dart';
import '../service/usuarios_service.dart';
import '../service/patrimonio_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);

    Get.lazyPut(() => UsuariosService(Get.find<AuthService>()), fenix: true);
    Get.lazyPut<PatrimonioService>(
  () => PatrimonioService(Get.find<AuthService>()),
  fenix: true,
);
  }
}