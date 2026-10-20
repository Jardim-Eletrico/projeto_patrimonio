
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../model/usuario.dart';
import '../service/auth_service.dart';
import '../service/usuarios_service.dart';

class UsuarioControler extends GetxController {
  final UsuariosService service;
  final AuthService authService;

  UsuarioControler(this.service, this.authService);

  final usuarios = <Usuario>[].obs;
  final carregando = false.obs;
  final usuario = Rxn<Usuario>();

  final carregandoCadastro = false.obs;
  final erroCadastro = ''.obs;

  @override
  void onReady() {
    super.onReady();

    debugPrint('UsuarioControler pronto.');

    if (authService.ehAdmin) {
      listarProfessores();
    }
  }

  

  Future<void> cadastrarProf(Usuario novo) async {
    if (!authService.ehAdmin) {
      debugPrint(
        'Cadastro bloqueado: usuário não é administrador.',
      );
      return;
    }

    carregando.value = true;

    try {
      final response = await service.cadastrarProfessor(novo);

      debugPrint('Cadastro: HTTP ${response.statusCode}');

      if (response.isOk) {
        await listarProfessores();
      } else {
        debugPrint('Erro no cadastro: ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('Erro ao cadastrar professor: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      carregando.value = false;
    }
  }

  Future<void> listarUsuarios() async {
    if (!authService.ehAdmin) {
      debugPrint(
        'Listagem bloqueada: usuário não é administrador.',
      );
      return;
    }

    carregando.value = true;

    try {
      final response = await service.listarUsuarios();

      debugPrint('Usuários: HTTP ${response.statusCode}');

      if (response.isOk && response.body != null) {
        usuarios.assignAll(response.body!);

        debugPrint(
          'Usuários carregados: ${usuarios.length}',
        );
      } else {
        debugPrint(
          'Erro ao listar usuários: ${response.statusText}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Erro ao listar usuários: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      carregando.value = false;
    }
  }

  Future<void> listarProfessores() async {
    if (!authService.ehAdmin) {
      debugPrint(
        'Listagem bloqueada: usuário não é administrador.',
      );
      return;
    }

    final token = authService.accessToken;

    if (token == null || token.isEmpty) {
      debugPrint(
        'Não foi possível listar: token de acesso ausente.',
      );
      return;
    }

    carregando.value = true;

    try {
      final response = await service.listarProfessores(token);

      debugPrint(
        'Professores: HTTP ${response.statusCode}',
      );

      if (response.isOk && response.body != null) {
        usuarios.assignAll(response.body!);

        debugPrint(
          'Professores carregados: ${usuarios.length}',
        );
      } else {
        debugPrint(
          'Erro ao listar professores: ${response.statusText}',
        );
        debugPrint('Resposta: ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('Erro ao listar professores: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      carregando.value = false;
    }
  }

  Future<void> buscarProf(int id) async {
    if (!authService.ehAdmin) {
      debugPrint(
        'Busca bloqueada: usuário não é administrador.',
      );
      return;
    }

    final token = authService.accessToken;

    if (token == null || token.isEmpty) {
      debugPrint(
        'Busca cancelada: token de acesso ausente.',
      );
      return;
    }

    carregando.value = true;
    usuario.value = null;

    try {
      final response = await service.buscarProfessor(
        id,
        token,
      );

      debugPrint(
        'Busca do professor: HTTP ${response.statusCode}',
      );
      debugPrint('Resposta: ${response.body}');
      debugPrint('Erro: ${response.statusText}');

      if (response.isOk && response.body != null) {
        usuario.value = response.body;

        debugPrint(
          'Professor encontrado: ${usuario.value!.nome}',
        );
      } else {
        debugPrint(
          'Erro ao buscar professor: ${response.statusText}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Erro ao buscar professor: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      carregando.value = false;
    }
  }
}
