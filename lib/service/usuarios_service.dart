
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'auth_service.dart';

import '../model/usuario.dart';

class UsuariosService extends GetConnect {
  final AuthService authService;

  UsuariosService(this.authService);

  final String baseurl = 'http://172.31.80.1:8081';

  Future<Response<List<Usuario>>> listarUsuarios(String accessToken) {
  return get<List<Usuario>>(
    '$baseurl/api/admin/users',
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
    decoder: (dados) {
      List<dynamic>? lista;

      if (dados is List) {
        lista = dados;
      } else if (dados is Map && dados['users'] is List) {
        lista = dados['users'] as List;
      }

      if (lista == null) {
        throw const FormatException(
          'A resposta não contém uma lista de usuários válida.',
        );
      }

      return lista.map((json) {
        return Usuario.fromJson(
          Map<String, dynamic>.from(json as Map),
        );
      }).toList();
    },
  );
}


Future<Response> alterarRole(
  int id,
  String role,
  String accessToken,
) {
  return patch(
    '$baseurl/api/admin/users/$id/role',
    {'role': role},
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );
}

Future<Response<Map<String, dynamic>>> obterEstatisticas(
  String accessToken,
) {
  return get<Map<String, dynamic>>(
    '$baseurl/api/admin/stats',
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
    decoder: (dados) =>
        Map<String, dynamic>.from(dados as Map),
  );
}


  Future<Response<List<Usuario>>> listarProfessores(
    String accessToken,
  ) async {
    final resposta = await get<dynamic>(
      '$baseurl/api/admin/professores',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      decoder: (dados) => dados,
    );

    final dados = resposta.body;

    debugPrint('HTTP professores: ${resposta.statusCode}');
    debugPrint('JSON recebido: $dados');

    if (!resposta.isOk) {
      return Response<List<Usuario>>(
        statusCode: resposta.statusCode,
        statusText: resposta.statusText,
      );
    }

    if (dados is! Map || dados['professores'] is! List) {
      debugPrint('Formato inesperado na resposta de professores.');

      return Response<List<Usuario>>(
        statusCode: resposta.statusCode,
        statusText: 'Formato inesperado na resposta da API.',
      );
    }

    final lista = dados['professores'] as List;

    final professores = lista.map((item) {
      return Usuario.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();

    debugPrint('Quantidade de professores: ${professores.length}');

    return Response<List<Usuario>>(
      statusCode: resposta.statusCode,
      statusText: resposta.statusText,
      body: professores,
    );
  }

  Future<Response> cadastrarProfessor(
  Usuario usuario,
  String senha,
) {
  final dados = {
    ...usuario.toJson(),
    'password': senha,
  };

  final token = authService.accessToken;

  return post(
    '$baseurl/api/admin/professores',
    dados,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
}

  Future<Response> deletarUsuario(int id) {
    return delete('$baseurl/api/admin/users/$id');
  }

  
Future<Response<Usuario>> buscarProfessor(
  int id,
  String token,
) async {
  final response = await get<dynamic>(
    '$baseurl/api/admin/professores/$id',
    headers: {
      'Authorization': 'Bearer $token',
    },
    decoder: (dados) => dados,
  );

  debugPrint('Busca por ID: HTTP ${response.statusCode}');
  debugPrint('Resposta da busca: ${response.body}');
  debugPrint('Erro da busca: ${response.statusText}');

  if (!response.isOk || response.body == null) {
    return Response<Usuario>(
      statusCode: response.statusCode,
      statusText: response.statusText,
    );
  }

  final dados = response.body;

  if (dados is! Map) {
    debugPrint('Formato inesperado na resposta da busca.');

    return Response<Usuario>(
      statusCode: response.statusCode,
      statusText: 'Formato inesperado na resposta.',
    );
  }

  final json = Map<String, dynamic>.from(dados);
  final professor = json['professor'] ?? json;

  if (professor is! Map) {
    return Response<Usuario>(
      statusCode: response.statusCode,
      statusText: 'Professor não encontrado na resposta.',
    );
  }

  return Response<Usuario>(
    statusCode: response.statusCode,
    statusText: response.statusText,
    body: Usuario.fromJson(
      Map<String, dynamic>.from(professor),
    ),
  );
}


  Future<Response<Usuario>> obterPerfil(String accessToken) async {
    final response = await get<dynamic>(
      '$baseurl/api/profile',
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      decoder: (dados) => dados,
    );

    debugPrint('Status do perfil: ${response.statusCode}');
    debugPrint('Resposta do perfil: ${response.body}');

    final dados = response.body;

    if (response.isOk && dados is Map) {
      final usuario = Usuario.fromJson(
        Map<String, dynamic>.from(dados),
      );

      return Response<Usuario>(
        statusCode: response.statusCode,
        statusText: response.statusText,
        body: usuario,
      );
    }

    return Response<Usuario>(
      statusCode: response.statusCode,
      statusText: response.statusText,
    );
  }

  Future<Response<Usuario>> atualizarPerfil(
    Usuario usuario,
    String accessToken,
  ) {
    return put<Usuario>(
      '$baseurl/api/profile',
      usuario.toJson(),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      decoder: (dados) => Usuario.fromJson(dados),
    );
  }
}
