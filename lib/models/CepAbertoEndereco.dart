class CepAbertoEndereco{

  final double altitude;
  final String cep;
  final double latitude;
  final double longitude;
  final String logradouro;
  final String bairro;
  final Cidade cidade;
  final Estado estado;
  

  CepAbertoEndereco.fromMap(Map<String, dynamic> map) :
    altitude = map['altitude'] as double,
    cep = map['cep'].toString(),
    latitude = double.parse(map['latitude'].toString()),
    longitude = double.parse(map['longitude'].toString()),
    logradouro = map['logradouro'].toString(),
    bairro = map['bairro'].toString(),
    cidade = Cidade.fromMap(map['cidade'] as Map<String, dynamic>),
    estado = Estado.fromMap(map['estado'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'CepAbertoEndereco{altitude: $altitude, cep: $cep, latitude: $latitude, longitude: $longitude, logradouro: $logradouro, bairro: $bairro, cidade: $cidade, estado: $estado}';
  }
}

class Cidade {

  final int ddd;
  final String ibge;
  final String nome;

  Cidade.fromMap(Map<String, dynamic> map) :
    ddd = map['ddd'] as int,
    ibge = map['ibge'] as String,
    nome = map['nome'] as String;

  @override
  String toString() {
    return 'Cidade{ddd: $ddd, ibge: $ibge, nome: $nome}';
  }
}

class Estado {

  final String sigla;

  Estado.fromMap(Map<String, dynamic> map) :
      sigla = map['sigla'] as String;

  @override
  String toString() {
    return 'Estado{sigla: $sigla}';
  }
}