import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  late String idUsuario;
  late String nome;
  late String email;
  late String senha;

  Usuario();

  Usuario.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
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

  Future<void> salvarDados() async {
    FirebaseFirestore bancoDados = FirebaseFirestore.instance;
    await bancoDados
            .collection("usuarios")
            .doc(this.idUsuario)
            .set(toMap());
  }
}
