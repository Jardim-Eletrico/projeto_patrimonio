import 'package:get/get.dart';
import '../model/patrimonio.dart';
import '../service/patrimonio_service.dart';
import '../service/auth_service.dart';
import 'package:flutter/foundation.dart';


class Patrimoniocontroller extends GetxController {
  final PatrimonioService service;
  final AuthService authService;
  Patrimoniocontroller(this.service, this.authService);

  final patrimonios = <Patrimonio>[].obs;
  final patrimonio = Rxn<Patrimonio>();
  final carregando = false.obs;
  final erro = ''.obs;

  bool get podeEditar => authService.ehAdmin;

  bool _semPermissao() {
    if (podeEditar) return false;

    Get.snackbar(
      'Acesso negado',
      'Tu não tens permissão para realizar esta ação',
    );
    return true;
  }

  void mostrarErro([String? mensagem]) {
    erro.value = mensagem ?? 'Ocorreu um erro inesperado';
  }

  String _mensagemErro(Response response) {
    switch (response.statusCode) {
      case 400:
        return 'Dados inválidos';
      case 401:
        return 'Sessão expirada, faça login novamente';
      case 403:
        return 'Você não tem permissão para esta ação';
      case 404:
        return 'Patrimônio não encontrado';
      case null:
        return 'Sem conexão com o servidor';
      default:
        return 'Erro inesperado (${response.statusCode})';
    }
  }

  @override
  void onInit() {
    super.onInit();
    listarPatrimonios();
  }

  Future<void> listarPatrimonios() async {
    carregando.value = true;
    erro.value = '';

    try {
      final response = await service.listarPatrimonios();

      if (response.isOk) {
        patrimonios.assignAll(response.body ?? []);
      } else {
        mostrarErro(_mensagemErro(response));
      }
    } catch (e, stackTrace) {
      debugPrint('Erro ao listar patrimonios: $e');
      debugPrint('Stack trace: $stackTrace');
      mostrarErro('Erro ao carregar os patrimônios');
    } finally {
      carregando.value = false;
    }
  }

  Future<void> buscarPatrimonio(int id) async {
    carregando.value = true;
    erro.value = '';

    try {
      final response = await service.buscarPatrimonio(id);

      if (response.isOk && response.body != null) {
        patrimonio.value = response.body;
      } else {
        mostrarErro(_mensagemErro(response));
      }
    } catch (e) {
      mostrarErro('Erro ao buscar o patrimônio');
    } finally {
      carregando.value = false;
    }
  }

  Future<bool> cadastrarPatrimonio(Patrimonio novo) async {
    if (_semPermissao()) return false;

    carregando.value = true;
    try {
      final response = await service.cadastrarPatrimonio(novo);

      if (response.isOk) {
        await listarPatrimonios();
        Get.snackbar('Sucesso', 'Patrimônio cadastrado');
        return true;
      }
      Get.snackbar('Erro', _mensagemErro(response));
      return false;
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao cadastrar o patrimônio');
      return false;
    } finally {
      carregando.value = false;
    }
  }

  Future<bool> editarPatrimonio(Patrimonio editado) async{
    if(_semPermissao()) return false;
    
    final id = editado.id;
    if (id == null) {
      Get.snackbar('Erro:', 'Patrimônio sem identificador');
      return false;
    }
    carregando.value = true;

    try{
      final response = await service.editarPatrimonio(editado, id);

      if (response.isOk) {
        await listarPatrimonios();
        Get.snackbar("Sucesso:", "Patrimônio atualizado");
        return true;
      }

      Get.snackbar('Erro:', _mensagemErro(response));
      return false;
    }finally{
      carregando.value = false;
    }
  }

  Future<bool> deletarPatrimonio(int id) async{
    if(_semPermissao()) return false;
    
    carregando.value = true;
     try{
      final response = await service.deletarPatrimonio(id);

      if (response.isOk) {
        await listarPatrimonios();
        Get.snackbar("Sucesso:", "Patrimônio deletado");
        return true;
      }

      Get.snackbar('Erro:', _mensagemErro(response));
      return false;
    }finally{
      carregando.value = false;
    }

  }
}