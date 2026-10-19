import 'package:get/get.dart';
import 'package:projeto_patrimonio/controller/patrimoniocontroller.dart';
import 'package:projeto_patrimonio/service/patrimonio_service.dart';
import '../service/auth_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Patrimoniocontroller(Get.find<PatrimonioService>(), Get.find<AuthService>()));
    
  }
}