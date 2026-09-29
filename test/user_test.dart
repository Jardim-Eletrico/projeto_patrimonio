import 'package:flutter_test/flutter_test.dart';
import '../lib/model/usuario.dart';

void main() {
  test('Deve converter professor JSON para Usuario', () {
    final json = {
      "id": 2,
      "nome": "Prof. Carlos Drummond",
      "email": "professor@escola.com",
      "matricula": "PROF-2024-01",
      "departamento": "Língua Portuguesa e Literatura",
      "telefone": "(11) 98765-1001",
      "cpf": "",
      "role": "professor",
      "adminId": 1,
      "totalPatrimonios": 3,
      "createdAt": "2026-09-22T16:32:56Z"
    };

    final usuario = Usuario.fromJson(json);

    expect(usuario.id, 2);
    expect(usuario.nome, "Prof. Carlos Drummond");
    expect(usuario.email, "professor@escola.com");
    expect(usuario.matricula, "PROF-2024-01");
    expect(usuario.departamento, "Língua Portuguesa e Literatura");
    expect(usuario.telefone, "(11) 98765-1001");
    expect(usuario.cpf, "");
    expect(usuario.role, "professor");
    expect(usuario.totalPatrimonios, 3);
  });
}