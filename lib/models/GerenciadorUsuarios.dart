import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/helper/FirebaseErros.dart';
import 'package:loja_virtual/models/Usuario.dart';

class GerenciadorUsuarios extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  bool carregando = false;
  Usuario usuarioAtual = Usuario();

  GerenciadorUsuarios() {
    _carregarUsuarioAtual();
  }

  Future<void> entrar(
      {required Usuario usuario,
      required Function fracasso,
      required Function sucesso}) async {
    setCarregando(true);
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha,
      );

      await _carregarUsuarioAtual(user: userCredential.user);

      sucesso();
    } on FirebaseAuthException catch (erro) {
      fracasso(getErrorString(erro.code));
      //Usuário não existente:
      //[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.
    }
    setCarregando(false);
  }

  void sair() {
    auth.signOut();
    usuarioAtual = Usuario();
    usuarioAtual.nome = "";
    usuarioAtual.email = "";
    notifyListeners();
  }

  Future<void> cadastrar(
      {required Usuario usuario,
      required Function fracasso,
      required Function sucesso}) async {
    setCarregando(true);
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);

      usuario.idUsuario = userCredential.user!.uid;

      await usuario.salvarDados();
      this.usuarioAtual = usuario;

      sucesso();
    } on FirebaseAuthException catch (erro) {
      fracasso(getErrorString(erro.code));
    }
    setCarregando(false);
  }

  void setCarregando(bool valor) {
    carregando = valor;
    notifyListeners();
  }

  Future<void> _carregarUsuarioAtual({User? user}) async {
    User? usuario;

    if (user == null) {
      //Não foi passado nenhum usuário!
      usuario = auth.currentUser;
    } else {
      usuario = user;
    }
    //Verificar se existe algum usuário logado
    if (usuario != null) {
      //Usuário logado!
      DocumentSnapshot documento =
          await bancoDados.collection("usuarios").doc(usuario.uid).get();

      usuarioAtual = Usuario.fromDocumentSnapshot(documento);

      final docAdmin = await bancoDados
          .collection('administradores')
          .doc(usuarioAtual.idUsuario)
          .get();
      if (docAdmin.exists) {
        usuarioAtual.administrador = true;
      }

      print(usuarioAtual.administrador);
    } else {
      //Usuário deslogado!
      usuarioAtual = Usuario();
      usuarioAtual.nome = "";
      usuarioAtual.email = "";
    }

    notifyListeners();
  }

  //Se o nome não for vazio, então existe usuário logado:
  bool get adminHabilitado => usuarioAtual.nome.isNotEmpty && usuarioAtual.administrador;
}
