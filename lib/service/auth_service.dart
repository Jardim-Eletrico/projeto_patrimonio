import '../model/token.dart';
import '../model/usuario.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class AuthService extends GetConnect {
  final token = Rxn<Token>();
  final usuario = Rxn<Usuario>();

  String? get accessToken => token.value?.access;

  bool get ehAdmin => usuario.value?.role == 'admin';

  String baseurl = "http://172.31.80.1:8081";
  Future<Response<Token>> login(String email, String password) async {
  final response = await post(
    "$baseurl/api/auth/login",
    {
      'email': email,
      'password': password,
    },
  );

  debugPrint('Status do login: ${response.statusCode}');

  if (response.isOk && response.body != null) {
    final dados = Token.fromJson(
      Map<String, dynamic>.from(response.body),
    );

    token.value = dados;

    final resposta = response.body;

    if (resposta is Map && resposta['user'] is Map) {
      usuario.value = Usuario.fromJson(
        Map<String, dynamic>.from(resposta['user']),
      );
    }

    return Response<Token>(
      statusCode: response.statusCode,
      statusText: response.statusText,
      body: dados,
    );
  }

  return Response<Token>(
    statusCode: response.statusCode,
    statusText: response.statusText,
  );
}

  Future<Token?> refreshToken(String refreshToken) async {
  final response = await post(
    "$baseurl/api/auth/refresh",
    {
      'refresh': refreshToken,
    },
  );

  if (response.isOk) {
    return Token.fromJson(response.body);
  }

  return null;
}


  Future<bool> logout(String accessToken) async {
  try {
    final response = await post(
      '$baseurl/api/auth/logout',
      {},
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    return response.isOk;
  } catch (e) {
    debugPrint('Erro ao realizar logout na API: $e');
    return false;
  } finally {
    token.value = null;
    usuario.value = null;
  }
}
//=======================================//============================================

Future<Response> forgotPassword(String email) async {
  final response = await post(
    "$baseurl/api/auth/forgot-password",
    {
      "email": email,
    },
  );

  print('Status: ${response.statusCode}');
  print('Resposta: ${response.body}');

  return response;
}

Future<Response> verifyCode(String email, String code) async {
  return await post(
    "$baseurl/api/auth/verify-code",
    {
      "email": email,
      "code": code,
    },
  );
}

Future<Response> resetPassword(
  String email,
  String code,
  String newPassword,
) async {
  return await post(
    "$baseurl/api/auth/reset-password",
    {
      "email": email,
      "code": code,
      "new_password": newPassword,
    },
  );
}
//============================================================
Future<Response> cadastrarCoordenador(
  Usuario usuario,
  String senha,
) {
  return post(
    '$baseurl/api/auth/register',
    {
      'nome': usuario.nome,
      'email': usuario.email,
      'password': senha,
      'cpf': usuario.cpf,
      'telefone': usuario.telefone,
      'departamento': usuario.departamento,
      'role': 'admin',
    },
  );
}
}