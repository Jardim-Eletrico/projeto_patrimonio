
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/patrimoniocontroller.dart';

class EstatisticasPatrimonioDialog extends StatelessWidget {
  final Patrimoniocontroller controller;

  const EstatisticasPatrimonioDialog({
    super.key,
    required this.controller,
  });

  static void mostrar(Patrimoniocontroller controller) {
    controller.carregarEstatisticas();

    Get.dialog(
      EstatisticasPatrimonioDialog(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Estatísticas dos patrimônios'),
      content: Obx(() {
        if (controller.carregandoEstatisticas.value) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final dados = controller.estatisticas.value;

        if (dados == null) {
          return const Text(
            'Não foi possível carregar as estatísticas.',
          );
        }

        final categorias = dados['porCategoria'];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _informacao(
                'Total de patrimônios',
                dados['totalPatrimonios'],
              ),
              _informacao(
                'Em uso',
                dados['patrimoniosEmUso'],
              ),
              _informacao(
                'Disponíveis',
                dados['patrimoniosDisponiveis'],
              ),
              _informacao(
                'Em manutenção',
                dados['patrimoniosEmManutencao'],
              ),
              const Divider(),
              _informacao(
                'Total de professores',
                dados['totalProfessores'],
              ),
              _informacao(
                'Professores com patrimônios',
                dados['totalProfessoresComPatrimonios'],
              ),
              const Divider(),
              const Text(
                'Patrimônios por categoria',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (categorias is Map && categorias.isNotEmpty)
                ...categorias.entries.map(
                  (entrada) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${entrada.key}: ${entrada.value}',
                    ),
                  ),
                )
              else
                const Text('Nenhuma categoria encontrada.'),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }

  Widget _informacao(String titulo, dynamic valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text('$titulo:')),
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
