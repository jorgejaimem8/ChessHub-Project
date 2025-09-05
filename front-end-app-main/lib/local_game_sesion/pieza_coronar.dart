import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ChessHub/local_game_sesion/pieza_ajedrez.dart';
import 'package:ChessHub/game_internals/funciones.dart';

class PiezaCoronar extends StatelessWidget {
  final bool esBlanca;
  final TipoPieza tipoPieza;
  String imagenPieza;

  PiezaCoronar({required this.esBlanca, required this.tipoPieza, this.imagenPieza = ''});

  @override
  Widget build(BuildContext context) {
    String imagePath;
    if(imagenPieza != ''){
      imagePath = getImagePath(imagenPieza,esBlanca,tipoPieza);
    }
    else{
      imagePath = obtenerRutaImagen(tipoPieza, esBlanca);
    }

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: esBlanca ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: SvgPicture.asset(
          imagePath,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
