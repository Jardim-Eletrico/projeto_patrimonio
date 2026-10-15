import 'package:get/get.dart';
import 'package:projeto_patrimonio/model/token.dart';
import 'package:projeto_patrimonio/model/usuario.dart';
import '../service/auth_service.dart';
import '../service/usuarios_service.dart';



class LoginCongtroler extends GetxController {
  final AuthService authService;
  final UsuariosService usuariosService;
  LoginCongtroler(this.authService, this.usuariosService);

  final carregando = false.obs;
  final erro = ''.obs;

  Future<void> login(String email, String password) async {
    carregando.value = true;
    erro.value = '';

    try{

    final response = await authService.login(email, password);

    if (!response.isOk) {
      erro.value = response.statusCode == null ? 'Sem conexão' : 'Login ou senha inválidos';
      return;
    }

    authService.token.value = response.body;
    final perfil = await usuariosService.obterPerfil(response.body!.access);
    if (perfil.isOk) {
      authService.usuario.value = perfil.body;
      Get.offNamed('/patrimonios');
    } else {
      erro.value = 'Erro ao obter perfil do usuário';
    }
    }
    finally{

    carregando.value = false;
    }
  }

  Future<void> cadastrarAdm(Usuario usuario) async {
    if (authService.usuario.value?.role != 'admin'){
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

//====================================================
  Future<void> esqueceuSenha(String email) async{
    carregando.value = true;

    try{
      final response = await authService.forgotPassword(email);

      if (response.isOk){

      }

    }finally{
      carregando.value = false;
    }
  }

  Future<void> verificarCodigo(String email, String code) async{
    carregando.value = true;

    try{
      final response = await authService.verifyCode(email, code);

      if (response.isOk){

      }
    }finally{
      carregando.value = false;
    }
  }

  Future<void> resetPassword(String email, String code, String newPassword) async{
    carregando.value = true;

    try{
      final response = await authService.resetPassword(email, code, newPassword);

      if (response.isOk){

      }
    }finally{
      carregando.value = false;
    }
  }
}