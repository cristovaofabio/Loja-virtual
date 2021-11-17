import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:loja_virtual/helper/FirebaseErros.dart';
import 'package:loja_virtual/models/Usuario.dart';

class GerenciadorUsuarios extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  Usuario usuarioAtual = Usuario();

  GerenciadorUsuarios() {
    usuarioAtual.nome = "";
    _carregarUsuarioAtual();
  }

  bool _carregando = false;
  bool get carregando => _carregando;
  set carregando(bool value){
    _carregando = value;
    notifyListeners();
  }

  bool _carregandoFace = false;
  bool get carregandoFace => _carregandoFace;
  set carregandoFace(bool value){
    _carregandoFace = value;
    notifyListeners();
  }

  Future<void> entrar(
      {required Usuario usuario,
      required Function fracasso,
      required Function sucesso}) async {

    carregando = true;
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
    carregando = false;
  }

  Future<void> loginFacebook({Function? onFail, Function? onSuccess}) async {
    carregandoFace = true;

    final result = await FacebookLogin().logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final credential =
            FacebookAuthProvider.credential(result.accessToken.token);

        final authResult = await auth.signInWithCredential(credential);

        if (authResult.user != null) {
          final firebaseUser = authResult.user;

          usuarioAtual = Usuario();
          usuarioAtual.idUsuario = firebaseUser!.uid;
          usuarioAtual.nome = firebaseUser.displayName!;
          usuarioAtual.email = firebaseUser.email!;

          await usuarioAtual.salvarDados();

          usuarioAtual.salvarToken();

          onSuccess!();
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        onFail!(result.errorMessage);
        break;
    }

    carregandoFace = true;
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
    carregando = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);

      usuario.idUsuario = userCredential.user!.uid;

      await usuario.salvarDados();
      this.usuarioAtual = usuario;

      usuarioAtual.salvarToken();

      sucesso();
    } on FirebaseAuthException catch (erro) {
      fracasso(getErrorString(erro.code));
    }
    carregando = false;
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

      usuarioAtual.salvarToken();

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
  bool get adminHabilitado =>
      usuarioAtual.nome.isNotEmpty && usuarioAtual.administrador;
}
