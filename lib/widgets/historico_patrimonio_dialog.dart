
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/patrimoniocontroller.dart';

class HistoricoPatrimonioDialog extends StatelessWidget {
  final Patrimoniocontroller controller;
  final int patrimonioId;

  const HistoricoPatrimonioDialog({
    super.key,
    required this.controller,
    required this.patrimonioId,
  });

  static void mostrar(
    Patrimoniocontroller controller,
    int patrimonioId,
  ) {
    controller.carregarHistorico(patrimonioId);

    Get.dialog(
      HistoricoPatrimonioDialog(
        controller: controller,
        patrimonioId: patrimonioId,
      ),
    );
  }

  String _formatarData(dynamic valor) {
    if (valor == null || valor.toString().isEmpty) {
      return 'Data não informada';
    }

    final data = DateTime.tryParse(valor.toString());

    if (data == null) {
      return valor.toString();
    }

    final local = data.toLocal();

    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    final ano = local.year;
    final hora = local.hour.toString().padLeft(2, '0');
    final minuto = local.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$ano às $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Histórico do patrimônio #$patrimonioId'),
      content: Obx(() {
        if (controller.carregandoHistorico.value) {
          return const SizedBox(
            height: 120,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final dados = controller.historico.value;

        if (dados == null) {
          return const Text(
            'Não foi possível carregar o histórico.',
          );
        }

        final registros = dados['historico'];

        if (registros is! List || registros.isEmpty) {
          return const Text(
            'Nenhum registro encontrado para este patrimônio.',
          );
        }

        return SizedBox(
          width: double.maxFinite,
          height: 350,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: registros.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final registro = Map<String, dynamic>.from(
                registros[index] as Map,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    registro['acao']?.toString() ??
                        'Ação não informada',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _detalhe(
                    'Professor',
                    registro['professorNome'],
                  ),
                  _detalhe(
                    'Administrador',
                    registro['adminNome'],
                  ),
                  _detalhe(
                    'Motivo',
                    registro['motivo'],
                  ),
                  _detalhe(
                    'Data',
                    _formatarData(registro['dataRegistro']),
                  ),
                ],
              );
            },
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

  Widget _detalhe(String titulo, dynamic valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$titulo: ${valor ?? 'Não informado'}',
      ),
    );
  }
}
