import 'package:flutter/material.dart';
import '../domain/transacao.dart'; // Importa a classe modelo
import '../db/transacao_dao.dart'; // Importa a classe que insere no banco

class TelaCadastro extends StatefulWidget { // stateful porque o usuario digita e clica em botoes
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>(); // chave de segurança  para validar se o formulario está preenchido
  final _tituloController = TextEditingController(); // puxa o text digitado no campo de titulo
  final _valorController = TextEditingController(); // puxa o texto digitado no campo de valor

  bool _isEntrada = false; // armazena a escolha de ser saida (false) ou entrada (true)
  String _categoriaSelecionada = 'Alimentação'; // categoria inicial do dropdown

  // lista com as opçoes de categoria para o usuario escolher
  final List<String> _categorias = ['Alimentação', 'Roupas', 'Transporte', 'Lazer', 'Pix/Transferência', 'Salário', 'Outros'];

  void _salvar() async { // funcao acionada ao clicar em cadastrar
    if (_formKey.currentState!.validate()) { // verifica se os validadores passarram (textos nao vazios)

      final novaTransacao = Transacao( // monsta o "molde" com tudo o que foi digitado
        titulo: _tituloController.text, // pega o texto
        valor: double.parse(_valorController.text.replaceAll(',', '.')), // converte a string de dinheiro por numero, trocando ',' por '.'
        isEntrada: _isEntrada, // pega a escolha do botão
        categoria: _categoriaSelecionada, // pega a categoria selecionada
        data: DateTime.now(), // grava o exato milissegundo do clique
      );

      await TransacaoDao().inserir(novaTransacao); // manda salvar no bando e espera

      _tituloController.clear(); // limpa o texto da tela
      _valorController.clear(); // limpa o valor da tela

      if (mounted) { // checa se a tela ainda existe antes de mostrar a mensagem
        ScaffoldMessenger.of(context).showSnackBar( // mostra o banner preto avisando sucesso
          const SnackBar(content: Text('Transação salva no Banco de Dados!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) { // permite que a tela tenha "rolagem" se o teclado cobrir a tela
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form( // componente agrupador do formulario
        key: _formKey, // conecta a chave do form
        child: Column(  // empilha de cima para baixo
          crossAxisAlignment: CrossAxisAlignment.stretch, // estica o botoes para a largura toda
          children: [
            const Text('Nova Transação', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Row( // linha com duas bolinha (radio buttons)
              children: [
                Expanded( // divide a largura pela metade
                  child: RadioListTile<bool>( // opção saida
                    title: const Text('Saída', style: TextStyle(color: Colors.red)),
                    value: false, // valor associado a esse botao
                    groupValue: _isEntrada, c
                    onChanged: (val) => setState(() => _isEntrada = val!), // Atualiza quando clicado
                  ),
                ),
                Expanded( // divide pela metade
                  child: RadioListTile<bool>( // opção entrada
                    title: const Text('Entrada', style: TextStyle(color: Colors.green)),
                    value: true, // valor associado a esse botao
                    groupValue: _isEntrada, // valor associado a variavel _isEntrada
                    onChanged: (val) => setState(() => _isEntrada = val!), // Atualiza quando clicado
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField( // campo de digitar texto (titulo)
              controller: _tituloController, // O controlador capta o que foi digitado
              decoration: const InputDecoration(labelText: 'Descrição (Ex: Lanche, Roupa)', border: OutlineInputBorder()),
              // impede que o usuario envie o formulario com esse campo vazio
              validator: (value) => value == null || value.isEmpty ? 'Informe a descrição' : null,
            ),
            const SizedBox(height: 16),

            TextFormField( // campo de digitar texto (valor)
              controller: _valorController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true), // Força abrir o teclado numerico
              decoration: const InputDecoration(labelText: 'Valor (R\$)', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe o valor'; // não deixa ficar vazio
                if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Valor inválido'; // verifica se digitaram letras em vez de numeros
                return null; // deu tudo certo
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>( // Caixa de clicar e abrir opções (Categorias)
              value: _categoriaSelecionada, // Opção escolhida no momento
              decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
              items: _categorias.map((cat) { // Transforma a lista de Strings lá de cima em itens visuais
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) { // Quando o usuário troca a categoria...
                setState(() {
                  _categoriaSelecionada = val!; // ...salvamos na variável
                });
              },
            ),
            const SizedBox(height: 24),

            ElevatedButton( // O Botão final de salvar
              onPressed: _salvar, // Aciona a lógica criada lá no começo
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16), // Aumenta a altura do botão
                backgroundColor: Theme.of(context).colorScheme.primary, // Aumenta a altura do botão
                foregroundColor: Colors.white, // Cor do texto
              ),
              child: const Text('CADASTRAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}