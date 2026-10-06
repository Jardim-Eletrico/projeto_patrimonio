import 'package:get/get.dart';
import '../model/usuario.dart';
class UsuariosService extends GetConnect{
  String baseurl = "http://localhost:8081";
  Future<Response<List<Usuario>>> listarUsuarios(){
    return get('$baseurl/api/admin/users', decoder: (dados) => decoder(dados));
  }
Future<Response<List<Usuario>>> listarProfessores()
