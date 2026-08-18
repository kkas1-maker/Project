class Transacao { // define o "molde" para as transações
  int? id; // ? opcional
  late String titulo; // variavel late ( inicializada depois)
  late double valor; // variavel late ( inicializada depois)
  late bool isEntrada; // variavel late ( inicializada depois)
  late String categoria; // variavel late ( inicializada depois)
  late DateTime data; // variavel late ( inicializada depois)

  Transacao({ // construtor padrao: exige que passe os dados ao criar uma nova transação
    this.id, // nao tem required porque o banco gera sozinho
    required this.titulo,
    required this.valor,
    required this.isEntrada,
    required this.categoria,
    required this.data,
  });

  // pega um mapa(JSON vindo do sqlite) e transforma no objeto transação
  Transacao.fromJson(Map<String, dynamic> json) {
    id = json['id']; // Pega o número do mapa e salva no ID
    titulo = json['titulo']; // Pega o texto do mapa e salva no titulo
    valor = json['valor']; // Pega o número decimal do mapa e salva no valor
    isEntrada = json['isEntrada'] == 1; // Se no banco for o número 1, vira true. Se não, false.
    categoria = json['categoria']; // Pega o texto do mapa e salva na categoria
    data = DateTime.parse(json['data']); // Converte o texto do banco de volta para o formato de Data do Dart

  // Função que pega o objeto Transacao e converte num Mapa para salvar no SQLite
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {}; // cria um mapa vazio
    json['id'] = id; // guarda o ID no mapa
    json['titulo'] = titulo;
    json['valor'] = valor;
    json['isEntrada'] = isEntrada ? 1 : 0;
    json['categoria'] = categoria;
    json['data'] = data.toIso8601String();

    return json; // devolve o mapa pronto para ser gravado no banco de dados
  }
}