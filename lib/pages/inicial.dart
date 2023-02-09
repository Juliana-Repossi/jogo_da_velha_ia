import 'package:flutter/material.dart';
import 'package:jogo_da_velha/controllers/controlador.dart';
import 'package:jogo_da_velha/core/constantes.dart';
import 'package:jogo_da_velha/enums/ganhador.dart';
import 'package:jogo_da_velha/widgets/mensagens.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  EstadoPagInicial createState() => EstadoPagInicial();
}

class EstadoPagInicial extends State<PaginaInicial> {
  final controlador = Jogo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: constroiAppBar(),
      body: constroiBody(),
    );
  }

  constroiAppBar() {
    return AppBar(
      title: const Text(NOME_JOGO),
      centerTitle: true,
    );
  }

  constroiBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        construirTabuleiro(),
        construirModoJogo(),
        construirResetButton(),
      ],
    );
  }

  construirTabuleiro() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: TAM_TABULEIRO,
        // ignore: prefer_const_constructors
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: constroiCelula,
      ),
    );
  }

  Widget constroiCelula(context, index) {
    return GestureDetector(
      onTap: () => jogarCelula(index),
      child: Container(
        color: controlador.tabuleiro[index].cor,
        child: Center(
          child: Text(
            controlador.tabuleiro[index].simbolo,
            // ignore: prefer_const_constructors
            style: TextStyle(
              fontSize: 60.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  jogarCelula(index) {
    if (!controlador.tabuleiro[index].vazio) {
      return;
    }
    //else
    setState(() {
      controlador.fazerUmaJogada(index);
    });
    checarVitoria();
  }

  checarVitoria() {
    var vencedor = controlador.checarVencedor();
    if (vencedor == Ganhador.none) {
      if (controlador.fimJogo()) {
        mensagemDeuVelha();
      }
      else {
        setState(() {
          controlador.fazerUmaJogadaIA();
        });
        vencedor = controlador.checarVencedor();

        if (vencedor == Ganhador.none) {
          if (controlador.fimJogo()) {
            mensagemDeuVelha();
          }
        } else {
          //há um ganhador
          if (vencedor == Ganhador.jogador1) {
            mensagemVitoria(SIMBOLO_JOGADOR1);
          } else {
            //Jogador 2 venceu
            mensagemVitoria(SIMBOLO_JOGADOR2);
          }
        }
      }
    } else {
      //há um ganhador
      if (vencedor == Ganhador.jogador1) {
        mensagemVitoria(SIMBOLO_JOGADOR1);
      } else {
        //Jogador 2 venceu
        mensagemVitoria(SIMBOLO_JOGADOR2);
      }
    }
  }

  mensagemDeuVelha() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialog(
          titulo: EMPATE,
          msg: NOVO_JOGO,
          onPressed: onResetJogo,
        );
      },
    );
  }

  mensagemVitoria(String simbolo) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (builder) {
        return CustomDialog(
          titulo: VITORIA.replaceAll('[SIMBOLO]', simbolo),
          msg: NOVO_JOGO,
          onPressed: onResetJogo,
        );
      },
    );
  }

  construirModoJogo() {
    return SwitchListTile(
      title: Text(controlador.modoUmJogador! ? 'Um Jogador' : 'Dois Jogadores'),
      secondary: Icon(controlador.modoUmJogador! ? Icons.person : Icons.group),
      value: controlador.modoUmJogador!,
      onChanged: (value) {
        setState(() {
          controlador.modoUmJogador = value;
        });
      },
    );
  }

  construirResetButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        elevation: 30,
        shadowColor: Colors.white,
      ),
      onPressed: onResetJogo,
      child: const Text(BOTAO_RESTART),
    );
  }

  onResetJogo() {
    setState(() {
      controlador.resetarJogo();
    });
  }
}
