import 'package:get/get.dart';
import '../controller/login_controler.dart';
import '../service/auth_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginCongtroler(Get.find<AuthService>()));
  }
}