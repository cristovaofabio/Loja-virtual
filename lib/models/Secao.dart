import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/SecaoItem.dart';
import 'package:uuid/uuid.dart';

class Secao extends ChangeNotifier {
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference get storageRef => storage.ref().child("home/$id");

  late String id;
  late String nome;
  late String tipo;
  late List<SecaoItem> itens;
  String _error = "";
  late List<SecaoItem> originalItens;

  Secao(
      {required this.id,
      required this.nome,
      required this.tipo,
      required this.itens}) {
    originalItens = List.from(itens);
  }

  Secao clone() {
    return Secao(
      id: id,
      nome: nome,
      tipo: tipo,
      itens: itens.map((e) => e.clone()).toList(),
    );
  }

  String get error => _error;
  set error(String value) {
    _error = value;
    notifyListeners();
  }

  bool valid() {
    //Verifica se uma determinada secao é válida
    if (nome.isEmpty) {
      error = 'Título inválido';
    } else if (itens.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = "";
    }
    return error.isEmpty;
  }

  void addItem(SecaoItem item) {
    itens.add(item);
    notifyListeners();
  }

  void removerItem(SecaoItem item) {
    itens.remove(item);
    notifyListeners();
  }

  Secao.fromDocument(DocumentSnapshot document) {
    this.id = document.id;
    this.nome = document["nome"] as String;
    this.tipo = document["tipo"] as String;
    this.itens = (document["itens"] as List<dynamic>)
        .map((s) => SecaoItem.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  Future<void> save(int pos) async {
    final Map<String, dynamic> data = {
      'nome': nome,
      'tipo': tipo,
      'pos': pos,
    };

    if (id.isEmpty) {
      final doc = await bancoDados.collection('home').add(data);
      id = doc.id; //Recuperando o id, que foi gerando aleatoriamente, da seção
    } else {
      await bancoDados.doc('home/$id').update(data);
    }

    int contador = 0;

    for (final item in this.itens) {
      if (!(item.imagem is String)) {
        Reference arquivo = storageRef.child(Uuid().v1());
        //Fazer o upload da imagem:
        UploadTask task = arquivo.putFile(item.imagem as File);
        //Controlar o progresso do upload:
        task.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          if (taskSnapshot.state == TaskState.running) {
          } else if (taskSnapshot.state == TaskState.success) {
            //Recuperar url da imagem:
            String url = await taskSnapshot.ref.getDownloadURL();
            contador++;
            item.imagem = url;

            try {
              final Map<String, dynamic> itemsData = {
                'itens': this.itens.map((e) => e.toMap()).toList()
              };
              await bancoDados.doc('home/$id').update(itemsData);
            } catch (erro) {
              print("erro: " + erro.toString());
            }
          }
        });
      } else {
        contador++;
      }
    }

    for (final original in originalItens) {
      if (itens.contains(original) == false) {
        try {
          final ref = storage.refFromURL(original.imagem.toString());
          await ref.delete();
          final Map<String, dynamic> itemsData = {
            'itens': itens.map((e) => e.toMap()).toList()
          };
          await bancoDados.doc('home/$id').update(itemsData);
        } catch (e) {
          print("Erro: " + e.toString());
        }
      }
    }
  }

  Future<void> delete() async {
    await bancoDados.doc('home/$id').delete();
    for (final item in itens) {
      try {
        final ref = storage.refFromURL(item.imagem as String);
        await ref.delete();
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  @override
  String toString() {
    return 'Secao{nome: $nome, tipo: $tipo, itens: $itens}';
  }
}
