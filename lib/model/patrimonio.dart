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

  factory Patrimonio.fromJson(Map<String, dynamic> json) {
  return Patrimonio(
    id: json['id'],
    codigo: json['codigo'],
    nome: json['nome'],
    descricao: json['descricao'],
    categoria: json['categoria'],
    marca: json['marca'],
    modelo: json['modelo'],
    numeroSerie: json['numeroSerie'],
    estadoConservacao: json['estadoConservacao'],
    localizacao: json['localizacao'],
    status: json['status'],
    adminId: json['adminId'],
    professorId: json['professorId'],
    observacoes: json['observacoes'],
    createdAt: DateTime.parse(json['createdAt']), //parse converte o datetime para String
    updatedAt: DateTime.parse(json['updatedAt']),
  );
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'codigo': codigo,
    'nome': nome,
    'descricao': descricao,
    'categoria': categoria,
    'marca': marca,
    'modelo': modelo,
    'numeroSerie': numeroSerie,
    'estadoConservacao': estadoConservacao,
    'localizacao': localizacao,
    'status': status,
    'adminId': adminId,
    'professorId': professorId,
    'observacoes': observacoes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}
}

