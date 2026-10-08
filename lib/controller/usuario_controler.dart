import 'package:get/get.dart';
import 'package:projeto_patrimonio/model/usuario.dart';
import '../service/usuarios_service.dart';

class UsuarioControler extends GetxController {
  final UsuariosService service = UsuariosService();

  final usuarios = <Usuario>[].obs;
  final carregando = false.obs;

  Future<void> cadastrarUsuario(Usuario usuario) async {

    if (usuario.role != 'admin'){
      return;
    }

    carregando.value = true;
    try {
      final response = await service.postar(usuario);

      if (response.isOk) {
        // cadastro realizado
      }
    } finally {
      carregando.value = false;
    }
  }
  }