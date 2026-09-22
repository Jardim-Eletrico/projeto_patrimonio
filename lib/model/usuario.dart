class Usuario {
  int? id;
  String email;
  String nome;
  bool role;
  String cpf;
  String telefone;
  String matricula;
  String departamento;
  DateTime dataNascimento;
  String genero;
  String cep;
  String endereco;
  String cidadeUF;
  String contatoEmergencia;
  String tipoSanguineo;
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
    required this.dataNascimento,
    required this.genero,
    required this.cep,
    required this.endereco,
    required this.cidadeUF,
    required this.contatoEmergencia,
    required this.tipoSanguineo,
    this.alergias,
    required this.totalPatrimonios,
  });
}