import 'package:flutter/material.dart'; // Pacote base de visual do Flutter
import 'screens/tela_principal.dart'; // Importa a tela inicial

void main() { // função principal
  runApp(const MyApp()); // roda o widget raiz o app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Construtor padrão

  @override
  Widget build(BuildContext context) { // Constrói o visual base
    return MaterialApp( // Aplica o design Material (padrão Google)
      title: 'Cofrinho', // Título interno do app
      debugShowCheckedModeBanner: false, // Remove a faixa chata de debug da tela
      theme: ThemeData( // Define as cores e fontes do aplicativo
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), // Cor base: Teal (verde-azulado)
        useMaterial3: true, // Usa os componentes visuais mais modernos do Flutter
      ),
      home: const TelaPrincipal(), // Define que a primeira tela ao abrir o app é a TelaPrincipal
    );
  }
}
