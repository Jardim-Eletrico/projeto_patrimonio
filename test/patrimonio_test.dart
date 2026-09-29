import 'package:flutter_test/flutter_test.dart';
import '../lib/model/patrimonio.dart';

void main() {
  test('Deve converter patrimonio JSON para Patrimonio', () {
    final json = {
      "id": 6,
      "codigo": "PAT-2024-006",
      "nome": "Kit Robótica Educacional Arduino",
      "descricao":
          "Kit completo com placa Uno R3, sensores e atuadores para projetos",
      "categoria": "Eletrônicos",
      "marca": "Arduino",
      "modelo": "Starter Kit Maker v3",
      "numeroSerie": "AR-1029",
      "estadoConservacao": "Excelente",
      "localizacao": "Laboratório Maker / Informática",
      "status": "disponivel",
      "adminId": 1,
      "professorId": null,
      "observacoes": "",
      "createdAt": "2026-09-22T16:32:57Z",
      "updatedAt": "2026-09-22T16:32:57Z",
    };

    final patrimonio = Patrimonio.fromJson(json);

    expect(patrimonio.id, 6);
    expect(patrimonio.codigo, "PAT-2024-006");
    expect(patrimonio.nome, "Kit Robótica Educacional Arduino");
    expect(
      patrimonio.descricao,
      "Kit completo com placa Uno R3, sensores e atuadores para projetos",
    );
    expect(patrimonio.categoria, "Eletrônicos");
    expect(patrimonio.marca, "Arduino");
    expect(patrimonio.modelo, "Starter Kit Maker v3");
    expect(patrimonio.numeroSerie, "AR-1029");
    expect(patrimonio.estadoConservacao, "Excelente");
    expect(patrimonio.localizacao, "Laboratório Maker / Informática");
    expect(patrimonio.status, "disponivel");
    expect(patrimonio.adminId, 1);
    expect(patrimonio.professorId, null);
    expect(patrimonio.observacoes, "");
    expect(
      patrimonio.createdAt,
      DateTime.parse("2026-09-22T16:32:57Z"),
    );
    expect(
      patrimonio.updatedAt,
      DateTime.parse("2026-09-22T16:32:57Z"),
    );
  });
}