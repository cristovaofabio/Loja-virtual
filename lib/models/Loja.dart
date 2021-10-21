import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Endereco.dart';

class Loja{
  late String nome;
  late String imagem;
  late String telefone;
  late Endereco endereco;
  late Map<String,Map> abrindo;

  Loja.fromDocument(DocumentSnapshot doc){
    nome = doc['nome'] as String;
    imagem = doc['imagem'] as String;
    telefone = doc['telefone'] as String;
    endereco = Endereco.fromMap(doc['endereco'] as Map<String, dynamic>);

    abrindo = (doc['abrindo'] as Map<String, dynamic>).map((key, value) {
      final timesString = value as String;
      /*
      EXEMPLO:
      abrindo
        sabado : "8:00-11:30"

      key: sabado
      value: "8:00-11:30"
      */

      if(timesString.isNotEmpty){
        final splitted = timesString.split(RegExp(r"[:-]"));

        return MapEntry(
          key,
          {
            "from": TimeOfDay(
              hour: int.parse(splitted[0]),
              minute: int.parse(splitted[1])
            ),
            "to": TimeOfDay(
                hour: int.parse(splitted[2]),
                minute: int.parse(splitted[3])
            ),
          }
        );
      } else {
        Map<dynamic, dynamic>? value;
        return MapEntry(key, value!);
      }
    });

    print(abrindo);
  }

  String get enderecoText =>
      '${endereco.rua}, ${endereco.numero}${endereco.complemento!.isNotEmpty ? ' - ${endereco.complemento}' : ''} - '
      '${endereco.distrito}, ${endereco.cidade}/${endereco.estado}';
}