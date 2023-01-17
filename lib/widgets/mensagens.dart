import 'package:flutter/material.dart';
import 'package:jogo_da_velha/core/constantes.dart';

class CustomDialog extends StatelessWidget {
  final String? titulo;
  final String? msg;
  final Function? onPressed;

  const CustomDialog({super.key, this.titulo, this.msg, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo!),
      content: Text(msg!),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              elevation: 20.0,
              shadowColor: Colors.white),
          child: const Text(BOTAO_RESTART),
          onPressed: () {
            Navigator.pop(context);
            onPressed!();
          },
        ),
      ],
    );
  }
}
