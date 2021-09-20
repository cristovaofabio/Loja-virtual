class TamanhoItem {

  String? nome;
  num? preco;
  int? estoque;

  TamanhoItem();

  TamanhoItem.fromMap(Map<String, dynamic> map){
    this.nome = map['nome'] as String;
    this.preco = map['preco'] as num;
    this.estoque = map['estoque'] as int;
  }

  bool get hasStock => estoque! > 0;

  @override
  String toString() {
    return 'TamanhoItem{nome: $nome, preco: $preco, estoque: $estoque}';
  }
}