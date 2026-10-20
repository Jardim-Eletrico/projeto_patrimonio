
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:projeto_patrimonio/widgets/campo_texto.dart';
import 'package:projeto_patrimonio/widgets/campo_selecao.dart';
import 'package:projeto_patrimonio/widgets/botaoprincipal.dart';
import 'package:projeto_patrimonio/controller/patrimoniocontroller.dart';
import 'package:projeto_patrimonio/model/patrimonio.dart';


class AdicionarPatrimonioPage extends StatefulWidget {
  const AdicionarPatrimonioPage({super.key});

  @override
  State<AdicionarPatrimonioPage> createState() =>
      _AdicionarPatrimonioPageState();
}

class _AdicionarPatrimonioPageState
    extends State<AdicionarPatrimonioPage> {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<Patrimoniocontroller>();

  final codigoCtrl = TextEditingController();
  final nomeCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();
  final categoriaCtrl = TextEditingController();
  final marcaCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();
  final numeroSerieCtrl = TextEditingController();
  final localizacaoCtrl = TextEditingController();
  final observacoesCtrl = TextEditingController();

  final estadoOpcoes = ['Excelente', 'Bom', 'Ruim'];
  final statusOpcoes = ['Disponível', 'Em uso'];

  String? estadoSelecionado = 'Bom';
  String? statusSelecionado = 'Disponível';

  bool carregando = false;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar patrimônio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informações do patrimônio',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              CampoTexto(
                titulo: 'Código',
                controller: codigoCtrl,
                editavel: true,
              ),
              CampoTexto(
                titulo: 'Nome',
                controller: nomeCtrl,
                editavel: true,
              ),
              CampoTexto(
                titulo: 'Descrição',
                controller: descricaoCtrl,
                editavel: true,
                maxLines: 3,
              ),
              CampoTexto(
                titulo: 'Categoria',
                controller: categoriaCtrl,
                editavel: true,
              ),
              CampoTexto(
                titulo: 'Marca',
                controller: marcaCtrl,
                editavel: true,
              ),
              CampoTexto(
                titulo: 'Modelo',
                controller: modeloCtrl,
                editavel: true,
              ),
              CampoTexto(
                titulo: 'Número de série',
                controller: numeroSerieCtrl,
                editavel: true,
              ),

              CampoSelecao(
                titulo: 'Estado de conservação',
                valor: estadoSelecionado!,
                opcoes: estadoOpcoes,
                editavel: true,
                onChanged: (valor) {
                  setState(() => estadoSelecionado = valor);
                },
              ),

              CampoTexto(
                titulo: 'Localização',
                controller: localizacaoCtrl,
                editavel: true,
              ),

              CampoSelecao(
                titulo: 'Status',
                valor: statusSelecionado!,
                opcoes: statusOpcoes,
                editavel: true,
                onChanged: (valor) {
                  setState(() => statusSelecionado = valor);
                },
              ),

              CampoTexto(
                titulo: 'Observações',
                controller: observacoesCtrl,
                editavel: true,
                obrigatorio: false,
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              BotaoPrincipal(
                texto: 'Cadastrar patrimônio',
                carregando: carregando,
                onPressed: _cadastrar,
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: carregando ? null : () => Get.back(),
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
Future<void> _cadastrar() async {
  if (!formKey.currentState!.validate()) return;

  if (estadoSelecionado == null || statusSelecionado == null) {
    Get.snackbar(
      'Erro',
      'Selecione o estado de conservação e o status.',
    );
    return;
  }

  setState(() => carregando = true);

  try {
    final agora = DateTime.now();

    final novo = Patrimonio(
      codigo: codigoCtrl.text.trim(),
      nome: nomeCtrl.text.trim(),
      descricao: descricaoCtrl.text.trim(),
      categoria: categoriaCtrl.text.trim(),
      marca: marcaCtrl.text.trim(),
      modelo: modeloCtrl.text.trim(),
      numeroSerie: numeroSerieCtrl.text.trim(),
      estadoConservacao: estadoSelecionado!,
      localizacao: localizacaoCtrl.text.trim(),
      status: statusSelecionado == 'Disponível'
          ? 'disponivel'
          : 'em_uso',
      adminId: null,
      professorId: null,
      observacoes: observacoesCtrl.text.trim(),
      createdAt: agora,
      updatedAt: agora,
    );

    final sucesso = await controller.cadastrarPatrimonio(novo);

    if (!mounted) return;

    if (sucesso) {
      Get.offNamed('/patrimonios');
    }
  } catch (e) {
    Get.snackbar(
      'Erro',
      'Não foi possível cadastrar o patrimônio.',
    );
  } finally {
    if (mounted) {
      setState(() => carregando = false);
    }
  }
}

}
