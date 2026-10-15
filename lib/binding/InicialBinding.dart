import 'package:get/get.dart';
import '../service/auth_service.dart';

class InicialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService(), permanent: true);
  }
}