import 'package:get/get.dart';

import '../model/usuario.dart';

class UsuariosService extends GetConnect{
  String baseurl = "http://localhost:8081";

  Future<Response<List<Usuario>>> listarProfessores(){
    return get('$baseurl/api/admin/professores', decoder: (dados) => decoder(dados));
  }

  Future<Response> postar(Usuario usuario){
    return post('$baseurl/api/admin/professores', usuario.toJson());
  }

  Future<Response> buscarProfessor(int id){
      return get('$baseurl/api/admin/professores/${id.toString()}');
    }

  //decoder
  List<Usuario> decoder(dynamic dados){
      return (dados as List) .map((json) => Usuario.fromJson(json)).toList();
    }
}