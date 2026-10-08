import 'package:get/get.dart';
import 'package:projeto_patrimonio/controller/login_controler.dart';
import 'package:projeto_patrimonio/model/usuario.dart';
import '../service/usuarios_service.dart';

class UsuarioControler extends GetxController {
  final UsuariosService service = UsuariosService();

  final usuarios = <Usuario>[].obs;
  final carregando = false.obs;

  Future<void> cadastrarUsuario(Usuario usuario) async {

    final loginControler = Get.find<LoginCongtroler>(); //ACESSA A INSTÂNCIA DO USUARIO CADASTRADO

    if (loginControler.usuario.value?.role != 'admin'){
      return;
    }

    carregando.value = true;
    try {
      final response = await service.postar(usuario);

      if (response.isOk) {

      }
    } finally {
      carregando.value = false;
    }
  }

  Future<void> deletarUsuario(int id) async{
  }
  }