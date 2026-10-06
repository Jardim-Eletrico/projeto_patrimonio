
import '../model/patrimonio.dart';
import 'package:get/get.dart';

class PatrimonioService  extends GetConnect{
  String baseurl = "http://localhost:8081";

  Future<Response<List<Patrimonio>>> listarPatrimonios(){
    return get('$baseurl/api/patrimonios', decoder: (dados) => decoder(dados));
  }

  Future<Response> buscarPatrimonio(int id){
      return get('$baseurl/api/patrimonios/${id.toString()}');
    }
  
  Future<Response> cadastrarPatrimonio(Patrimonio patrimonio){ //EXCLUSIVO ADMIN
    return post('$baseurl/api/patrimonios', patrimonio.toJson());
  }

  Future<Response> editarPatrimonio(Patrimonio patrimonio, int id){
    return put('$baseurl/api/patrimonios/${id.toString()}', patrimonio.toJson());
  }

  Future<Response> deletarPatrimonio(int id){
    return delete('$baseurl/api/patrimonios/${id.toString()}');
  }

  Future<Response> atribuirPatrimonio(int patrimonioId, int professorId){
    return post('$baseurl/api/patrimonios/$patrimonioId/atribuir',
      {
        'professor_id': professorId,
      },
    );
  }

  Future<Response> desatribuirPatrimonio(int patrimonioId) {
    return post(
      '$baseurl/api/patrimonios/$patrimonioId/desatribuir',
      {},
    );
  }

  Future<Response<List<Patrimonio>>> meusPatrimonios() {
    return get(
      '$baseurl/api/patrimonios/meus',
      decoder: (dados) => decoder(dados),
    );
  }

  Future<Response> obterMetricas() {
    return get(
      '$baseurl/api/patrimonios/metricas',
    );
  }

  Future<Response> historicoMovimentacao() {
    return get(
      '$baseurl/api/patrimonios/historico',
    );
  }



  //decoder
List<Patrimonio> decoder(dynamic dados){
    return (dados as List) .map((json) => Patrimonio.fromJson(json)).toList();
  }

  }



















