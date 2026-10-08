import 'package:get/get.dart';
import '../model/metricarusuarios.dart';
import '../model/usuario.dart';

class UsuariosService extends GetConnect {
  String baseurl = "http://localhost:8081";

  Future<Response<List<Usuario>>> listarUsuarios() {
    return get(
      '$baseurl/api/admin/users',
      decoder: (dados) => decoder(dados),
    );
  }

  Future<Response> alterarRole(int id, String role) {
    return patch('$baseurl/api/admin/users/$id/role', {
      'role': role,
    });
  }

  Future<Response<MetricasUsuarios>> obterMetricas() {
    return get(
      '$baseurl/api/admin/users/metrics',
      decoder: (dados) => MetricasUsuarios.fromJson(dados),
    );
  }

  Future<Response<List<Usuario>>> listarProfessores() {
    return get(
      '$baseurl/api/admin/professores',
      decoder: (dados) => decoder(dados),
    );
  }

  Future<Response> cadastrarProfessor(Usuario usuario) {
    return post(
      '$baseurl/api/admin/professores',
      usuario.toJson(),
    );
  }

  
Future<Response> deletarUsuario(int id) {
  return delete(
    '$baseurl/api/admin/users/$id',
  );
}

  Future<Response> buscarProfessor(int id) {
    return get('$baseurl/api/admin/professores/${id.toString()}');
  }

  Future<Response<Usuario>> obterPerfil(String acessToken) {
  return get(
    '$baseurl/api/profile',
    headers: {
      'Authorization' : 'Bearer $acessToken',
    },
    decoder: (dados) => Usuario.fromJson(dados),
  );
}

  Future<Response<Usuario>> atualizarPerfil(
    Usuario usuario,
    String accessToken,
  ) {
    return put(
      '$baseurl/api/profile',
      usuario.toJson(),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      decoder: (dados) => Usuario.fromJson(dados),
    );
  }

  List<Usuario> decoder(dynamic dados){
    return (dados as List) .map((json) => Usuario.fromJson(json)).toList();
  }
}
