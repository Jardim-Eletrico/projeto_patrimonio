import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_patrimonio/controller/patrimoniocontroller.dart';

class PatrimoniosPage extends GetView<Patrimoniocontroller> {
  const PatrimoniosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patrimônios'),
        actions: [
          IconButton(
            onPressed: controller.listarPatrimonios,
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.carregando.value &&
            controller.patrimonios.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.erro.value.isNotEmpty &&
            controller.patrimonios.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.erro.value),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.listarPatrimonios,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        if (controller.patrimonios.isEmpty) {
          return const Center(
            child: Text('Nenhum patrimônio encontrado.'),
          );
        }

        return ListView.builder(
          itemCount: controller.patrimonios.length,
          itemBuilder: (context, index) {
            final patrimonio = controller.patrimonios[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(patrimonio.nome),
                subtitle: Text(
                  'Código: ${patrimonio.codigo}\n'
                  'Localização: ${patrimonio.localizacao}\n'
                  'Status: ${patrimonio.status}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        );
      }),
    );
  }
}