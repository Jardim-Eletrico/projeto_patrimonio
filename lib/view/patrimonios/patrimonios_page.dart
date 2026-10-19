
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_patrimonio/controller/patrimoniocontroller.dart';
import 'package:projeto_patrimonio/widgets/menu_lateral.dart';

class PatrimoniosPage extends GetView<Patrimoniocontroller> {
  const PatrimoniosPage({super.key});

  @override
  Widget build(BuildContext context) {
    const cinzaEscuro = Color(0xFF747474);

    return Scaffold(
      drawer: const MenuLateral(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(padding: padding),
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: controller.listarPatrimonios,
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 4),

          Center(
            child: SizedBox(
              width: 239,
              height: 26,
              child: OutlinedButton(
                onPressed: () {
                  // Adicione aqui a navegação para completar o cadastro.
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: cinzaEscuro,
                  side: const BorderSide(
                    color: cinzaEscuro,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Clique aqui para completar seu cadastro',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 10,
                    color: cinzaEscuro,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: Obx(() {
              if (controller.carregando.value &&
                  controller.patrimonios.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.patrimonios.isEmpty) {
                return const Center(
                  child: Text('Nenhum patrimônio encontrado.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: controller.patrimonios.length,
                itemBuilder: (context, index) {
                  final item = controller.patrimonios[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: cinzaEscuro,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        item.nome,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Get.toNamed(
                          '/patrimonios/detalhes',
                          arguments: item,
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: controller.podeEditar
          ? FloatingActionButton.extended(
              onPressed: () {
                Get.toNamed('/patrimonio/adicionar');
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar patrimônio'),
            )
          : null,
    );
  }
}
