import 'package:get/get.dart';
import '../model/patrimonio.dart';
import '../service/patrimonio_service.dart';

class Patrimoniocontroller extends GetxController {
  final PatrimonioService service = PatrimonioService();

  final patrimonio = Rxn<Patrimonio>();
  final patrimonios = <Patrimonio>[].obs;
  final carregando = false.obs;

  Future<void> listarPatrimonios() async {
    carregando.value = true;

    final response = await service.listarPatrimonios();

    if (response.isOk && response.body != null) {
      patrimonios.value = response.body!;
    }

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
}