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
    id: json['id'] as int?,
    codigo: json['codigo'] as String,
    nome: json['nome'] as String,
    descricao: json['descricao'] as String,
    categoria: json['categoria'] as String,
    marca: json['marca'] as String,
    modelo: json['modelo'] as String,
    numeroSerie: json['numeroSerie'] as String,
    estadoConservacao: json['estadoConservacao'] as String,
    localizacao: json['localizacao'] as String,
    status: json['status'] as String,
    adminId: json['adminId'] as int?,
    professorId: json['professorId']?.toString(),
    observacoes: json['observacoes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
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

