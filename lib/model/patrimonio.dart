class Patrimonio {
  int? id;
  String codigo;
  String nome;
  String descricao;
  String categoria;
  String marca;
  String modelo;
  String numeroSerie;
  String estadoConservacao;
  String localizacao;
  String status;
  int? adminId;
  String? professorId;
  String? observacoes;
  DateTime createdAt;
  DateTime updatedAt;

  Patrimonio({
    this.id,
    required this.codigo,
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.marca,
    required this.modelo,
    required this.numeroSerie,
    required this.estadoConservacao,
    required this.localizacao,
    required this.status,
    this.adminId,
    this.professorId,
    this.observacoes,
    required this.createdAt,
    required this.updatedAt,
  });
}