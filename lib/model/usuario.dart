class Usuario {
  int? id;
  String email;
  String nome;
  String role;
  String cpf;
  String telefone;
  String matricula;
  String departamento;
  DateTime? dataNascimento;
  String? genero;
  String? cep;
  String? endereco;
  String? cidadeUF;
  String? contatoEmergencia;
  String? tipoSanguineo;
  String? alergias;
  int totalPatrimonios;
  
  Usuario({
    this.id,
    required this.email,
    required this.nome,
    required this.role,
    required this.cpf,
    required this.telefone,
    required this.matricula,
    required this.departamento,
    this.dataNascimento,
    this.genero,
    this.cep,
    this.endereco,
    this.cidadeUF,
    this.contatoEmergencia,
    this.tipoSanguineo,
    this.alergias,
    required this.totalPatrimonios,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      email: json['email'],
      nome: json['nome'],
      role: json['role'],
      cpf: json['cpf'],
      telefone: json['telefone'],
      matricula: json['matricula'],
      departamento: json['departamento'],
      dataNascimento: json['dataNascimento'] != null ? DateTime.parse(json['dataNascimento']) : null,
      genero: json['genero'],
      cep: json['cep'],
      endereco: json['endereco'],
      cidadeUF: json['cidadeUF'],
      contatoEmergencia: json['contatoEmergencia'],
      tipoSanguineo: json['tipoSanguineo'],
      alergias: json['alergias'],
      totalPatrimonios: json['totalPatrimonios'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nome': nome,
      'role': role,
      'cpf': cpf,
      'telefone': telefone,
      'matricula': matricula,
      'departamento': departamento,
      'dataNascimento': dataNascimento?.toIso8601String(), //Converte datetime em String
      'genero': genero,
      'cep': cep,
      'endereco': endereco,
      'cidadeUF': cidadeUF,
      'contatoEmergencia': contatoEmergencia,
      'tipoSanguineo': tipoSanguineo,
      'alergias': alergias,
      'totalPatrimonios': totalPatrimonios,
    };
  }
} 