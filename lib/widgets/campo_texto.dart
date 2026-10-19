import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final String titulo;
  final TextEditingController controller;
  final bool editavel;
  final bool obrigatorio;
  final int maxLines;

  const CampoTexto({
    super.key,
    required this.titulo,
    required this.controller,
    this.editavel = false,
    this.obrigatorio = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        readOnly: !editavel,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: titulo,
          border: const OutlineInputBorder(),
        ),
        validator: (valor) {
          if (editavel &&
              obrigatorio &&
              (valor == null || valor.trim().isEmpty)) {
            return 'Preencha o campo $titulo';
          }
          return null;
        },
      ),
    );
  }
}