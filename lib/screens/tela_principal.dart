import 'package:flutter/material.dart';
import 'tela_resumo.dart';
import 'tela_extrato.dart';
import 'tela_cadastro.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> telas = [
      const TelaResumo(),
      const TelaExtrato(),
      const TelaCadastro(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Cofrinho'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) {
          setState(() {
            _indiceAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Extrato'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Cadastrar'),
        ],
      ),
    );
  }
}
