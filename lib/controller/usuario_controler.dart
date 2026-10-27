
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../model/usuario.dart';
import '../service/auth_service.dart';
import '../service/usuarios_service.dart';

class UsuarioControler extends GetxController {
  final UsuariosService service;
  final AuthService authService;
  
  final estatisticas = Rxn<Map<String, dynamic>>();
  final carregandoEstatisticas = false.obs;
  final alterandoCargo = false.obs;

  UsuarioControler(this.service, this.authService);

  final usuarios = <Usuario>[].obs;
  final carregando = false.obs;
  final usuario = Rxn<Usuario>();

  final carregandoCadastro = false.obs;
  final erroCadastro = ''.obs;

  @override
  void onReady() {
  super.onReady();

  if (!authService.ehAdmin) return;

  if (Get.currentRoute == '/usuarios') {
    listarUsuarios();
  } else if (Get.currentRoute == '/professores') {
    listarProfessores();
  }
}

  Future<void> cadastrarProf(Usuario novo, String senha,) async {
    if (!authService.ehAdmin) {
      debugPrint(
        'Cadastro bloqueado: usuário não é administrador.',
      );
      return;
    }

    carregando.value = true;

    try {
      final response = await service.cadastrarProfessor(novo, senha,);

      debugPrint('Cadastro: HTTP ${response.statusCode}');

      if (response.isOk) {
              Get.snackbar(
          'Sucesso',
          'Professor cadastrado com sucesso!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
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
      final token = authService.token.value?.access;
      
      if (token == null || token.isEmpty) {
      debugPrint('Sessão expirada. Entre novamente.');
      return;
    }
      final response = await service.listarUsuarios(token);

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

  Future<void> carregarEstatisticas() async {
  carregandoEstatisticas.value = true;

  try {
    final token = authService.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final response = await service.obterEstatisticas(token);

    if (response.isOk && response.body != null) {
      estatisticas.value = response.body;
    } else {
      Get.snackbar(
        'Erro',
        'Não foi possível carregar as estatísticas.',
      );
    }
  } catch (e) {
    Get.snackbar('Erro', 'Falha ao carregar estatísticas: $e');
  } finally {
    carregandoEstatisticas.value = false;
  }
}

Future<void> alterarCargo(int id, String novoRole) async {
  if (novoRole != 'admin' && novoRole != 'professor') {
    Get.snackbar('Erro', 'Cargo inválido.');
    return;
  }

  alterandoCargo.value = true;

  try {
    final token = authService.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception('Token de autenticação não encontrado.');
    }

    final response = await service.alterarRole(
      id,
      novoRole,
      token,
    );

    if (response.isOk) {
      Get.snackbar(
        'Sucesso',
        'Cargo atualizado com sucesso.',
      );

      await listarUsuarios();
    } else {
      Get.snackbar(
        'Erro',
        'Não foi possível alterar o cargo.',
      );
    }
  } catch (e) {
    Get.snackbar('Erro', 'Falha ao alterar cargo: $e');
  } finally {
    alterandoCargo.value = false;
  }
}
}
