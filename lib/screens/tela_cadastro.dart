import 'package:flutter/material.dart';
import '../domain/transacao.dart';
import '../db/transacao_dao.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _valorController = TextEditingController();

  bool _isEntrada = false;
  String _categoriaSelecionada = 'Alimentação';

  final List<String> _categorias = ['Alimentação', 'Roupas', 'Transporte', 'Lazer', 'Pix/Transferência', 'Salário', 'Outros'];

  void _salvar() async {
    if (_formKey.currentState!.validate()) {

      final novaTransacao = Transacao(
        titulo: _tituloController.text,
        valor: double.parse(_valorController.text.replaceAll(',', '.')),
        isEntrada: _isEntrada,
        categoria: _categoriaSelecionada,
        data: DateTime.now(),
      );

      await TransacaoDao().inserir(novaTransacao);

      _tituloController.clear();
      _valorController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transação salva no Banco de Dados!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Nova Transação', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Saída', style: TextStyle(color: Colors.red)),
                    value: false,
                    groupValue: _isEntrada, 
                    onChanged: (val) => setState(() => _isEntrada = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Entrada', style: TextStyle(color: Colors.green)),
                    value: true,
                    groupValue: _isEntrada,
                    onChanged: (val) => setState(() => _isEntrada = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Descrição (Ex: Lanche, Roupa)', border: OutlineInputBorder()),
              validator: (value) => value == null || value.isEmpty ? 'Informe a descrição' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _valorController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true), //abre o numpad
              decoration: const InputDecoration(labelText: 'Valor (R\$)', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe o valor';
                if (double.tryParse(value.replaceAll(',', '.')) == null) return 'Valor inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _categoriaSelecionada,
              decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
              items: _categorias.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _categoriaSelecionada = val!;
                });
              },
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _salvar,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('CADASTRAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
