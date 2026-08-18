import 'package:flutter/material.dart';
import 'tela_resumo.dart'; // import tela 1
import 'tela_extrato.dart'; // import tela 2
import 'tela_cadastro.dart'; // import tela 3

class TelaPrincipal extends StatefulWidget { // porque a tela vai mudar
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _indiceAtual = 0; // variavel que guarda qual aba esta selecionada

  @override
  Widget build(BuildContext context) { // cria uma lista com as três telas do app
    final List<Widget> telas = [
      const TelaResumo(),
      const TelaExtrato(),
      const TelaCadastro(),
    ];

    return Scaffold( // cria o layout padrao
      appBar: AppBar( // cabeçalho o app
        title: const Text('Meu Cofrinho'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: telas[_indiceAtual], // o corpo do app exibe a tela correspondente ao numero do _indiceatual
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual, // mostra visualmente qual botal esta ativado
        onTap: (index) { // quando o usuario toca num botao...
          setState(() { // ...avisa o flutter para reconstruir a tela...
            _indiceAtual = index; // ...e atualiza a variavel com o numero do novo botão clicado
          });
        },
        items: const [ // icones da barra inferior
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Extrato'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Cadastrar'),
        ],
      ),
    );
  }
}