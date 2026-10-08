import 'package:get/get.dart';
import '../service/auth_service.dart';

class LoginCongtroler extends GetxController {
  final AuthService authService = AuthService();

  final carregando = false.obs;
  final erro = ''.obs;

  Future<void> login(String email, String password) async {
    carregando.value = true;
    erro.value = '';

    final response = await authService.login(email, password);

    if (response.isOk) {
      final token = response.body!;

      print(token.access);
      print(token.refresh);

    } else {
      erro.value = "Login ou senha inválidos";
    }

    carregando.value = false;

  }
}