import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/Endereco.dart';

class Usuario {
  late String idUsuario;
  late String nome;
  late String email;
  String? cpf;
  late String senha;

  bool administrador = false;
  Endereco? endereco;

  FirebaseFirestore bancoDados = FirebaseFirestore.instance;

  Usuario();

  Usuario.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.idUsuario = documentSnapshot.id;
    this.nome = documentSnapshot["nome"];
    this.email = documentSnapshot["email"];
    Map<String, dynamic> dataMap =
        documentSnapshot.data() as Map<String, dynamic>;
    if (dataMap.containsKey('cpf')) {
      this.cpf = documentSnapshot['cpf'] as String;
    }
    if (dataMap.containsKey('endereco')) {
      endereco = Endereco.fromMap(
          documentSnapshot['endereco'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
      if (endereco != null) 'endereco': endereco!.toMap(),
      if (cpf != null) 'cpf': cpf
    };
    return map;
  }

  void setEndereco(Endereco endereco) {
    this.endereco = endereco;
    salvarDados();
  }

  void setCpf(String cpf){
    this.cpf = cpf;
    salvarDados();
  }

  CollectionReference get carrinhoReference => bancoDados
      .collection("usuarios")
      .doc(this.idUsuario)
      .collection('carrinho');

  Future<void> salvarDados() async {
    await bancoDados.collection("usuarios").doc(this.idUsuario).set(toMap());
  }
}
