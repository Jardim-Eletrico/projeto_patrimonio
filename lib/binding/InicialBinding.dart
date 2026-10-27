
import 'package:get/get.dart';

import '../service/auth_service.dart';
import '../service/usuarios_service.dart';
import '../service/patrimonio_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(
        AuthService(),
        permanent: true,
      );
    }

  if (!Get.isRegistered<UsuariosService>()) {
  Get.put<UsuariosService>(
    UsuariosService(Get.find<AuthService>()),
    permanent: true,
  );
}

    if (!Get.isRegistered<PatrimonioService>()) {
      Get.lazyPut<PatrimonioService>(
        () => PatrimonioService(Get.find<AuthService>()),
        fenix: true,
      );
    }
  }
}
