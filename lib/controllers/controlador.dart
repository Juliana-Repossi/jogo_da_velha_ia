import 'dart:ffi';

import 'package:jogo_da_velha/models/celulas.dart';
import 'package:jogo_da_velha/enums/jogadores.dart';
import 'package:jogo_da_velha/core/constantes.dart';
import 'package:jogo_da_velha/core/como_vencer.dart';
import 'package:jogo_da_velha/enums/ganhador.dart';

class Jogo {
  List<Celula> tabuleiro = [];
  List<List<String>> _board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];
  List<int> movJogador1 = [];
  List<int> movJogador2 = [];
  Jogador? jogadorDaVez;
  bool? modoUmJogador;

  String _ai = 'O';
  String _human = 'X';

  final Map<String, int> _scores = {'X': 1, 'O': -1, 'tie': 0};

  Jogo() {
    inicializarJogo();
  }

  bool equals3(a, b, c) {
    return a == b && b == c && a != '';
  }

  String checkWinner() {
    String winner = 'null';

    // horizontal
    for (int i = 0; i < 3; i++) {
      if (equals3(_board[i][0], _board[i][1], _board[i][2])) {
        winner = _board[i][0];
      }
    }

    // Vertical
    for (int i = 0; i < 3; i++) {
      if (equals3(_board[0][i], _board[1][i], _board[2][i])) {
        winner = _board[0][i];
      }
    }

    // Diagonal
    if (equals3(_board[0][0], _board[1][1], _board[2][2])) {
      winner = _board[0][0];
    }
    if (equals3(_board[2][0], _board[1][1], _board[0][2])) {
      winner = _board[2][0];
    }

    int openSpots = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          openSpots++;
        }
      }
    }

    if (winner == 'null' && openSpots == 0) {
      return 'tie';
    } else {
      return winner;
    }
  }

  int _bestMove() {
    // AI to make its turn
    int bestScore = 9999999;
    Map<String, int> move = {};
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        // Is the spot available?
        if (_board[i][j] == '') {
          _board[i][j] = _ai;
          int score = minimax(_board, 0, false);
          _board[i][j] = '';
          if (score < bestScore) {
            bestScore = score;
            move = {"i": i, "j": j};
          }
        }
      }
    }
    _board[move["i"]!][move["j"]!] = _ai;
    return (move['i']! * 3) + move['j']!;
  }

  int minimax(List<List<String>> board, int depth, bool isMaximizing) {
    String result = checkWinner();
    if (result != 'null') {
      return _scores[result]!;
    }

    if (isMaximizing) {
      int bestScore = -9999999;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          // Is the spot available?
          if (board[i][j] == '') {
            board[i][j] = _ai;
            int score = minimax(board, depth + 1, false).toInt();
            board[i][j] = '';
            score > bestScore ? bestScore = score : bestScore = bestScore;
          }
        }
      }
      return bestScore;
    } else {
      int bestScore = 9999999;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          // Is the spot available?
          if (board[i][j] == '') {
            board[i][j] = _human;
            int score = minimax(board, depth + 1, true);
            board[i][j] = '';
            score < bestScore ? bestScore = score : bestScore = bestScore;
          }
        }
      }
      return bestScore;
    }
  }

  void inicializarJogo() {
    //limpar as jogadas
    movJogador1.clear();
    movJogador2.clear();
    //colocar a vez pro jogador um
    jogadorDaVez = Jogador.jogador1;
    modoUmJogador = false;
    _board = [
      ['', '', ''],
      ['', '', ''],
      ['', '', '']
    ];
    //gerar tabuleiro
    tabuleiro =
        List<Celula>.generate(TAM_TABULEIRO, (index) => Celula(index + 1));
  }

  void resetarJogo() {
    inicializarJogo();
  }

  // Considerando que celulaId é de 1 a 9
  void updateBoard(String player, int celulaId) {
    print("CelulaID: ");
    print(celulaId);
    int i = (celulaId - 1) ~/ 3;
    int j = (celulaId - 1) % 3;

    _board[i][j] = player;
  }

  void fazerUmaJogada(index) {
    print('Jogada HUMANO index = $index');
    final celula = tabuleiro[index];

    if (jogadorDaVez == Jogador.jogador1) {
      //marco a celula com a jogada
      celula.receberJogada(SIMBOLO_JOGADOR1, COR_JOGADOR1);
      //adiciono na lista de jogadas do respectivo jogador
      movJogador1.add(celula.id);
      updateBoard(_human, celula.id);
      //vez ao proximo jogador
      jogadorDaVez = Jogador.jogador2;
    } else {
      //marco a celula com a jogada
      celula.receberJogada(SIMBOLO_JOGADOR2, COR_JOGADOR2);
      //adiciono na lista de jogadas do respectivo jogador
      movJogador2.add(celula.id);
      updateBoard(_ai, celula.id);
      //vez ao proximo jogador
      jogadorDaVez = Jogador.jogador1;
    }
  }

  void fazerUmaJogadaIA() {
    if (modoUmJogador == true && jogadorDaVez == Jogador.jogador2) {
      print('ESTADO DO TABULEIRO PARA IA: $_board');
      int melhorJogada = _bestMove();
      print('Melhor Jogada IA: $melhorJogada');

      final iaCelula = tabuleiro[melhorJogada];
      iaCelula.receberJogada(SIMBOLO_JOGADOR2, COR_JOGADOR2);
      movJogador2.add(iaCelula.id);
      updateBoard(_ai, iaCelula.id);

      jogadorDaVez = Jogador.jogador1;
    }
  }

  //checar fim de jogo
  bool fimJogo() {
    if ((movJogador1.length + movJogador2.length) == TAM_TABULEIRO) {
      return true;
    }
    return false;
  }

  // checar se alguem ganhou
  Ganhador checarVencedor() {
    if (venceu(movJogador1)) {
      return Ganhador.jogador1;
    }
    if (venceu(movJogador2)) {
      return Ganhador.jogador2;
    }
    return Ganhador.none;
  }

  bool venceu(List<int> movimentos) {
    //usar o metodo any
    //verifica se há alguma combinação de jogadas para vencer
    return REGRAS_PARA_GANHAR.any((regra) =>
        movimentos.contains(regra[0]) &&
        movimentos.contains(regra[1]) &&
        movimentos.contains(regra[2]));
  }
}
