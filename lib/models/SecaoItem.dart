class SecaoItem {
  late String imagem;

  SecaoItem.fromMap(Map<String, dynamic> map){
    imagem = map['imagem'] as String;
  }

  @override
  String toString() {
    return 'SecaoItem{imagem: $imagem}';
  }
}