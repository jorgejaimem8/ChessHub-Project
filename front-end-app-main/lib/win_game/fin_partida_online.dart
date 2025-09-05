import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ChessHub/local_game_sesion/chess_play_session_screen.dart';
import 'package:http/http.dart' as http;

class FinPartidaOnline extends StatelessWidget {
  final String razon;
  final String idGanador;
  final String idPerdedor;
  final String modo;
  final bool esEmpate;

  const FinPartidaOnline({
    Key? key,
    this.razon = '',
    this.idGanador = '',
    this.idPerdedor = '',
    this.modo = '',
    this.esEmpate = false,
  }) : super(key: key);

  Future<void> actualizarElo() async {
    print('Actualizando elo');
    print("idGanador: $idGanador");
    print("idPerdedor: $idPerdedor");
    print("esEmpate: $esEmpate");
    print("modo: $modo");
    String modoMin = modo.toLowerCase();
    Uri uri = Uri.parse(
        'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_puntos/$modoMin/$idGanador/$idPerdedor/$esEmpate');
    http.Response response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader:
            'application/json', // Especifica el tipo de contenido como JSON
      },
    );
    if (response.statusCode == 200) {
      print('Elo actualizado');
    } else {
      print('Error al actualizar el elo');
    }
  }

  @override
  Widget build(BuildContext context) {
    String mensajeFinal = '';
    switch (razon) {
      case "player_disconnected":
        mensajeFinal = ' !Ganas!\nTu oponente se ha desconectado';
      case "oponent_surrendered":
        mensajeFinal = ' !Ganas!\nTu oponente se ha rendido';
      case "has_perdido":
        mensajeFinal = ' !Jaque Mate!\nTu oponente ha ganado';
      case "has_empatado":
        mensajeFinal = ' !Empate!\nLa partida ha terminado en empate';
      case "has_ganado":
        mensajeFinal = ' !Ganas!\nHas ganado la partida';
      case "has_perdido_timer":
        mensajeFinal = ' !Has perdido!\nHas superado el tiempo límite';
      case "has_ganado_timer":
        mensajeFinal = ' !Ganas!\nTu oponente ha superado el tiempo límite';
      default:
        mensajeFinal = ' !Fin de la partida!';
        break;
    }

    actualizarElo();

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
