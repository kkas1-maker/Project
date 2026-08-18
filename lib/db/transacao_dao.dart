import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';
import '../domain/transacao.dart';

class TransacaoDao {
  Future<int> inserir(Transacao transacao) async {
    Database db = await DBHelper().initDB();
    return await db.insert('transacoes', transacao.toJson());
  }

  Future<List<Transacao>> listarTodas() async {
    Database db = await DBHelper().initDB();
    final List<Map<String, dynamic>> mapas = await db.query('transacoes', orderBy: 'id DESC');

    List<Transacao> listaTransacoes = [];
    for (var mapa in mapas) {
      listaTransacoes.add(Transacao.fromJson(mapa));
    }

    return listaTransacoes;
  }
}