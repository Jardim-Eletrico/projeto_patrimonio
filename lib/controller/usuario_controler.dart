import 'package:get/get.dart';
import 'package:projeto_patrimonio/model/usuario.dart';
import '../service/usuarios_service.dart';
import '../service/auth_service.dart';

class UsuarioControler extends GetxController {
  final UsuariosService service;
  final AuthService authService;
  UsuarioControler(this.service, this.authService);

  final usuarios = <Usuario>[].obs;
  final carregando = false.obs;
  final usuario = Rxn<Usuario>();

  Future<void> cadastrarProf(Usuario novo) async {
    if (!authService.ehAdmin) return;

    carregando.value = true;
    try {
      final response = await service.cadastrarProfessor(novo);

      if (response.isOk) {
        await listarProfessores();
      }
    } finally {
      carregando.value = false;
    }
  }

//=====================================================
  Future<void> listarUsuarios() async {
    if (!authService.ehAdmin) return;

    carregando.value = true;
    try {
      final response = await service.listarUsuarios();

      if (response.isOk) {
        usuarios.assignAll(response.body ?? []);
      }
    } finally {
      carregando.value = false;
    }
  }

  Future<void> listarProfessores() async {
    if (!authService.ehAdmin) return;

    carregando.value = true;
    try {
      final response = await service.listarProfessores();

      if (response.isOk) {
        usuarios.assignAll(response.body ?? []);
      }
    } finally {
      carregando.value = false;
    }
  }

  Future<void> buscarProf(int id) async {
    if (!authService.ehAdmin) return;

    carregando.value = true;
    try {
      final response = await service.buscarProfessor(id);

      if (response.isOk && response.body != null) {
        usuario.value = response.body;
      }
    } finally {
      carregando.value = false;
    }
  }
}