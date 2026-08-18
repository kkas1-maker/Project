import 'package:flutter/material.dart';
import '../domain/transacao.dart'; // Importa a classe Transacao
import '../db/transacao_dao.dart'; // Importa a classe DAO

class TelaExtrato extends StatefulWidget { // stateful para atualizar a lista
  const TelaExtrato({super.key});

  @override
  State<TelaExtrato> createState() => _TelaExtratoState();
}

class _TelaExtratoState extends State<TelaExtrato> {
  List<Transacao> listaTransacoes = []; // guarda os dados do banco
  bool isLoading = true; // controla o indicador de carregamento

  @override
  void initState() { // roda quando a tela é aberta
    super.initState();
    loadData(); // aciona a busca no banco
  }

  loadData() async {
    listaTransacoes = await TransacaoDao().listarTodas(); // busca no sqlite
    setState(() { // atualiza a tela
      isLoading = false; // desliga o carregamento
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) { // se estiver carregando...
      return const Center(child: CircularProgressIndicator()); // ...bolinha de loading
    }

    if (listaTransacoes.isEmpty) { // se for vazia...
      return const Center(child: Text('Nenhuma transação registrada.')); //...
    }

    // se estiver dados, constroi a lista dinamica (item por item)
    return ListView.builder(
      itemCount: listaTransacoes.length, // quanto item ele deve desenhar? (tamanho da lista)
      itemBuilder: (context, i) { // regra de como desenhar cada item
        final t = listaTransacoes[i]; // pega a transação exata baseada na posição (i)

        return Card( // cria o fundo branco levemente sombreado do item
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile( // layout para linhas de lista
            leading: CircleAvatar( // icone circular à esquerda
              backgroundColor: t.isEntrada ? Colors.green[100] : Colors.red[100], // Fundo verde claro ou vermelho claro
              child: Icon(
                t.isEntrada ? Icons.arrow_upward : Icons.arrow_downward, // Seta pra cima ou pra baixo
                color: t.isEntrada ? Colors.green : Colors.red,
              ),
            ),
            title: Text(t.titulo, style: const TextStyle(fontWeight: FontWeight.bold)), // titulo principal (nome da transação
            subtitle: Text('${t.categoria} • ${t.data.day}/${t.data.month}/${t.data.year}'), // texto abaixo do titulo com categoria e data
            trailing: Text( // elemento na extema direita
              'R\$ ${t.valor.toStringAsFixed(2)}', // valor em reais formatado
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: t.isEntrada ? Colors.green : Colors.red, // verde para ganho, vermelho para gasto
              ),
            ),
          ),
        );
      },
    );
  }
}