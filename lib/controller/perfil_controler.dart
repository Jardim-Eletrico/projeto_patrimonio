
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
  String? cpf,
  String? telefone,
  String? matricula,
  String? departamento,
  DateTime? dataNascimento,
  String? genero,
  String? cep,
  String? endereco,
  String? cidadeUF,
  String? contatoEmergencia,
  String? tipoSanguineo,
  String? alergias,
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

    if (cpf != null) dados['cpf'] = cpf.trim();
    if (telefone != null) dados['telefone'] = telefone.trim();
    if (matricula != null) dados['matricula'] = matricula.trim();
    if (departamento != null) {
      dados['departamento'] = departamento.trim();
    }
    if (dataNascimento != null) {
      dados['dataNascimento'] =
          dataNascimento.toIso8601String().split('T').first;
    }
    if (genero != null) dados['genero'] = genero;
    if (cep != null) dados['cep'] = cep.trim();
    if (endereco != null) dados['endereco'] = endereco.trim();
    if (cidadeUF != null) dados['cidadeUf'] = cidadeUF.trim();
    if (contatoEmergencia != null) {
      dados['contatoEmergencia'] = contatoEmergencia.trim();
    }
    if (tipoSanguineo != null) {
      dados['tipoSanguineo'] = tipoSanguineo;
    }
    if (alergias != null) dados['alergias'] = alergias.trim();

    final usuarioEditado = Usuario.fromJson(dados);

    final response = await perfilService.atualizarPerfil(
      usuarioEditado,
      token,
    );

    if (response.isOk) {
      usuario.value = response.body ?? usuarioEditado;
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
