import 'package:get/get.dart';

import '../controller/perfil_controler.dart';
import '../service/perfil_service.dart';

class PerfilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerfilService>(
      () => PerfilService(),
    );

    Get.lazyPut<PerfilController>(
      () => PerfilController(),
    );
  }
}
