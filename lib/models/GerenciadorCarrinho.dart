import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/models/Carrinho.dart';
import 'package:loja_virtual/models/Endereco.dart';
import 'package:loja_virtual/models/GerenciadorUsuarios.dart';
import 'package:loja_virtual/models/Produto.dart';
import 'package:loja_virtual/models/Usuario.dart';
import 'package:loja_virtual/servicos/CepAbertoService.dart';

class GerenciadorCarrinho extends ChangeNotifier {
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;

  List<Carrinho> itens = [];
  Usuario? usuario;
  Endereco? endereco;
  num precoProdutos = 0.0;
  num? precoEntrega;

  bool _carregando = false;

  bool get carregando => _carregando;
  set carregando(bool value) {
    _carregando = value;
    notifyListeners();
  }

  num get precoTotal => precoProdutos + (precoEntrega ?? 0);
  bool get enderecoValido => endereco != null && precoEntrega != null;

  void atualizarUsuario(GerenciadorUsuarios gerenciadorUsuario) {
    usuario = gerenciadorUsuario.usuarioAtual;
    precoProdutos = 0.0;
    itens.clear();
    removerEndereco();

    if (usuario != null) {
      _carregarItensCarrinho();
      _carregarEnderecoUsuario();
    }
  }

  Future<void> _carregarItensCarrinho() async {
    final QuerySnapshot carrinhoSnap = await usuario!.carrinhoReference.get();

    itens = carrinhoSnap.docs
        .map((d) => Carrinho.fromDocument(d)..addListener(_itemAtualizado))
        .toList();
  }

  Future<void> _carregarEnderecoUsuario() async {
    if (usuario!.endereco != null &&
        await calcularEntrega(
            usuario!.endereco!.lat!, usuario!.endereco!.long!)) {
      endereco = usuario!.endereco;
      notifyListeners();
    }
  }

  void adicionarAoCarrinho(Produto produto) {
    try {
      final e = itens.firstWhere((p) => p.empilhavel(produto));
      e.incremente();
    } catch (e) {
      final carrinho = Carrinho.fromProduto(produto);

      carrinho.addListener(_itemAtualizado);
      itens.add(carrinho);
      usuario!.carrinhoReference
          .add(carrinho.toMap())
          .then((doc) => carrinho.id = doc.id);
      _itemAtualizado();
    }
    notifyListeners();
  }

  void removerProdutoCarrinho(Carrinho produtoCarrinho) {
    itens.removeWhere((p) => p.id == produtoCarrinho.id);
    usuario!.carrinhoReference.doc(produtoCarrinho.id).delete();
    produtoCarrinho.removeListener(_itemAtualizado);
    notifyListeners();
  }

  void limpar() {
    for(final cartProduct in itens){
      usuario!.carrinhoReference.doc(cartProduct.id).delete();
    }
    itens.clear();
    notifyListeners();
  }

  void _itemAtualizado() {
    try {
      precoProdutos = 0.0;
      for (int i = 0; i < itens.length; i++) {
        final carrinhoProduto = itens[i];

        if (carrinhoProduto.quantidade == 0) {
          removerProdutoCarrinho(carrinhoProduto);
          i--;
          continue;
        } else {
          precoProdutos += carrinhoProduto.precoTotal;
          _atualizarCarrinho(carrinhoProduto);
        }
      }
    } catch (erro) {}

    notifyListeners();
  }

  void _atualizarCarrinho(Carrinho carrinhoProduto) {
    if (carrinhoProduto.id != null) {
      usuario!.carrinhoReference
          .doc(carrinhoProduto.id)
          .update(carrinhoProduto.toMap());
    }
  }

  bool get carrinhoValido {
    for (final carrinhoProduto in itens) {
      if (!carrinhoProduto.temEstoque) return false;
    }
    return true;
  }

  Future<void> getEndereco(String cep) async {
    carregando = true;
    final cepAbertoService = CepAbertoService();

    try {
      final cepAbertoEndereco = await cepAbertoService.getEnderecoCep(cep);

      if (cepAbertoEndereco != null) {
        endereco = Endereco(
            rua: cepAbertoEndereco.logradouro,
            distrito: cepAbertoEndereco.bairro,
            zipCode: cepAbertoEndereco.cep,
            cidade: cepAbertoEndereco.cidade.nome,
            estado: cepAbertoEndereco.estado.sigla,
            lat: cepAbertoEndereco.latitude,
            long: cepAbertoEndereco.longitude);
      }
      carregando = false;
    } catch (e) {
      carregando = false;
      return Future.error('CEP Inv??lido');
    }
  }

  Future<void> setEndereco(Endereco endereco) async {
    carregando = true;
    this.endereco = endereco;

    await calcularEntrega(endereco.lat!, endereco.long!);

    if (await calcularEntrega(endereco.lat!, endereco.long!)) {
      usuario!.setEndereco(endereco);
      carregando = false;
    } else {
      carregando = false;
      return Future.error('Endere??o fora do raio de entrega');
    }
  }

  void removerEndereco() {
    endereco = null;
    precoEntrega = null;
    notifyListeners();
  }

  Future<bool> calcularEntrega(double lat, double long) async {
    //Pegando dados de localizacao da loja:
    final DocumentSnapshot documentSnapshot =
        await bancoDados.doc('aux/entrega').get();

    Map<String, dynamic> dados =
        documentSnapshot.data() as Map<String, dynamic>;

    final latStore = dados["lat"] as double;
    final longStore = dados['long'] as double;
    final precoBase = dados['base'] as num;
    final precoPorKm = dados['km'] as num;
    final maxkm = dados['maxkm'] as num;

    //Distancia em linha reta:
    double dis = Geolocator.distanceBetween(latStore, longStore, lat, long);
    dis /= 1000.0;

    if (dis > maxkm) {
      return false;
    }
    precoEntrega = precoBase + dis * precoPorKm;
    return true;
  }
}
