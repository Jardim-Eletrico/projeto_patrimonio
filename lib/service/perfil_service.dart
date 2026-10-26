
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../model/usuario.dart';

class PerfilService extends GetConnect {
  final String baseurl = 'http://172.31.80.1:8081';

  @override
  void onInit() {
    httpClient.baseUrl = baseurl;
    super.onInit();
  }

  Future<Response<Usuario>> obterPerfil(String accessToken) async {
    final response = await get<dynamic>(
      '/api/profile',
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
) async {
  final response = await put<dynamic>(
    '/api/profile',
    usuario.toJson(),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  debugPrint('Status da atualização: ${response.statusCode}');
  debugPrint('Resposta da atualização: ${response.body}');

  final dados = response.body;

  if (response.isOk && dados is Map) {
    try {
      final usuarioAtualizado = Usuario.fromJson(
        Map<String, dynamic>.from(dados),
      );

      return Response<Usuario>(
        statusCode: response.statusCode,
        statusText: response.statusText,
        body: usuarioAtualizado,
      );
    } catch (e) {
      debugPrint('Erro ao converter usuário: $e');
    }
  }

  return Response<Usuario>(
    statusCode: response.statusCode,
    statusText: response.statusText,
    body: response.isOk ? usuario : null,
  );
}

  }
