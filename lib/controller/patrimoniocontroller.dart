import 'package:get/get.dart';
import '../model/patrimonio.dart';
import '../service/patrimonio_service.dart';

class Patrimoniocontroller extends GetxController {
  final PatrimonioService service = PatrimonioService();

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
}