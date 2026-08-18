import 'package:flutter/material.dart';
import '../domain/transacao.dart'; // Importa o molde de transação
import '../db/transacao_dao.dart'; // Importa as funções de banco

class TelaResumo extends StatefulWidget { // porque o saldo vai ser atualizado
  const TelaResumo({super.key});

  @override
  State<TelaResumo> createState() => _TelaResumoState();
}

class _TelaResumoState extends State<TelaResumo> {
  List<Transacao> listaTransacoes = []; // lista vazia que vai receber os dados do banco
  bool isLoading = true; // variavel que diz se a tela ainda esá carregando os dados

  @override
  void initState() { // função que roda antes a tela ser desenhada pela primeira vez
    super.initState();
    loadData(); // chama a função que busca os dados
  }

  loadData() async { // função que busca no banco
    listaTransacoes = await TransacaoDao().listarTodas(); // pede os dados para o dao e aguarda
    setState(() { // apos os dados chegarem, avisa o flutter para atualizar a tela
      isLoading = false; // diz que terminou de carregar
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) { // se ainda estiver carregando...
      return const Center(child: CircularProgressIndicator()); // ...mostra a bolinha de loading
    }

    // Variáveis zeradas para a matemática
    double totalEntradas = 0;
    double totalSaidas = 0;

    for (var t in listaTransacoes) { // Passa por todas as transações que chegaram do banco
      if (t.isEntrada) { // Se for entrada...
        totalEntradas += t.valor; // ...soma o valor na caixinha de entradas
      } else { // Se for saída...
        totalSaidas += t.valor; // ...soma o valor na caixinha de saídas
      }
    }

    double saldo = totalEntradas - totalSaidas; // faz a conta matematica oo saldo final

    return Padding( // adiciona um respiro em volta de tudo (margem interna)
      padding: const EdgeInsets.all(16.0),
      child: Column( // empilha de cima para baixo
        crossAxisAlignment: CrossAxisAlignment.stretch, // estica os itens para preencher a largura da tela
        children: [
          const Text('Resumo Financeiro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16), // espaço vazio

          // Desenha o Card grande do Saldo (usando a nossa função personalizada abaixo)
          _construirCard('Saldo Atual', saldo, saldo >= 0 ? Colors.blue : Colors.red, Icons.account_balance_wallet),
          const SizedBox(height: 16),

          Row( // coloca as entradas e saidas lado a lado
            children: [
              Expanded(child: _construirCard('Entradas', totalEntradas, Colors.green, Icons.arrow_upward)), // pega 50% do espaço
              const SizedBox(width: 16), // espaço no meio
              Expanded(child: _construirCard('Saídas', totalSaidas, Colors.redAccent, Icons.arrow_downward)), // pega 50% do espaço
            ],
          ),
        ],
      ),
    );
  }
  // Função criada para gerar o visual de um Card. Evita repetir código três vezes.
  Widget _construirCard(String titulo, double valor, Color cor, IconData icone) {
    return Card( // componente visual do cartao
      elevation: 4, // da um leve efeito 3d (sombra)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // deixa as pontas arredondadas
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 32), // mostra o icone
            const SizedBox(height: 8),
            Text(titulo, style: const TextStyle(fontSize: 16, color: Colors.grey)), // mostra o titulo (ex: entradas)
            const SizedBox(height: 4),
            Text('R\$ ${valor.toStringAsFixed(2)}', // pega o valor, formata para ter 2 casas decimais (ex: 10.50) e adiciona o R$
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: cor),
            ),
          ],
        ),
      ),
    );
  }
}