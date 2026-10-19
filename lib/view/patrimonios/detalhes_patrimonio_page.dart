
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_patrimonio/controller/patrimoniocontroller.dart';
import 'package:projeto_patrimonio/model/patrimonio.dart';
import 'package:projeto_patrimonio/widgets/campo_texto.dart';
import 'package:projeto_patrimonio/widgets/campo_selecao.dart';
import 'package:projeto_patrimonio/widgets/botaoprincipal.dart';

class DetalhesPatrimonioPage extends StatefulWidget {
  const DetalhesPatrimonioPage({super.key});

  @override
  State<DetalhesPatrimonioPage> createState() =>
      _DetalhesPatrimonioPageState();
}

class _DetalhesPatrimonioPageState
    extends State<DetalhesPatrimonioPage> {
  final controller = Get.find<Patrimoniocontroller>();
  final formKey = GlobalKey<FormState>();

  late Patrimonio item;
  late bool modoEdicao;

  final codigoCtrl = TextEditingController();
  final nomeCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();
  final categoriaCtrl = TextEditingController();
  final marcaCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();
  final numeroSerieCtrl = TextEditingController();
  final localizacaoCtrl = TextEditingController();
  final observacoesCtrl = TextEditingController();

  final statusOpcoes = ['Em uso', 'Disponivel'];
  final estadoOpcoes = ['Excelente', 'Bom', 'Ruim'];

  late String statusSelecionado;
  late String estadoSelecionado;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args is Map) {
      item = args['patrimonio'] as Patrimonio;
      modoEdicao =
          args['modoedicao'] == true ||
          args['modoEdicao'] == true;
    } else {
      item = args as Patrimonio;
      modoEdicao = false;
    }

    codigoCtrl.text = item.codigo;
    nomeCtrl.text = item.nome;
    descricaoCtrl.text = item.descricao;
    categoriaCtrl.text = item.categoria;
    marcaCtrl.text = item.marca;
    modeloCtrl.text = item.modelo;
    numeroSerieCtrl.text = item.numeroSerie;
    localizacaoCtrl.text = item.localizacao;
    observacoesCtrl.text = item.observacoes ?? '';

    statusSelecionado = _normalizarStatus(item.status);
    estadoSelecionado =
        _normalizarEstado(item.estadoConservacao);
  }

  String _normalizarStatus(String valor) {
    final normalizado = valor.trim().toLowerCase();

    if (normalizado == 'em uso' || normalizado == 'em_uso') {
      return 'Em uso';
    }

    return 'Disponivel';
  }

  String _normalizarEstado(String valor) {
    for (final opcao in estadoOpcoes) {
      if (opcao.toLowerCase() == valor.trim().toLowerCase()) {
        return opcao;
      }
    }

    return 'Bom';
  }

  @override
  void dispose() {
    codigoCtrl.dispose();
    nomeCtrl.dispose();
    descricaoCtrl.dispose();
    categoriaCtrl.dispose();
    marcaCtrl.dispose();
    modeloCtrl.dispose();
    numeroSerieCtrl.dispose();
    localizacaoCtrl.dispose();
    observacoesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editavel = modoEdicao && controller.podeEditar;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          modoEdicao
              ? 'Editar patrimônio'
              : 'Detalhes do patrimônio',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CampoTexto(
                titulo: 'Código',
                controller: codigoCtrl,
                editavel: editavel,
              ),
              CampoTexto(
                titulo: 'Nome',
                controller: nomeCtrl,
                editavel: editavel,
              ),
              CampoTexto(
                titulo: 'Descrição',
                controller: descricaoCtrl,
                editavel: editavel,
                maxLines: 3,
              ),
              CampoTexto(
                titulo: 'Categoria',
                controller: categoriaCtrl,
                editavel: editavel,
              ),
              CampoTexto(
                titulo: 'Marca',
                controller: marcaCtrl,
                editavel: editavel,
              ),
              CampoTexto(
                titulo: 'Modelo',
                controller: modeloCtrl,
                editavel: editavel,
              ),
              CampoTexto(
                titulo: 'Número de série',
                controller: numeroSerieCtrl,
                editavel: editavel,
              ),

              CampoSelecao(
                titulo: 'Estado de conservação',
                valor: estadoSelecionado,
                opcoes: estadoOpcoes,
                editavel: editavel,
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() => estadoSelecionado = valor);
                  }
                },
              ),

              CampoTexto(
                titulo: 'Localização',
                controller: localizacaoCtrl,
                editavel: editavel,
              ),

              CampoSelecao(
                titulo: 'Status',
                valor: statusSelecionado,
                opcoes: statusOpcoes,
                editavel: editavel,
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() => statusSelecionado = valor);
                  }
                },
              ),

              CampoTexto(
                titulo: 'Observações',
                controller: observacoesCtrl,
                editavel: editavel,
                obrigatorio: false,
                maxLines: 3,
              ),

              if (!modoEdicao) ...[
                const SizedBox(height: 8),
                Text(
                  'Data de cadastro: '
                  '${item.createdAt.toLocal()}',
                ),
              ],

              const SizedBox(height: 24),

              if (controller.podeEditar && !modoEdicao) ...[
                BotaoPrincipal(
                  texto: 'Editar patrimônio',
                  onPressed: () {
                    setState(() => modoEdicao = true);
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => _confirmarExclusao(context),
                    icon: const Icon(Icons.delete),
                    label: const Text('Excluir patrimônio'),
                  ),
                ),
              ],

              if (editavel) ...[
                BotaoPrincipal(
                  texto: 'Salvar alterações',
                  onPressed: _salvar,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _restaurarCampos();
                        modoEdicao = false;
                      });
                    },
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _restaurarCampos() {
    codigoCtrl.text = item.codigo;
    nomeCtrl.text = item.nome;
    descricaoCtrl.text = item.descricao;
    categoriaCtrl.text = item.categoria;
    marcaCtrl.text = item.marca;
    modeloCtrl.text = item.modelo;
    numeroSerieCtrl.text = item.numeroSerie;
    localizacaoCtrl.text = item.localizacao;
    observacoesCtrl.text = item.observacoes ?? '';

    statusSelecionado = _normalizarStatus(item.status);
    estadoSelecionado =
        _normalizarEstado(item.estadoConservacao);
  }

  Future<void> _salvar() async {
    if (!controller.podeEditar) return;
    if (!formKey.currentState!.validate()) return;

    final editado = Patrimonio(
      id: item.id,
      codigo: codigoCtrl.text.trim(),
      nome: nomeCtrl.text.trim(),
      descricao: descricaoCtrl.text.trim(),
      categoria: categoriaCtrl.text.trim(),
      marca: marcaCtrl.text.trim(),
      modelo: modeloCtrl.text.trim(),
      numeroSerie: numeroSerieCtrl.text.trim(),
      estadoConservacao: estadoSelecionado,
      localizacao: localizacaoCtrl.text.trim(),
      status: statusSelecionado == 'Disponivel'
          ? 'disponivel'
          : 'Em uso',
      adminId: item.adminId,
      professorId: item.professorId,
      observacoes: observacoesCtrl.text.trim(),
      createdAt: item.createdAt,
      updatedAt: DateTime.now(),
    );

    final sucesso = await controller.editarPatrimonio(editado);

    if (!mounted) return;

    if (sucesso) {
      setState(() {
        item = editado;
        modoEdicao = false;
      });

      Get.snackbar('Sucesso', 'Patrimônio atualizado.');
    } else {
      Get.snackbar(
        'Erro',
        controller.erro.value.isEmpty
            ? 'Não foi possível atualizar o patrimônio.'
            : controller.erro.value,
      );
    }
  }

  void _confirmarExclusao(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Excluir patrimônio'),
        content: Text('Deseja excluir "${item.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();

              if (item.id == null) return;

              await controller.deletarPatrimonio(item.id!);

              if (controller.erro.value.isEmpty) {
                Get.back();
              }
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
