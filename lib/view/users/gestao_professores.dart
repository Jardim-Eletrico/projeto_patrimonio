
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/usuario_controler.dart';
import '../../model/usuario.dart';

class GestaoProfessoresPage extends GetView<UsuarioControler> {
  const GestaoProfessoresPage({super.key});

  Future<void> _buscarProfessor(BuildContext context, String texto) async {
    final id = int.tryParse(texto.trim());

    if (id == null || id <= 0) {
      Get.snackbar(
        'ID inválido',
        'Digite um ID numérico válido.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await controller.buscarProf(id);

    final professor = controller.usuario.value;

    if (professor == null || professor.id != id) {
      Get.snackbar(
        'Não encontrado',
        'Não foi possível encontrar o professor com ID $id.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (professor.role != 'professor') {
      Get.snackbar(
        'Registro inválido',
        'O usuário encontrado não é um professor.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!context.mounted) return;

    _mostrarDetalhes(professor);
  }

  void _mostrarDetalhes(Usuario professor) {
    Get.dialog(
      AlertDialog(
        title: Text(professor.nome),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${professor.id ?? "-"}'),
              Text('E-mail: ${professor.email}'),
              Text('CPF: ${professor.cpf}'),
              Text('Telefone: ${professor.telefone}'),
              Text('Matrícula: ${professor.matricula}'),
              Text('Departamento: ${professor.departamento}'),
              Text(
                'Patrimônios: ${professor.totalPatrimonios ?? 0}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campoId = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Professores'),
        actions: [
          IconButton(
            onPressed: controller.listarProfessores,
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar lista',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: campoId,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Buscar professor por ID',
                hintText: 'Digite o ID do professor',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Pesquisar',
                  onPressed: () => _buscarProfessor(
                    context,
                    campoId.text,
                  ),
                ),
              ),
              onSubmitted: (texto) => _buscarProfessor(
                context,
                texto,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Professores cadastrados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.carregando.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List<Usuario> professores = controller.usuarios
                  .where((usuario) => usuario.role == 'professor')
                  .toList();

              if (professores.isEmpty) {
                return const Center(
                  child: Text('Nenhum professor encontrado.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: professores.length,
                itemBuilder: (context, index) {
                  final professor = professores[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.school_outlined),
                      ),
                      title: Text(professor.nome),
                      subtitle: Text(
                        '${professor.email}\n'
                        'Matrícula: ${professor.matricula}\n'
                        'Departamento: ${professor.departamento}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _mostrarDetalhes(professor),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
