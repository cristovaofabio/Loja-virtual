import 'dart:convert';

import 'package:http/http.dart' as minhaRequisicao;
import 'package:loja_virtual/models/CepAbertoEndereco.dart';

const String token = '27161b1ac49308bebd78399bcd4d639a';

class CepAbertoService {
  Future<CepAbertoEndereco?> getEnderecoCep(String cep) async {
    String cleanCep = cep.replaceAll('.', '').replaceAll('-', '');

    var url = Uri.parse("https://www.cepaberto.com/api/v3/cep?cep=$cleanCep");
    var headers = {'Authorization': 'Token token=$token'};

    try {
      minhaRequisicao.Response response = await minhaRequisicao.get(url, headers: headers);
      Map<String, dynamic> retorno = json.decode(response.body);
      CepAbertoEndereco endereco = CepAbertoEndereco.fromMap(retorno);

      return endereco;
      
    } catch (erro) {
      return null;
    }
  }
}
