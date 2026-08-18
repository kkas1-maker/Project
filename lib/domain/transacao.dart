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

  Transacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    valor = json['valor'];
    isEntrada = json['isEntrada'] == 1;
    categoria = json['categoria'];
    data = DateTime.parse(json['data']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['titulo'] = titulo;
    json['valor'] = valor;
    json['isEntrada'] = isEntrada ? 1 : 0;
    json['categoria'] = categoria;
    json['data'] = data.toIso8601String();

    return json;
  }
}