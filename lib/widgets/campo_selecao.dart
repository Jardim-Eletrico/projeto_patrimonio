import 'package:flutter/material.dart';

class CampoSelecao extends StatelessWidget {
  final String titulo;
  final String valor;
  final List<String> opcoes;
  final bool editavel;
  final ValueChanged<String?> onChanged;

  const CampoSelecao({
    super.key,
    required this.titulo,
    required this.valor,
    required this.opcoes,
    required this.editavel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: opcoes.contains(valor) ? valor : null,
        decoration: InputDecoration(
          labelText: titulo,
          border: const OutlineInputBorder(),
        ),
        items: opcoes.map((opcao) {
          return DropdownMenuItem<String>(
            value: opcao,
            child: Text(opcao),
          );
        }).toList(),
        onChanged: editavel ? onChanged : null,
        validator: (valor) {
          if (editavel && valor == null) {
            return 'Selecione $titulo';
          }
          return null;
        },
      ),
    );
  }
}