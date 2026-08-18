import 'package:sqflite/sqflite.dart'; // Importa as ferramentas nativas do SQLite
import '../db/db_helper.dart'; // Importa a nossa classe que sabe abrir o banco
import '../domain/transacao.dart'; // Importa a classe modelo de Transação

class TransacaoDao { // cria a classe que concentra as regras de acesso a dados

  // função assíncrona que recebe uma transação e a salva no banco
  Future<int> inserir(Transacao transacao) async {
    Database db = await DBHelper().initDB(); // pede para o DBhelper abrir o banco e aguarda
    return await db.insert('transacoes', transacao.toJson()); // Usa a função nativa 'insert' passando o objeto convertido (toJson)
  }

  // função assíncrona que busca tudo no banco e devolve uma lista de transações
  Future<List<Transacao>> listarTodas() async {
    Database db = await DBHelper().initDB(); // Abre o banco e aguarda
    // Faz a consulta (SELECT) na tabela, ordenando pelo ID do maior pro menor (DESC = Decrescente)
    final List<Map<String, dynamic>> mapas = await db.query('transacoes', orderBy: 'id DESC');

    List<Transacao> listaTransacoes = []; // Cria uma lista vazia para guardar os resultados
    for (var mapa in mapas) { // Laço de repetição que passa por cada item retornado pelo banco
      listaTransacoes.add(Transacao.fromJson(mapa)); // Converte cada item em Transacao e adiciona na lista
    }

    return listaTransacoes;// Retorna a lista final cheia para a tela que a solicitou
  }
}