import 'package:get/get.dart';
import '../model/patrimonio.dart';
import '../service/patrimonio_service.dart';
import '../service/auth_service.dart';

class Patrimoniocontroller extends GetxController {
  final PatrimonioService service;
  final AuthService authService;
  Patrimoniocontroller(this.service, this.authService);

  final patrimonios = <Patrimonio>[].obs;
  final patrimonio = Rxn<Patrimonio>();
  final carregando = false.obs;
  final erro = ''.obs;

  bool get podeEditar => authService.ehAdmin;

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
        erro.value = ;
      }
    } finally {
      carregando.value = false;
    }

  @override
  void onInit(){
    super.onInit();
    listarPatrimonios();
  }

  Future<void> buscarPatrimonio(int id) async{
    carregando.value = true;

    try{
    final response = await service.buscarPatrimonio(id);

    if (response.isOk && response.body != null){

      patrimonio.value = response.body;
    }
  }
  finally{
    carregando.value = false;
  }
  }

  Future<void> cadastroPatrimonio(Patrimonio patrimonio) async{
    final loginControler = Get.find<LoginCongtroler>();

    if (loginControler.usuario.value?.role != 'admin'){
      Get.snackbar("Aceso Negado:", "Você não tem permissão para acessar essa função");
      return;
    }
    carregando.value = true;
    
  }
}