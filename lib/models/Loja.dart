import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/helper/extensoes.dart';

enum LojaStatus { fechado, aberto, fechando }

class Loja {
  late String nome;
  late String imagem;
  late String telefone;
  late Endereco endereco;
  late Map<String, Map<String, TimeOfDay>> abrindo;
  late LojaStatus status;

  Loja.fromDocument(DocumentSnapshot doc) {
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

      if (timesString.isNotEmpty) {
        final splitted = timesString.split(RegExp(r"[:-]"));

        return MapEntry(key, {
          "from": TimeOfDay(
              hour: int.parse(splitted[0]), minute: int.parse(splitted[1])),
          "to": TimeOfDay(
              hour: int.parse(splitted[2]), minute: int.parse(splitted[3])),
        });
      } else {
        Map<String, TimeOfDay>? value;
        return MapEntry(key, value!);
      }
    });

    atualizarStatus();
  }

  void atualizarStatus() {
    final diaSemana = DateTime.now().weekday;

    Map<String, TimeOfDay>? period;
    if (diaSemana >= 1 && diaSemana <= 5) {
      if (!abrindo.containsKey("segsex")) {
        period = null;
      } else {
        period = abrindo['segsex']!;
      }
    } else if (diaSemana == 6) {
      if (!abrindo.containsKey("sabado")) {
        period = null;
      } else {
        period = abrindo['sabado']!;
      }
    } else {
      if (!abrindo.containsKey("domingo")) {
      } else {
        period = abrindo['domingo']!;
      }
    }

    final agora = TimeOfDay.now();

    if (period == null) {
      status = LojaStatus.fechado;
    } else if (period['from']!.toMinutes() < agora.toMinutes() &&
        period['to']!.toMinutes() - 15 > agora.toMinutes()) {
      status = LojaStatus.aberto;
    } else if (period['from']!.toMinutes() < agora.toMinutes() &&
        period['to']!.toMinutes() > agora.toMinutes()) {
      status = LojaStatus.fechando;
    } else {
      status = LojaStatus.fechado;
    }
  }

  String get enderecoText =>
      '${endereco.rua}, ${endereco.numero}${endereco.complemento!.isNotEmpty ? ' - ${endereco.complemento}' : ''} - '
      '${endereco.distrito}, ${endereco.cidade}/${endereco.estado}';

  String get abrindoText {
    return 'Seg-Sex: ${formattedPeriod(abrindo['segsex'])}\n'
        'Sab: ${formattedPeriod(abrindo['sabado'])}\n'
        'Dom: ${formattedPeriod(abrindo['domingo'])}';
  }

  String formattedPeriod(Map<String, TimeOfDay>? period) {
    if (period == null) {
      return "Fechada";
    }
    return '${period['from']!.formatado()} - ${period['to']!.formatado()}';
  }

  String get statusText {
    switch(status){
      case LojaStatus.fechado:
        return 'Fechada';
      case LojaStatus.aberto:
        return 'Aberta';
      case LojaStatus.fechando:
        return 'Fechando';
      default:
        return '';
    }
  }
  //Substitui tudo que nao for digito por vazio:
  String get cleanTelefone => telefone.replaceAll(RegExp(r"[^\d]"), "");
}
