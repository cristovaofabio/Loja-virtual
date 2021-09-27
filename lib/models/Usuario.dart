import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  late String idUsuario;
  late String nome;
  late String email;
  late String senha;

  bool administrador = false;

  FirebaseFirestore bancoDados = FirebaseFirestore.instance;

  Usuario();

  Usuario.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    this.idUsuario = documentSnapshot.id;
    this.nome = documentSnapshot["nome"];
    this.email = documentSnapshot["email"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "email": this.email,
    };
    return map;
  }

  CollectionReference get carrinhoReference => 
    bancoDados
      .collection("usuarios")
      .doc(this.idUsuario)
      .collection('carrinho');

  Future<void> salvarDados() async {
    await bancoDados
      .collection("usuarios")
      .doc(this.idUsuario)
      .set(toMap());
  }
}
