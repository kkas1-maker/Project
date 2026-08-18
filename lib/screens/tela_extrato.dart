import 'package:flutter/material.dart';
import '../domain/transacao.dart';
import '../db/transacao_dao.dart';

class TelaExtrato extends StatefulWidget {
  const TelaExtrato({super.key});

  @override
  State<TelaExtrato> createState() => _TelaExtratoState();
}

class _TelaExtratoState extends State<TelaExtrato> {
  List<Transacao> listaTransacoes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    listaTransacoes = await TransacaoDao().listarTodas();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (listaTransacoes.isEmpty) {
      return const Center(child: Text('Nenhuma transação registrada.'));
    }

    return ListView.builder(
      itemCount: listaTransacoes.length,
      itemBuilder: (context, i) {
        final t = listaTransacoes[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: t.isEntrada ? Colors.green[100] : Colors.red[100],
              child: Icon(
                t.isEntrada ? Icons.arrow_upward : Icons.arrow_downward,
                color: t.isEntrada ? Colors.green : Colors.red,
              ),
            ),
            title: Text(t.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${t.categoria} • ${t.data.day}/${t.data.month}/${t.data.year}'),
            trailing: Text(
              'R\$ ${t.valor.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: t.isEntrada ? Colors.green : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}