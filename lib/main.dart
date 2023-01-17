import 'package:flutter/material.dart';
import 'package:jogo_da_velha/core/constantes.dart';
import 'package:jogo_da_velha/pages/inicial.dart';
import 'package:jogo_da_velha/core/tema.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: NOME_JOGO,
      theme: temaApp,
      home: const PaginaInicial(),
    );
  }
}
