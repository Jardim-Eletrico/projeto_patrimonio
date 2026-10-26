
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/usuario_controler.dart';
import '../../model/usuario.dart';

class GestaoUsuariosPage extends GetView<UsuarioControler> {
  const GestaoUsuariosPage({super.key});

  Future<void> _editarCargo(
    BuildContext context,
    Usuario usuario,
  ) async {
    String novoRole =
        usuario.role == 'admin' ? 'admin' : 'professor';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Alterar cargo'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(usuario.nome),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: novoRole,
                    decoration: const InputDecoration(
                      labelText: 'Cargo',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'admin',
                        child: Text('Administrador'),
                      ),
                      DropdownMenuItem(
                        value: 'professor',
                        child: Text('Professor'),
                      ),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() {
                          novoRole = valor;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () async {
                    Navigator.of(dialogContext).pop();

                    if (novoRole != usuario.role && usuario.id != null) {
                      await controller.alterarCargo(
                        usuario.id!,
                        novoRole,
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _mostrarEstatisticas(
    BuildContext context,
  ) async {
    await controller.carregarEstatisticas();

    final dados = controller.estatisticas.value;

    if (dados == null || !context.mounted) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Estatísticas gerais'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Estatistica(
                titulo: 'Total de usuários',
                valor: dados['totalUsers'],
                icone: Icons.people_outline,
              ),
              _Estatistica(
                titulo: 'Administradores',
                valor: dados['totalAdmins'],
                icone: Icons.admin_panel_settings_outlined,
              ),
              _Estatistica(
                titulo: 'Professores',
                valor: dados['totalProfessores'],
                icone: Icons.school_outlined,
              ),
              _Estatistica(
                titulo: 'Usuários padrão',
                valor: dados['standardUsers'],
                icone: Icons.person_outline,
              ),
              _Estatistica(
                titulo: 'Tokens ativos',
                valor: dados['activeRefreshTokens'],
                icone: Icons.vpn_key_outlined,
              ),
              _Estatistica(
                titulo: 'Códigos de recuperação pendentes',
                valor: dados['pendingResetCodes'],
                icone: Icons.lock_reset,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de usuários'),
        actions: [
          IconButton(
            tooltip: 'Estatísticas gerais',
            onPressed: () => _mostrarEstatisticas(context),
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            tooltip: 'Atualizar lista',
            onPressed: controller.listarUsuarios,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => Row(
                children: [
                  const Icon(Icons.people_outline, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Usuários cadastrados: '
                      '${controller.usuarios.length}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (controller.carregando.value &&
                  controller.usuarios.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.usuarios.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 56,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhum usuário encontrado.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: controller.listarUsuarios,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.listarUsuarios,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.usuarios.length,
                  itemBuilder: (context, index) {
                    final Usuario usuario =
                        controller.usuarios[index];

                    final ehAdmin = usuario.role == 'admin';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onTap: () => _editarCargo(
                          context,
                          usuario,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          child: Icon(
                            ehAdmin
                                ? Icons.admin_panel_settings_outlined
                                : Icons.person_outline,
                          ),
                        ),
                        title: Text(
                          usuario.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(usuario.email),
                              const SizedBox(height: 8),
                              Chip(
                                avatar: Icon(
                                  ehAdmin
                                      ? Icons.shield_outlined
                                      : Icons.school_outlined,
                                  size: 18,
                                ),
                                label: Text(
                                  ehAdmin
                                      ? 'Administrador'
                                      : 'Professor',
                                ),
                                visualDensity:
                                    VisualDensity.compact,
                              ),
                              const Text(
                                'Toque para alterar o cargo',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.edit_outlined,
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Estatistica extends StatelessWidget {
  final String titulo;
  final dynamic valor;
  final IconData icone;

  const _Estatistica({
    required this.titulo,
    required this.valor,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icone),
          const SizedBox(width: 12),
          Expanded(child: Text(titulo)),
          const SizedBox(width: 8),
          Text(
            '${valor ?? 0}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
