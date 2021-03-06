import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:loja_virtual/models/TamanhoItem.dart';

class Produto extends ChangeNotifier {

  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference get storageRef => storage.ref().child("produtos").child(id!);

  String? id;
  String? nome = "";
  String? descricao = "";
  List<String>? imagens;
  List<TamanhoItem>? tamanhos;
  List<dynamic>? novasImagens;
  bool? deletado;
  bool _carregando = false;
  bool get carregando => _carregando;
  set carregando(bool value){
    _carregando = value;
    notifyListeners();
  }

  Produto({this.id, this.nome, this.descricao, this.imagens, this.tamanhos,this.deletado = false}) {
    imagens = imagens ?? [];
    tamanhos = tamanhos ?? [];
  }

  TamanhoItem _tamanhoSelecionado = TamanhoItem();

  List<Map<String, dynamic>> exportTamanhoList() {
    return tamanhos!.map((tamanho) => tamanho.toMap()).toList();
  }

  Future<void> save() async {
    carregando = true;

    final Map<String, dynamic> dados = {
      'nome': nome,
      'descricao': descricao,
      'tamanhos': exportTamanhoList(), //lista de maps
      'deletado': deletado,
    };

    if (id == null) {
      final doc = await bancoDados.collection('produtos').add(dados);
      id = doc.id;
    } else {
      await bancoDados.doc('produtos/$id').update(dados);
    }

    List<String> updateImages = [];

    int contador = 0;

    for (final newImage in novasImagens!) {
      if (imagens!.contains(newImage)) {
        updateImages.add(newImage as String);
        contador++;
      } else {
        Reference arquivo = storageRef.child(Uuid().v1());

        //Fazer o upload da imagem
        UploadTask task = arquivo.putFile(newImage as File);
        //Controlar o progresso do upload:
        task.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
          if (taskSnapshot.state == TaskState.running) {
          } else if (taskSnapshot.state == TaskState.success) {
            //Recuperar url da imagem:
            String url = await taskSnapshot.ref.getDownloadURL();
            updateImages.add(url);
            contador++;
            if (contador == novasImagens!.length) {
              await bancoDados.doc('produtos/$id').update({'imagens': updateImages}).then((value){
                this.imagens = updateImages;
                notifyListeners();
              carregando = false;
              });
              
            }
          }
        });
      }
    }
    for (final imagem in imagens!) {
      if (!novasImagens!.contains(imagem)) {
        try {
          await storage.refFromURL(imagem).delete();
        } catch (e) {
          debugPrint('Falha ao deletar $imagem');
        }
      }
    }
  }
  
  void delete(){
    bancoDados.doc('produtos/$id').update({'deletado': true});
  }

  Produto clone() {
    return Produto(
      id: id,
      nome: nome,
      descricao: descricao,
      imagens: List.from(imagens!),
      tamanhos: tamanhos!.map((size) => size.clone()).toList(),
      deletado: deletado,
    );
  }

  TamanhoItem get tamanhoSelecionado => _tamanhoSelecionado;
  set tamanhoSelecionado(TamanhoItem value) {
    _tamanhoSelecionado = value;
    notifyListeners();
  }

  int get totalEstoque {
    int estoque = 0;
    for (final tamanho in tamanhos!) {
      estoque += tamanho.estoque!;
    }
    return estoque;
  }

  bool get temEstoque {
    return (totalEstoque > 0 && (deletado==false));
  }

  num get precoBase {
    num menor = double.infinity;
    for (final tamanho in tamanhos!) {
      if (tamanho.preco! < menor ) menor = tamanho.preco!;
    }
    return menor;
  }

  TamanhoItem encontrarTamanho(String nome) {
    try {
      return tamanhos!.firstWhere((s) => s.nome == nome);
    } catch (e) {
      TamanhoItem tamanhoItem = TamanhoItem();
      tamanhoItem.nome = "";
      tamanhoItem.preco = 0;
      tamanhoItem.estoque = 0;
      return tamanhoItem;
    }
  }

  Produto.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.id = documentSnapshot.id;
    this.nome = documentSnapshot["nome"];
    this.descricao = documentSnapshot["descricao"];
    this.imagens = List<String>.from(documentSnapshot["imagens"]);
    this.deletado = (documentSnapshot['deletado'] ?? false) as bool;
    /* Map<String, dynamic> dataMap = documentSnapshot.data() as Map<String, dynamic>;
    if(dataMap.containsKey('deletado')){
      this.deletado = (documentSnapshot['deletado']) as bool;
    } else{
      this.deletado = false;
    }
    */
    this.tamanhos = (documentSnapshot["tamanhos"] as List<dynamic>)
        .map((s) => TamanhoItem.fromMap(s as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": this.id,
      "nome": this.nome,
      "descricao": this.descricao,
      "imagens": this.imagens
    };
    return map;
  }

  @override
  String toString() {
    return 'Produto{id: $id, nome: $nome, descricao: $descricao, imagens: $imagens, tamanhos: $tamanhos, novasImagens: $novasImagens}';
  }
}
