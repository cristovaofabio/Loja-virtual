import 'package:flutter/material.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/telas/produtos/componentes/FormularioImagem.dart';
import 'package:loja_virtual/telas/produtos/componentes/FormularioTamanhos.dart';
import 'package:loja_virtual/util/BotaoCustomizado.dart';

class TelaEditarProduto extends StatelessWidget {
  final Produto produto;
  final bool editando;

  TelaEditarProduto(Produto? p)
      : editando = p != null,
        produto = p != null ? p.clone() : Produto();

  final _chave = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Produto' : 'Criar Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _chave,
        child: ListView(
          children: <Widget>[
            FormularioImagem(this.produto),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    initialValue: produto.nome,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (nome) {
                      if (nome!.length < 6) return 'Título muito curto';
                      return null;
                    },
                    onSaved: (nome) => produto.nome = nome,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ...',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: temaPadrao.primaryColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: TextFormField(
                      initialValue: produto.descricao,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        labelText: 'Descrição',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      validator: (desc) {
                        if (desc!.length < 10) return 'Descrição muito curta';
                      },
                      onSaved: (desc) => produto.descricao = desc,
                    ),
                  ),
                  FormularioTamanho(produto: produto),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 44,
                    child: BotaoCustomizado(
                      texto: "Salvar",
                      onPressed: () {
                        if (_chave.currentState!.validate()) {
                          _chave.currentState!.save();

                          print(produto);
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
