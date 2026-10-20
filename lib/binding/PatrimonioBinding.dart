import 'package:get/get.dart';
import 'package:projeto_patrimonio/controller/patrimoniocontroller.dart';
import 'package:projeto_patrimonio/service/patrimonio_service.dart';
import 'package:projeto_patrimonio/service/usuarios_service.dart';
import '../service/auth_service.dart';


import 'package:get/get.dart';

import '../controller/patrimoniocontroller.dart';
import '../service/patrimonio_service.dart';
import '../service/auth_service.dart';


import 'package:get/get.dart';

import '../controller/patrimoniocontroller.dart';
import '../service/auth_service.dart';
import '../service/patrimonio_service.dart';
import '../controller/usuario_controler.dart';

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

    Get.lazyPut<Patrimoniocontroller>(
      () => Patrimoniocontroller(
        Get.find<PatrimonioService>(),
        Get.find<AuthService>(),
      ),
    );

    Get.lazyPut<UsuarioControler>(
      () => UsuarioControler(Get.find<UsuariosService>(), Get.find<AuthService>())
    );
  }
}



