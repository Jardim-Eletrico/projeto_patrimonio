import '../model/token.dart';
import '../model/usuario.dart';
import 'package:get/get.dart';

class AuthService extends GetConnect {

  String baseurl = "http://localhost:8081";
  Future<Token?> login(String email, String password) async {
    
    final response = await post(
      "$baseurl/api/auth/login",
      {

        'email':email,
        'password': password,
      });

      if(response.isOk){
        return Token.fromJson(response.body);
      }

      return null;
  }

  Future<Token?> refreshToken(String refreshToken) async {
  final response = await post(
    "$baseUrl/api/auth/refresh",
    {
      'refresh': refreshToken,
    },
  );

  if (response.isOk) {
    return Token.fromJson(response.body);
  }

  return null;
}

Future<Usuario?> register(Map<String, dynamic> dados) async {
  final response = await post(
    "$baseUrl/api/auth/register",
    dados,
  );

  if (response.isOk) {
    return Usuario.fromJson(response.body);
  }

  return null;
}

  Future<bool> logout(String acessToken) async{
    final response = await post("$baseurl/api/auth/logout", {}, headers: {"Authorization": "Bearer $acessToken"},);
    return response.isOk;
  }
}