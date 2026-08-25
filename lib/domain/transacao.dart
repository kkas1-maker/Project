class Transacao {
  int? id;
  late String titulo;
  late double valor;
  late bool isEntrada;
  late String categoria;
  late DateTime data;

  Transacao({
    this.id,
    required this.titulo,
    required this.valor,
    required this.isEntrada,
    required this.categoria,
    required this.data,
  });

  // Converte o Map vindo do SQLite para o objeto Transacao
  Transacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    valor = json['valor'];
    isEntrada = json['isEntrada'] == 1;
    categoria = json['categoria'];
    data = DateTime.parse(json['data']);
  }

  // Converte o objeto Transacao para Map para salvar no SQLite
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    if (id != null) jsonMap['id'] = id;
    jsonMap['titulo'] = titulo;
    jsonMap['valor'] = valor;
    jsonMap['isEntrada'] = isEntrada ? 1 : 0;
    jsonMap['categoria'] = categoria;
    jsonMap['data'] = data.toIso8601String();
    return jsonMap;
  }
}
