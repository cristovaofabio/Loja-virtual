class TamanhoItem {
  String? nome;
  num? preco;
  int? estoque;

  TamanhoItem({this.nome, this.preco, this.estoque});

  TamanhoItem.fromMap(Map<String, dynamic> map) {
    this.nome = map['nome'] as String;
    this.preco = map['preco'] as num;
    this.estoque = map['estoque'] as int;
  }

  Map<String, dynamic> toMap() {
    return {
      'nome'    : nome,
      'preco'   : preco,
      'estoque' : estoque,
    };
  }

  bool get hasStock => estoque! > 0;

  TamanhoItem clone() {
    return TamanhoItem(
      nome: nome,
      preco: preco,
      estoque: estoque,
    );
  }

  @override
  String toString() {
    return 'TamanhoItem{nome: $nome, preco: $preco, estoque: $estoque}';
  }
}
