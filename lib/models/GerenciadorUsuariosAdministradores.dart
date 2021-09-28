import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Usuario.dart';

class GerenciadorUsuariosAdministradores extends ChangeNotifier {
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  List<Usuario> usuarios = [];
  StreamSubscription? _subscription;

  void atualizarUsuario(GerenciadorUsuarios gerenciadorUsuarios) {
    _subscription?.cancel();
    if (gerenciadorUsuarios.adminHabilitado) {
      _ouvinteParaUsuarios();
    } else {
      usuarios.clear();
      notifyListeners();
    }
  }

  void _ouvinteParaUsuarios() {
    _subscription = bancoDados.collection('usuarios').snapshots().listen(
      (snapshot){
        usuarios = snapshot.docs.map(
          (documentSnapshot) => Usuario.fromDocumentSnapshot(documentSnapshot)
        ).toList();

        //Ordenar lista por ordem alfabética:
        usuarios.sort(
          (usuario1, usuario2) => usuario1.nome.toLowerCase().compareTo(usuario2.nome.toLowerCase())
        );

        notifyListeners();
      }
    );
  }

  List<String> get nomes => usuarios.map((usuario) => usuario.nome).toList();
  
  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}