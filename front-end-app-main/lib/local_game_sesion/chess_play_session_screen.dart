import 'package:ChessHub/constantes/constantes.dart';
import 'package:ChessHub/online_game_sesion/esperando_partida.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ChessHub/online_game_sesion/tablero_online_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ChessHub/style/header.dart';
import 'package:ChessHub/log_in/log_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:ChessHub/local_game_sesion/pieza_ajedrez.dart';
import 'package:ChessHub/game_internals/funciones.dart';
import 'dart:async';
import 'package:ChessHub/partidas_asincronas/menu_partidas_asincronas.dart';
import '../settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class ChessPlaySessionScreen extends StatelessWidget {
  const ChessPlaySessionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    final login = context.read<LoginState>();
    bool cuentalog = false;
    List<List<PiezaAjedrez?>> tablero =
        List.generate(8, (index) => List.generate(8, (index) => null));
    List<Color> coloresTablero = [];

    if (login.logueado && settingsController.loggedIn.value) {
      cuentalog = true;
      print("ARENA: ${login.arena}");
      print("COLOR: ${coloresTablero}");
      tablero = inicializarTablero(login.imagen);
      coloresTablero = getColorCasilla(login.arena);
    }

    return Consumer<LoginState>(
      builder: (context, value, child) => Scaffold(
        appBar: Header(),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [Color.fromRGBO(49, 45, 45, 1), Colors.grey[500]!],
            ),
          ),
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 450,
                      height: 400,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.orange[900]!, Colors.orange[300]!],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'JUGAR EN MODO LOCAL',
                            style: GoogleFonts.play(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              context.go('/chess/rapid');
                            },
                            child: Text(
                              'RAPID',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontFamily: 'Cantarell',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              context.go('/chess/bullet');
                            },
                            child: Text(
                              'BULLET',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontFamily: 'Cantarell',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              GoRouter.of(context).go('/chess/blitz');
                            },
                            child: Text(
                              'BLITZ',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontFamily: 'Cantarell',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    cuentalog
                        ? Column(
                            children: [
                              Container(
                                width: 450,
                                height: 400,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.orange[900]!,
                                      Colors.orange[300]!
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'JUGAR EN MODO ONLINE',
                                      style: GoogleFonts.play(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EsperandoPartida(
                                                      modoJuego: Modos.RAPID,
                                                      userId: value.id,
                                                      elo: value.eloRapid)),
                                        );
                                      },
                                      child: Text(
                                        'RAPID',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontFamily: 'Cantarell',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EsperandoPartida(
                                                      modoJuego: Modos.BULLET,
                                                      userId: value.id,
                                                      elo: value.eloBullet)),
                                        );
                                      },
                                      child: Text(
                                        'BULLET',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontFamily: 'Cantarell',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EsperandoPartida(
                                                      modoJuego: Modos.BLITZ,
                                                      userId: value.id,
                                                      elo: value.eloBlitz)),
                                        );
                                      },
                                      child: Text(
                                        'BLITZ',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontFamily: 'Cantarell',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 450,
                                height: 200,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.orange[900]!,
                                      Colors.orange[300]!
                                    ],
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 30),
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PartidasAsincronas(
                                                      id: value.id,
                                                      modoJuego:
                                                          Modos.ASINCRONO)),
                                        );
                                      },
                                      child: Text(
                                        'JUGAR POR CORRESPONDENCIA',
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
                            ],
                          )
                        : Container(
                            width: 450,
                            height:
                                200, // Establecido un tamaño para el contenedor
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.orange[900]!,
                                  Colors.orange[300]!
                                ],
                              ),
                            ),
                            child: Align(
                              // Alineado el texto en el centro
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  if (settingsController.loggedIn.value) {
                                    settingsController.toggleLoggedIn();
                                  }
                                  GoRouter.of(context).go('/login');
                                },
                                child: settingsController.loggedIn.value
                                    ? Text(
                                        'CONFIRMA TU SESIÓN PARA JUGAR ONLINE',
                                        style: GoogleFonts.play(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        'INICIA SESIÓN PARA JUGAR ONLINE',
                                        style: GoogleFonts.play(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  



                 



//   @override
//   Widget build(BuildContext context) {

//     final login = context.read<LoginState>();
//     bool cuentalog = false;
//     List<List<PiezaAjedrez?>> tablero = List.generate(8, (index) => List.generate(8, (index) => null));
//     List<Color> coloresTablero = [];
//     if (login.logueado) {
//       cuentalog = true;
//       print("ARENA: ${login.arena}");
//       print("COLOR: ${coloresTablero}");
//       tablero = inicializarTablero(login.imagen);
//       coloresTablero = getColorCasilla(login.arena);
//     }
//     return Consumer<LoginState>(
//       builder: (context,value,child) => Scaffold(
//         appBar: Header(),
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomRight,
//               colors: [Color.fromRGBO(49, 45, 45, 1), Colors.grey[500]!],
//             ),
//           ),
//           child: Column(
//             children: [
//               Expanded(
//                 child: Center(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 450,
//                           height: 400,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black, width: 1),
//                             gradient: LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                               colors: [Colors.orange[900]!, Colors.orange[300]!],
//                             ),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'JUGAR EN MODO LOCAL',
//                                 style: GoogleFonts.play(
//                                   fontSize: 25,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 30),
//                               GestureDetector(
//                                 onTap: () {
//                                   context.go('/chess/rapid');
//                                 },
//                                 child: Text(
//                                   'RAPID',
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.white,
//                                     fontFamily: 'Cantarell',
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               GestureDetector(
//                                 onTap: () {
//                                   context.go('/chess/bullet');
//                                 },
//                                 child: Text(
//                                   'BULLET',
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.white,
//                                     fontFamily: 'Cantarell',
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               GestureDetector(
//                                 onTap: () {
//                                   GoRouter.of(context).go('/chess/blitz');
//                                 },
//                                 child: Text(
//                                   'BLITZ',
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.white,
//                                     fontFamily: 'Cantarell',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         cuentalog ?
//                         Container(
//                           width: 450,
//                           height: 400,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black, width: 1),
//                             gradient: LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                               colors: [Colors.orange[900]!, Colors.orange[300]!],
//                             ),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'JUGAR EN MODO ONLINE',
//                                 style: GoogleFonts.play(
//                                   fontSize: 25,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 30),
//                               GestureDetector(
//                                 onTap: () async{
//                                   //TableroAjedrezOnline(modoJuego: Modos.RAPID,coloresTablero: coloresTablero, tablero: tablero)
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => EsperandoPartida(modoJuego: Modos.RAPID, userId: value.id, elo: value.eloRapid)
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   'RAPID',
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.white,
//                                     fontFamily: 'Cantarell',
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               GestureDetector(
//                                 onTap: () async{
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => EsperandoPartida(modoJuego: Modos.BULLET, userId: value.id, elo: value.eloRapid)
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   'BULLET',
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.white,
//                                     fontFamily: 'Cantarell',
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               GestureDetector(
//                                 onTap: () async{
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => EsperandoPartida(modoJuego: Modos.BLITZ, userId: value.id, elo: value.eloRapid)
//                                     ),
//                                   );
//                                 },
//                                 child: Text(
//                                   'BLITZ',
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.white,
//                                     fontFamily: 'Cantarell',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 20) ,
//                         Container(
//                           width: 450,
//                           height: 200,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.black, width: 1),
//                             gradient: LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                               colors: [Colors.orange[900]!, Colors.orange[300]!],
//                             ),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'JUGAR POR CORRESPONDENCIA',
//                                 style: GoogleFonts.play(
//                                   fontSize: 25,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 30),
//                               GestureDetector(
//                                 onTap: () async{
//                                   // Agrega aquí la navegación o acción correspondiente
//                                 },
//                                 child: Text(
//                                   'Iniciar partida por correspondencia',
//                                   style: TextStyle(
//                                     fontSize: 25,
//                                     color: Colors.white,
//                                     fontFamily: 'Cantarell',
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
                    
//                         : Container(
//                           child:
//                               Align(
//                                 alignment: Alignment.topCenter,
//                                 child: Text(
//                                   'CREATE UNA CUENTA PARA JUGAR ONLINE',
//                                   style: GoogleFonts.play(
//                                     fontSize: 18,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }