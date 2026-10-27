
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


Map<String, dynamic>? _extrairUsuario(dynamic dados) {
  if (dados is! Map) return null;

  final usuario = dados['user'];

  if (usuario is Map) {
    return Map<String, dynamic>.from(usuario);
  }

  return Map<String, dynamic>.from(dados);
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

  final dados = _extrairUsuario(response.body);

  if (response.isOk && dados != null) {
    final usuarioAtualizado = Usuario.fromJson(dados);

    return Response<Usuario>(
      statusCode: response.statusCode,
      statusText: response.statusText,
      body: usuarioAtualizado,
    );
  }

  return Response<Usuario>(
    statusCode: response.statusCode,
    statusText: response.statusText,
    body: response.isOk ? usuario : null,
  );
}

  }
