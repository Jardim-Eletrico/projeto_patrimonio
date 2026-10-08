import 'package:get/get.dart';
import 'package:projeto_patrimonio/model/usuario.dart';
import 'package:projeto_patrimonio/service/usuarios_service.dart';
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

  Future<void> cadastrarAdm(Usuario usuario) async {

    final loginControler = LoginCongtroler();

    if (loginControler.usuario.value?.role != 'admin'){
      return;
    }

    carregando.value = true;
    try {
      final response = await authService.cadastrarCoordenador(usuario);

      if (response.isOk) {

      }
    } finally {
      carregando.value = false;
    }
  }
}