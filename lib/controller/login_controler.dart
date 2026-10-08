import 'package:get/get.dart';
import 'package:projeto_patrimonio/model/usuario.dart';
import '../service/auth_service.dart';

class LoginCongtroler extends GetxController {
  final AuthService authService = AuthService();

  final carregando = false.obs;
  final erro = ''.obs;

  final usuario = Rxn<Usuario>();

  Future<void> login(String email, String password) async {
    carregando.value = true;
    erro.value = '';

    try{

    final response = await authService.login(email, password);

    if (response.isOk) {
      final token = response.body!;

      print(token.access);
      print(token.refresh);

    } else {
      erro.value = "Login ou senha inválidos";
    }
    }
    finally{

    carregando.value = false;
    }
  }
}