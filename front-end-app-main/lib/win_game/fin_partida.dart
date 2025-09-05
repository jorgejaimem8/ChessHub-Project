import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class FinPartida extends StatelessWidget {
  final bool esColorBlanca;
  final bool esJaqueMate;
  final bool tiempoAgotado;
  final bool esAhogado;

  const FinPartida({
    Key? key,
    this.esColorBlanca = false,
    this.esJaqueMate = false,
    this.tiempoAgotado = false,
    this.esAhogado = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mensajeFinal = '';
    switch (esColorBlanca) {
      case true:
        if (esJaqueMate) {
          mensajeFinal = '¡Jaque mate!\nGanaron las blancas';
        } else if (tiempoAgotado) {
          mensajeFinal =  '¡Tiempo agotado!\nGanaron las blancas';
        } else if (esAhogado) {
          mensajeFinal = '¡Ahogado!\nGanaron las blancas';
        }
        break;
      case false:
        if (esJaqueMate) {
          mensajeFinal =  '¡Jaque mate!\nGanaron las negras';
        } else if (tiempoAgotado) {
          mensajeFinal = '¡Tiempo agotado!\nGanaron las negras';
        } else if (esAhogado) {
          mensajeFinal = '¡Ahogado!\nGanaron las negras';
        }
        break;
    }
    

    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 45, 45, 1),
      body: Center(
        child: Container(
          width: 450,
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.orange[900]!, Colors.orange[300]!],
            ),
            borderRadius: BorderRadius.circular(10), // Bordes redondeados
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mensajeFinal,
                textAlign: TextAlign.center,
                style: GoogleFonts.play(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la ruta deseada al abandonar la partida
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Abandonar partida',
                  style: GoogleFonts.play(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
