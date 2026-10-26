
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

        if (controller.erro.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                  ),
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

  bool _editando = false;

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(
      text: widget.nome,
    );

    _emailController = TextEditingController(
      text: widget.email,
    );
  }

  @override
  void didUpdateWidget(covariant _ConteudoPerfil oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_editando) {
      if (oldWidget.nome != widget.nome) {
        _nomeController.text = widget.nome;
      }

      if (oldWidget.email != widget.email) {
        _emailController.text = widget.email;
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _cancelarEdicao() {
    setState(() {
      _nomeController.text = widget.nome;
      _emailController.text = widget.email;
      _editando = false;
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sucesso = await Get.find<PerfilController>()
        .atualizarPerfil(
      nome: _nomeController.text,
      email: _emailController.text,
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
      final mensagem = Get.find<PerfilController>().erro.value;

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
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 12),
        const Center(
          child: CircleAvatar(
            radius: 48,
            child: Icon(
              Icons.person,
              size: 54,
            ),
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
            valor: widget.nome,
            icone: Icons.badge_outlined,
          ),
          _CampoPerfil(
            titulo: 'E-mail',
            valor: widget.email,
            icone: Icons.email_outlined,
          ),
          _CampoPerfil(
            titulo: 'Função',
            valor: widget.role,
            icone: Icons.work_outline,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                setState(() {
                  _nomeController.text = widget.nome;
                  _emailController.text = widget.email;
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
