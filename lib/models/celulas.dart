import 'package:flutter/material.dart';

class Celula {
  final int id;
  String simbolo;
  Color cor;
  bool vazio;

  Celula(this.id,
      {this.simbolo = '', this.cor = Colors.black87, this.vazio = true});

  /* Essa função recebe os dados do jogador para ela seja
  marcada como uma célula que recebeu uma jogada */
  void receberJogada(String simboloJogador, Color corJogador) {
    simbolo = simboloJogador;
    cor = corJogador;
    vazio = false;
  }
}
