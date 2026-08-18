import 'package:flutter/material.dart';
import '../domain/transacao.dart';
import '../db/transacao_dao.dart';

class TelaResumo extends StatefulWidget {
  const TelaResumo({super.key});

  @override
  State<TelaResumo> createState() => _TelaResumoState();
}

class _TelaResumoState extends State<TelaResumo> {
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

    double totalEntradas = 0;
    double totalSaidas = 0;

    for (var t in listaTransacoes) {
      if (t.isEntrada) {
        totalEntradas += t.valor;
      } else {
        totalSaidas += t.valor;
      }
    }

    double saldo = totalEntradas - totalSaidas;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Resumo Financeiro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _construirCard('Saldo Atual', saldo, saldo >= 0 ? Colors.blue : Colors.red, Icons.account_balance_wallet),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _construirCard('Entradas', totalEntradas, Colors.green, Icons.arrow_upward)),
              const SizedBox(width: 16),
              Expanded(child: _construirCard('Saídas', totalSaidas, Colors.redAccent, Icons.arrow_downward)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _construirCard(String titulo, double valor, Color cor, IconData icone) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 32),
            const SizedBox(height: 8),
            Text(titulo, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 4),
            Text('R\$ ${valor.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cor),
            ),
          ],
        ),
      ),
    );
  }
}