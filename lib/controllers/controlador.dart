import 'package:jogo_da_velha/models/celulas.dart';
import 'package:jogo_da_velha/enums/jogadores.dart';
import 'package:jogo_da_velha/core/constantes.dart';
import 'package:jogo_da_velha/core/como_vencer.dart';
import 'package:jogo_da_velha/enums/ganhador.dart';

class Jogo {
  List<Celula> tabuleiro = [];
  List<int> movJogador1 = [];
  List<int> movJogador2 = [];
  Jogador? jogadorDaVez;
  bool? modoUmJogador;

  Jogo() {
    inicializarJogo();
  }

  void inicializarJogo() {
    //limpar as jogadas
    movJogador1.clear();
    movJogador2.clear();
    //colocar a vez pro jogador um
    jogadorDaVez = Jogador.jogador1;
    modoUmJogador = false;
    //gerar tabuleiro
    tabuleiro =
        List<Celula>.generate(TAM_TABULEIRO, (index) => Celula(index + 1));
  }

  void resetarJogo() {
    inicializarJogo();
  }

  void fazerUmaJogada(index) {
    final celula = tabuleiro[index];

    if (jogadorDaVez == Jogador.jogador1) {
      //marco a celula com a jogada
      celula.receberJogada(SIMBOLO_JOGADOR1, COR_JOGADOR1);
      //adiciono na lista de jogadas do respectivo jogador
      movJogador1.add(celula.id);
      //vez ao proximo jogador
      jogadorDaVez = Jogador.jogador2;
    } else {
      //marco a celula com a jogada
      celula.receberJogada(SIMBOLO_JOGADOR2, COR_JOGADOR2);
      //adiciono na lista de jogadas do respectivo jogador
      movJogador2.add(celula.id);
      //vez ao proximo jogador
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
