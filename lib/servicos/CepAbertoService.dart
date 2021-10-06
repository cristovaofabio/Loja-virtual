import 'package:http/http.dart' as minhaRequisicao;

const String token = '';

class CepAbertoService {
  Future<void> getEnderecoCep(String cep) async {
    String cleanCep = cep.replaceAll('.', '').replaceAll('-', '');

    var url = Uri.parse("https://www.cepaberto.com/api/v3/cep?cep=$cleanCep");
    var headers = {'Authorization': 'Token token=$token'};

    try {
      minhaRequisicao.Response response =await minhaRequisicao.get(url, headers: headers);

      print(response.body);
    } catch (erro) {
      print("Erro: " + erro.toString());
    }
  }
}
