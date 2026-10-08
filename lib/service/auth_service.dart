import '../model/token.dart';
import '../model/usuario.dart';
import 'package:get/get.dart';

class AuthService extends GetConnect {

  String baseurl = "http://localhost:8081";
  Future<Response<Token>> login(String email, String password) async {
    
    final response = await post(
      "$baseurl/api/auth/login",
      {

        'email':email,
        'password': password,
      });

      if(response.isOk){
        return Response<Token>(statusCode: response.statusCode, body: Token.fromJson(response.body));
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


  Future<bool> logout(String acessToken) async{
    final response = await post("$baseurl/api/auth/logout", {}, headers: {"Authorization": "Bearer $acessToken"},);
    return response.isOk;
  }
//=======================================//============================================

  Future<Response> forgotPassword(String email) async {
  return await post(
    "$baseurl/api/auth/forgot-password",
    {
      "email": email,
    },
  );
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
Future<Response> cadastrarCoordenador(Usuario usuario){
    return post(
      '$baseurl/api/auth/register', usuario.toJson(),
    );
  }
}