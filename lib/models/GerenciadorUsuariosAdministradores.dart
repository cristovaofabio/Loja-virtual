import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Usuario.dart';
import 'package:faker/faker.dart';

class GerenciadorUsuariosAdministradores extends ChangeNotifier{

  List<Usuario> usuarios = [];

  void atualizarUsuario(GerenciadorUsuarios gerenciadorUsuarios){
    if(gerenciadorUsuarios.adminHabilitado){
      _ouvinteParaUsuarios();
    }
  }

  void _ouvinteParaUsuarios(){
    var faker = new Faker();

    for(int i = 0; i < 100; i++){
      Usuario usuario = Usuario();
      usuario.nome = faker.person.name();
      usuario.email = faker.internet.email();
      usuarios.add(usuario);
    }
    //Ordenar lista por ordem alfabética:
    usuarios.sort((usuario1, usuario2) => usuario1.nome.toLowerCase().compareTo(usuario2.nome.toLowerCase()));

    notifyListeners();
  }

  List<String> get nomes => usuarios.map((usuario) => usuario.nome).toList();

}