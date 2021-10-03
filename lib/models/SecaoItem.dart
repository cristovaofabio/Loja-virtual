class SecaoItem {
  late String imagem;
  String? produto;

  SecaoItem({required this.imagem, this.produto});

  SecaoItem clone(){
    return SecaoItem(
      imagem: imagem,
      produto: produto,
    );
  }

  SecaoItem.fromMap(Map<String, dynamic> map){
    imagem = map['imagem'] as String;
    produto = map['produto'] as String;
  }

  @override
  String toString() {
    return 'SecaoItem{imagem: $imagem, produto: $produto}';
  }
}