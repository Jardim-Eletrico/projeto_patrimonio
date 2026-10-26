
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../model/patrimonio.dart';
import 'auth_service.dart';

class PatrimonioService extends GetConnect {
  final AuthService authService;

  PatrimonioService(this.authService);

  final String baseurl = 'http://172.31.80.1:8081';

  Map<String, String> get headersAutenticados {
    final token = authService.token.value?.access;

    return {
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  Future<Response<List<Patrimonio>>> listarPatrimonios() async {
    debugPrint('========== SERVICE: PATRIMÔNIOS ==========');
    debugPrint('ID do usuário: ${authService.usuario.value?.id}');
    debugPrint('Role: ${authService.usuario.value?.role}');
    debugPrint(
      'Token disponível: ${authService.accessToken != null}',
    );

    final response = await get(
      '$baseurl/api/patrimonios',
      headers: headersAutenticados,
      decoder: (dados) => decoder(dados),
    );

    debugPrint('Status HTTP: ${response.statusCode}');
    debugPrint('Quantidade retornada: ${response.body?.length}');

    return response;
  }

  Future<Response> buscarPatrimonio(int id) {
    return get(
      '$baseurl/api/patrimonios/$id',
      headers: headersAutenticados,
    );
  }

  Future<Response> cadastrarPatrimonio(Patrimonio patrimonio) {
    return post(
      '$baseurl/api/patrimonios',
      patrimonio.toJson(),
      headers: headersAutenticados,
    );
  }

  Future<Response> editarPatrimonio(Patrimonio patrimonio, int id) {
    return put(
      '$baseurl/api/patrimonios/$id',
      patrimonio.toJson(),
      headers: headersAutenticados,
    );
  }

  Future<Response> deletarPatrimonio(int id) {
    return delete(
      '$baseurl/api/patrimonios/$id',
      headers: headersAutenticados,
    );
  }

  Future<Response<List<Patrimonio>>> meusPatrimonios() {
    return get(
      '$baseurl/api/patrimonios/meus',
      headers: headersAutenticados,
      decoder: (dados) => decoder(dados),
    );
  }

  Future<Response> atribuirPatrimonio(
  int patrimonioId,
  int professorId,
) {
  return post(
    '$baseurl/api/admin/patrimonios/$patrimonioId/atribuir',
    {
      'professorId': professorId,
    },
    headers: headersAutenticados,
  );
}

  Future<Response> desatribuirPatrimonio(int patrimonioId) {
    return post(
      '$baseurl/api/admin/patrimonios/$patrimonioId/desatribuir',
      {},
      headers: headersAutenticados,
    );
  }

  List<Patrimonio> decoder(dynamic dados) {
  final items = dados['items'] as List;

  return items.map((json) {
    return Patrimonio.fromJson(
      Map<String, dynamic>.from(json),
    );
  }).toList();
}
}
