
import 'package:get/get.dart';

import '../model/usuario.dart';
import '../service/auth_service.dart';
import '../service/perfil_service.dart';

class PerfilController extends GetxController {
  final PerfilService perfilService = Get.find<PerfilService>();
  final AuthService authService = Get.find<AuthService>();

  final Rxn<Usuario> usuario = Rxn<Usuario>();
  final carregando = false.obs;
  final erro = ''.obs;

  @override
  void onInit() {
    super.onInit();
    carregarPerfil();
  }

  Future<void> carregarPerfil() async {
    carregando.value = true;
    erro.value = '';

    try {
      final token = authService.token.value?.access;

      if (token == null || token.isEmpty) {
        erro.value = 'Sessão expirada. Entre novamente.';
        return;
      }

      final response = await perfilService.obterPerfil(token);

      if (response.isOk && response.body != null) {
        usuario.value = response.body;
      } else {
        erro.value = 'Não foi possível carregar o perfil.';
      }
    } catch (e) {
      erro.value = 'Ocorreu um erro ao carregar o perfil.';
    } finally {
      carregando.value = false;
    }
  }

  Future<bool> atualizarPerfil({
    required String nome,
    required String email,
  }) async {
    final usuarioAtual = usuario.value;
    final token = authService.token.value?.access;

    if (usuarioAtual == null) {
      erro.value = 'Carregue o perfil antes de editá-lo.';
      return false;
    }

    if (token == null || token.isEmpty) {
      erro.value = 'Sessão expirada. Entre novamente.';
      return false;
    }

    carregando.value = true;
    erro.value = '';

    try {
      final dados = Map<String, dynamic>.from(
        usuarioAtual.toJson(),
      );

      dados['nome'] = nome.trim();
      dados['email'] = email.trim();

      final usuarioEditado = Usuario.fromJson(dados);

      final response = await perfilService.atualizarPerfil(
        usuarioEditado,
        token,
      );

      if (response.isOk) {
        usuario.value = usuarioEditado;
        return true;
      }

      erro.value = 'Não foi possível atualizar o perfil.';
      return false;
    } catch (e) {
      erro.value = 'Ocorreu um erro ao atualizar o perfil.';
      return false;
    } finally {
      carregando.value = false;
    }
  }
}
