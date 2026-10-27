
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/perfil_controler.dart';

class PerfilPage extends GetView<PerfilController> {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu perfil'),
      ),
      body: Obx(() {
        if (controller.carregando.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.erro.value.isNotEmpty &&
            controller.usuario.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    controller.erro.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: controller.carregarPerfil,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        final usuario = controller.usuario.value;

        if (usuario == null) {
          return const Center(
            child: Text('Nenhum dado de perfil disponível.'),
          );
        }

        return _ConteudoPerfil(
          key: ValueKey(usuario.id),
          nome: usuario.nome,
          email: usuario.email,
          role: usuario.role,
        );
      }),
    );
  }
}

class _ConteudoPerfil extends StatefulWidget {
  final String nome;
  final String email;
  final String role;

  const _ConteudoPerfil({
    super.key,
    required this.nome,
    required this.email,
    required this.role,
  });

  @override
  State<_ConteudoPerfil> createState() =>
      _ConteudoPerfilState();
}

class _ConteudoPerfilState extends State<_ConteudoPerfil> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _cpfController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _matriculaController;
  late final TextEditingController _departamentoController;
  late final TextEditingController _cepController;
  late final TextEditingController _enderecoController;
  late final TextEditingController _cidadeUfController;
  late final TextEditingController _contatoEmergenciaController;
  late final TextEditingController _alergiasController;

  DateTime? _dataNascimento;
  String? _genero;
  String? _tipoSanguineo;

  bool _editando = false;

  PerfilController get _perfilController =>
      Get.find<PerfilController>();

  @override
  void initState() {
    super.initState();

    final usuario = _perfilController.usuario.value!;

    _nomeController = TextEditingController(text: usuario.nome);
    _emailController = TextEditingController(text: usuario.email);
    _cpfController = TextEditingController(text: usuario.cpf);
    _telefoneController =
        TextEditingController(text: usuario.telefone);
    _matriculaController =
        TextEditingController(text: usuario.matricula);
    _departamentoController =
        TextEditingController(text: usuario.departamento);
    _cepController =
        TextEditingController(text: usuario.cep ?? '');
    _enderecoController =
        TextEditingController(text: usuario.endereco ?? '');
    _cidadeUfController =
        TextEditingController(text: usuario.cidadeUF ?? '');
    _contatoEmergenciaController = TextEditingController(
      text: usuario.contatoEmergencia ?? '',
    );
    _alergiasController =
        TextEditingController(text: usuario.alergias ?? '');

    _dataNascimento = usuario.dataNascimento;
    _genero = usuario.genero;
    _tipoSanguineo = usuario.tipoSanguineo;
  }

  @override
  void didUpdateWidget(covariant _ConteudoPerfil oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_editando) {
      final usuario = _perfilController.usuario.value;

      if (usuario != null) {
        _nomeController.text = usuario.nome;
        _emailController.text = usuario.email;
        _cpfController.text = usuario.cpf;
        _telefoneController.text = usuario.telefone;
        _matriculaController.text = usuario.matricula;
        _departamentoController.text = usuario.departamento;
        _cepController.text = usuario.cep ?? '';
        _enderecoController.text = usuario.endereco ?? '';
        _cidadeUfController.text = usuario.cidadeUF ?? '';
        _contatoEmergenciaController.text =
            usuario.contatoEmergencia ?? '';
        _alergiasController.text = usuario.alergias ?? '';

        _dataNascimento = usuario.dataNascimento;
        _genero = usuario.genero;
        _tipoSanguineo = usuario.tipoSanguineo;
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _matriculaController.dispose();
    _departamentoController.dispose();
    _cepController.dispose();
    _enderecoController.dispose();
    _cidadeUfController.dispose();
    _contatoEmergenciaController.dispose();
    _alergiasController.dispose();

    super.dispose();
  }

  String _formatarData(DateTime? data) {
    if (data == null) return 'Não informada';

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');

    return '$dia/$mes/${data.year}';
  }

  Future<void> _selecionarDataNascimento() async {
    final hoje = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: hoje,
      helpText: 'Selecione a data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (data != null && mounted) {
      setState(() {
        _dataNascimento = data;
      });
    }
  }

  void _cancelarEdicao() {
    final usuario = _perfilController.usuario.value;

    if (usuario == null) return;

    setState(() {
      _nomeController.text = usuario.nome;
      _emailController.text = usuario.email;
      _cpfController.text = usuario.cpf;
      _telefoneController.text = usuario.telefone;
      _matriculaController.text = usuario.matricula;
      _departamentoController.text = usuario.departamento;
      _cepController.text = usuario.cep ?? '';
      _enderecoController.text = usuario.endereco ?? '';
      _cidadeUfController.text = usuario.cidadeUF ?? '';
      _contatoEmergenciaController.text =
          usuario.contatoEmergencia ?? '';
      _alergiasController.text = usuario.alergias ?? '';

      _dataNascimento = usuario.dataNascimento;
      _genero = usuario.genero;
      _tipoSanguineo = usuario.tipoSanguineo;

      _editando = false;
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final sucesso = await _perfilController.atualizarPerfil(
      nome: _nomeController.text,
      email: _emailController.text,
      cpf: _cpfController.text,
      telefone: _telefoneController.text,
      matricula: _matriculaController.text,
      departamento: _departamentoController.text,
      dataNascimento: _dataNascimento,
      genero: _genero,
      cep: _cepController.text,
      endereco: _enderecoController.text,
      cidadeUF: _cidadeUfController.text,
      contatoEmergencia: _contatoEmergenciaController.text,
      tipoSanguineo: _tipoSanguineo,
      alergias: _alergiasController.text,
    );

    if (!mounted) return;

    if (sucesso) {
      setState(() {
        _editando = false;
      });

      Get.snackbar(
        'Sucesso',
        'Perfil atualizado.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      final mensagem = _perfilController.erro.value;

      Get.snackbar(
        'Erro',
        mensagem.isEmpty
            ? 'Não foi possível atualizar o perfil.'
            : mensagem,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _perfilController.usuario.value;

    if (usuario == null) {
      return const Center(
        child: Text('Nenhum dado de perfil disponível.'),
      );
    }

    final generos = <String>[
      'Masculino',
      'Feminino',
      'Outro',
      'Prefiro não informar',
    ];

    if (_genero != null && !generos.contains(_genero)) {
      generos.add(_genero!);
    }

    final tiposSanguineos = <String>[
      'A+',
      'A-',
      'B+',
      'B-',
      'AB+',
      'AB-',
      'O+',
      'O-',
    ];

    if (_tipoSanguineo != null &&
        !tiposSanguineos.contains(_tipoSanguineo)) {
      tiposSanguineos.add(_tipoSanguineo!);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),
        const Center(
          child: CircleAvatar(
            radius: 48,
            child: Icon(Icons.person, size: 54),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            widget.nome,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),

        if (!_editando) ...[
          _CampoPerfil(
            titulo: 'Nome',
            valor: usuario.nome,
            icone: Icons.badge_outlined,
          ),
          _CampoPerfil(
            titulo: 'E-mail',
            valor: usuario.email,
            icone: Icons.email_outlined,
          ),
          _CampoPerfil(
            titulo: 'Função',
            valor: usuario.role,
            icone: Icons.work_outline,
          ),
          _CampoPerfil(
            titulo: 'CPF',
            valor: usuario.cpf,
            icone: Icons.badge_outlined,
          ),
          _CampoPerfil(
            titulo: 'Telefone',
            valor: usuario.telefone,
            icone: Icons.phone_outlined,
          ),
          _CampoPerfil(
            titulo: 'Matrícula',
            valor: usuario.matricula,
            icone: Icons.assignment_ind_outlined,
          ),
          _CampoPerfil(
            titulo: 'Departamento',
            valor: usuario.departamento,
            icone: Icons.business_outlined,
          ),
          _CampoPerfil(
            titulo: 'Data de nascimento',
            valor: _formatarData(usuario.dataNascimento),
            icone: Icons.calendar_month_outlined,
          ),
          _CampoPerfil(
            titulo: 'Gênero',
            valor: usuario.genero,
            icone: Icons.person_outline,
          ),
          _CampoPerfil(
            titulo: 'CEP',
            valor: usuario.cep,
            icone: Icons.location_on_outlined,
          ),
          _CampoPerfil(
            titulo: 'Endereço',
            valor: usuario.endereco,
            icone: Icons.home_outlined,
          ),
          _CampoPerfil(
            titulo: 'Cidade / UF',
            valor: usuario.cidadeUF,
            icone: Icons.location_city_outlined,
          ),
          _CampoPerfil(
            titulo: 'Contato de emergência',
            valor: usuario.contatoEmergencia,
            icone: Icons.contact_phone_outlined,
          ),
          _CampoPerfil(
            titulo: 'Tipo sanguíneo',
            valor: usuario.tipoSanguineo,
            icone: Icons.bloodtype_outlined,
          ),
          _CampoPerfil(
            titulo: 'Alergias',
            valor: usuario.alergias,
            icone: Icons.medical_information_outlined,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                setState(() {
                  _editando = true;
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar perfil'),
            ),
          ),
        ] else ...[
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu nome.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu e-mail.';
                    }

                    if (!GetUtils.isEmail(valor.trim())) {
                      return 'Informe um e-mail válido.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cpfController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    prefixIcon: Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _matriculaController,
                  decoration: const InputDecoration(
                    labelText: 'Matrícula',
                    prefixIcon:
                        Icon(Icons.assignment_ind_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _departamentoController,
                  decoration: const InputDecoration(
                    labelText: 'Departamento',
                    prefixIcon: Icon(Icons.business_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cepController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CEP',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(
                    labelText: 'Endereço',
                    prefixIcon: Icon(Icons.home_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cidadeUfController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade / UF',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _selecionarDataNascimento,
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: Text(
                    _dataNascimento == null
                        ? 'Selecionar data de nascimento'
                        : 'Nascimento: ${_formatarData(_dataNascimento)}',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _genero,
                  decoration: const InputDecoration(
                    labelText: 'Gênero',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  items: generos.map((genero) {
                    return DropdownMenuItem<String>(
                      value: genero,
                      child: Text(genero),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      _genero = valor;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contatoEmergenciaController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Contato de emergência',
                    prefixIcon:
                        Icon(Icons.contact_phone_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _tipoSanguineo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo sanguíneo',
                    prefixIcon: Icon(Icons.bloodtype_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: tiposSanguineos.map((tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      _tipoSanguineo = valor;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _alergiasController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Alergias',
                    hintText: 'Informe alergias, se houver',
                    prefixIcon: Icon(Icons.medical_information_outlined),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _salvar,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Salvar alterações'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _cancelarEdicao,
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CampoPerfil extends StatelessWidget {
  final String titulo;
  final String? valor;
  final IconData icone;

  const _CampoPerfil({
    required this.titulo,
    required this.valor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    final texto = valor?.trim();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icone),
        title: Text(titulo),
        subtitle: Text(
          texto == null || texto.isEmpty
              ? 'Não informado'
              : texto,
        ),
      ),
    );
  }
}
