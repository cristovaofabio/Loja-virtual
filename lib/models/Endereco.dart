class Endereco {
  String? rua;
  String? numero;
  String? complemento;
  String? distrito;
  String? zipCode;
  String? cidade;
  String? estado;
  double? lat;
  double? long;

  Endereco({
    this.rua,
    this.numero,
    this.complemento,
    this.distrito,
    this.zipCode,
    this.cidade,
    this.estado,
    this.lat,
    this.long,
  });


  Endereco.fromMap(Map<String, dynamic> map) {
    rua = map['rua'] as String;
    numero = map['numero'] as String;
    complemento = map['complemento'] as String;
    distrito = map['distrito'] as String;
    zipCode = map['zipCode'] as String;
    cidade = map['cidade'] as String;
    estado = map['estado'] as String;
    lat = map['lat'] as double;
    long = map['long'] as double;
  }

  Map<String, dynamic> toMap() {
    return {
      'rua'         : rua,
      'numero'      : numero,
      'complemento' : complemento,
      'distrito'    : distrito,
      'zipCode'     : zipCode,
      'cidade'      : cidade,
      'estado'      : estado,
      'lat'         : lat,
      'long'        : long,
    };
  }
}
