//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ChessHub/constantes/constantes.dart';
import 'package:ChessHub/game_internals/funciones.dart';
import 'package:ChessHub/local_game_sesion/chess_play_session_screen.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';
import 'package:ChessHub/local_game_sesion/pieza_ajedrez.dart';
import 'package:ChessHub/online_game_sesion/tablero_online_widget.dart';
import 'package:ChessHub/log_in/log_in_screen.dart';

class EsperandoPartida extends StatefulWidget {
  final Modos modoJuego;
  final int userId;
  final int elo;

  EsperandoPartida(
      {required this.modoJuego, required this.userId, required this.elo});

  @override
  _EsperandoPartidaState createState() => _EsperandoPartidaState();
}

class _EsperandoPartidaState extends State<EsperandoPartida> {
  bool partidaEncontrada = false;
  bool partidaCancelada = false;
  late Modos modoJuego;
  late int id;
  late int elo;
  int countdown = 5; // Inicializamos el contador en 10 segundos
  late int _roomId = 0;
  late String myColor = '';
  late String idOponente = '';
  bool infoObtenida = false;

  IO.Socket socket =
      IO.io("https://chesshub-api-ffvrx5sara-ew.a.run.app", <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  @override
  void initState() {
    super.initState();
    modoJuego = widget.modoJuego;
    id = widget.userId;
    elo = widget.elo;
    enviarPeticiondeJuego(modoJuego);
    _esperarPartida();
    _partidaEncontrada();
    _cancelarBusqueda();
  }

  void enviarPeticiondeJuego(Modos modo) {
    //('join_room', { mode: 'Rapid' , userId: args.userInfo.userId , elo: args.userInfo.eloRapid})

    socket.emit(
        'join_room', {"mode": obtenerModo(modo), "userId": id, "elo": elo});
  }

  void _startCountdown() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (mounted) {
        setState(() {
          if (countdown < 1) {
            timer.cancel();
            entrarEnPartida();
            // Detenemos el temporizador cuando el contador llega a cero
          } else {
            countdown--;
          }
        });
      }
    });
  }

  void _esperarPartida() {
    socket.on('game_ready', (data) {
      if (mounted) {
        setState(() {
          print('Datos de la partida: ');
          print(data);
          _roomId = data[0]['roomId'] as int;
          print(_roomId);
          myColor = data[0]["color"] as String;
          int idOponenteInt = data[0]["opponent"] as int;
          idOponente = idOponenteInt.toString();
        });
      }
    });
  }

  void _partidaEncontrada() {
    socket.on('match_found', (data) {
      if (mounted) {
        setState(() {
          partidaEncontrada = true;
        });
      }
      socket.off('match_found');
      _startCountdown();
    });
  }

  Future<void> _cancelarBusqueda() async {
    socket.on('match_canceled', (_) {
      if (mounted) {
        setState(() {
          partidaCancelada = true;
        });
      }
      socket.off('match_canceled');
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pop(context);
      });
    });
  }

  void entrarEnPartida() async {
    // Navegar a la pantalla del tablero cuando countdown es igual a 0
    final login = context.read<LoginState>();
    List<List<PiezaAjedrez?>> tablero;
    List<Color> coloresTablero;
    print('Imagen de la pieza: ${login.getImagenPieza()}');
    print('Imagen del tablero: ${login.arena}');
    tablero = inicializarTablero(login.imagen);
    if (modoJuego == Modos.RAPID) {
      if (login.getEloRapidUsuario() <= 1500) {
        coloresTablero = getColorCasilla("Madera");
      } else if (login.getEloRapidUsuario() > 1500 &&
          login.getEloRapidUsuario() <= 1800) {
        coloresTablero = getColorCasilla("Marmol");
      } else if (login.getEloRapidUsuario() > 1800 &&
          login.getEloRapidUsuario() <= 2100) {
        coloresTablero = getColorCasilla("Oro");
      } else if (login.getEloRapidUsuario() > 2100 &&
          login.getEloRapidUsuario() <= 2400) {
        coloresTablero = getColorCasilla("Esmeralda");
      } else {
        coloresTablero = getColorCasilla("Diamante");
      }
    } else if (modoJuego == Modos.BLITZ) {
      if (login.getEloBlitzUsuario() <= 1500) {
        coloresTablero = getColorCasilla("Madera");
      } else if (login.getEloBlitzUsuario() > 1500 &&
          login.getEloBlitzUsuario() <= 1800) {
        coloresTablero = getColorCasilla("Marmol");
      } else if (login.getEloBlitzUsuario() > 1800 &&
          login.getEloBlitzUsuario() <= 2100) {
        coloresTablero = getColorCasilla("Oro");
      } else if (login.getEloBlitzUsuario() > 2100 &&
          login.getEloBlitzUsuario() <= 2400) {
        coloresTablero = getColorCasilla("Esmeralda");
      } else {
        coloresTablero = getColorCasilla("Diamante");
      }
    } else {
      if (login.getEloBulletUsuario() <= 1500) {
        coloresTablero = getColorCasilla("Madera");
      } else if (login.getEloBulletUsuario() > 1500 &&
          login.getEloBulletUsuario() <= 1800) {
        coloresTablero = getColorCasilla("Marmol");
      } else if (login.getEloBulletUsuario() > 1800 &&
          login.getEloBulletUsuario() <= 2100) {
        coloresTablero = getColorCasilla("Oro");
      } else if (login.getEloBulletUsuario() > 2100 &&
          login.getEloBulletUsuario() <= 2400) {
        coloresTablero = getColorCasilla("Esmeralda");
      } else {
        coloresTablero = getColorCasilla("Diamante");
      }
    }
    String nombreUsuario = login.nombre;
    print('Nombre del usuario: $nombreUsuario');
    late String nombreOponente;

    Future<String> futureString = getNombre(idOponente);
    await futureString.then((value) {
      nombreOponente = value;
      print('Nombre del oponente: $nombreOponente');
      // Usa el valor de resultado aquí
    });

    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TableroAjedrezOnline(
            modoJuego: widget.modoJuego,
            coloresTablero: coloresTablero,
            tablero: tablero,
            socket: socket,
            roomIdP: _roomId,
            myColor: myColor,
            idOponente: idOponente,
            nombreUsuario: nombreUsuario,
            nombreOponente: nombreOponente,
            nombrePieza: login.getImagenPieza(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
        builder: (context, value, child) => Stack(children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/board2.jpg"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Color.fromRGBO(49, 45, 45, 1),
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          socket.emit('cancel_match');
                          socket.emit('cancel_search',
                              {"mode": obtenerModo(modoJuego)});
                          socket.off('match_canceled');
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                  title: Text('Esperando partida',
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Oswald')),
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      if (partidaEncontrada)
                        if (partidaCancelada)
                          Text(
                              'La partida ha sido cancelada, redirigiendo a la pantalla anterior...',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 136, 0, 1)))
                        else if (countdown > 0)
                          Text(
                              'Partida encontrada, comenzará en: $countdown segundos',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 136, 0, 1)))
                        else
                          Text('Cargando la partida...',
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 136, 0, 1)))
                      else
                        CircularProgressIndicator(),
                      if (partidaCancelada)
                        Text(
                            'En unos instantes volverás a la pantalla anterior',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 136, 0, 1)))
                      else
                        SizedBox(height: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(255, 136, 0, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        onPressed: () {
                          //ESTO NO VA
                          socket.emit('cancel_match');
                          socket.emit('cancel_search',
                              {"mode": obtenerModo(modoJuego)});
                          socket.off('match_canceled');
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar búsqueda',
                            style: TextStyle(
                                color: Color.fromRGBO(49, 45, 45, 1))),
                      ),
                    ],
                  ),
                ),
              ),
            ]));
  }
}
