import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:ChessHub/battle_pass/battle_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../log_in/log_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ChessHub/partidas_asincronas/menu_partidas_asincronas.dart';
import 'package:ChessHub/local_game_sesion/casilla_ajedrez.dart';
import 'package:ChessHub/local_game_sesion/pieza_ajedrez.dart';
import 'package:ChessHub/local_game_sesion/pieza_coronar.dart';
import 'package:ChessHub/local_game_sesion/piezaMuerta.dart';
import 'package:ChessHub/local_game_sesion/tablero_widget.dart';
import 'package:ChessHub/game_internals/funciones.dart';
import 'package:ChessHub/local_game_sesion/stats_game.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ChessHub/win_game/fin_partida.dart';
import 'package:ChessHub/constantes/constantes.dart';
import 'package:ChessHub/game_internals/funciones.dart';
import 'package:ChessHub/local_game_sesion/stats_game.dart';

import 'package:flutter/material.dart';

class PartidaAsincrona extends StatefulWidget {
  final int idPartida;
  final int idUsuario;
  final int idRival;
  final String tablero;
  final bool soyBlancas;

  PartidaAsincrona({
    Key? key,
    required this.idPartida,
    required this.idUsuario,
    required this.idRival,
    required this.tablero,
    required this.soyBlancas,
  }) : super(key: key);

  @override
  _PartidaAsincronaState createState() => _PartidaAsincronaState();
}

class _PartidaAsincronaState extends State<PartidaAsincrona> {
  int roomIdP = 0;
  int idUsuario = 0;
  int idOponente = 0;
  String tableroString = '';
  late List<List<PiezaAjedrez?>> tablero;
  PiezaAjedrez? piezaSeleccionada;
  int filaSeleccionada = -1;
  int columnaSeleccionada = -1;
  String jsonString = '';
  List<List<int>> movimientosValidos = [];
  Map<String, dynamic> jsonMapTablero = {};
  Map<String, dynamic> jsonMapMovimientos = {};
  List<PiezaAjedrez> piezasBlancasMuertas = [];
  List<PiezaAjedrez> piezasNegrasMuertas = [];
  late PlayerRow player1;
  late PlayerRow player2;
  late bool esTurnoBlancas = true;
  bool hayJaque = false;
  bool hayJaqueMate = false;
  bool finPartida = false;
  bool hayTablas = false;
  bool hayCoronacion = false;
  bool terminadaCoronacion = false;
  TipoPieza tipoPiezaCoronada = TipoPieza.peon;
  late bool soyBlancas;
  late String tipoPiezaImagen;
  late bool meToca;
  late String motivoFinPartida;
  String idGanador = '';
  String idPerdedor = '';
  bool _isVisible = false;
  bool movimientoRealizado = false;
  bool jugadaHecha = false;
  bool salir = false;
  @override
  void initState() {
    roomIdP = widget.idPartida;
    idUsuario = widget.idUsuario;
    idOponente = widget.idRival;
    tableroString = widget.tablero;
    soyBlancas = widget.soyBlancas;

    print(tableroString);
    esTurnoBlancas = tableroString.contains('"turno":"blancas"');
    if (soyBlancas) {
      print('Soy blancas');
      player1 = PlayerRow(playerName: idUsuario.toString(), esBlanca: true);
      player2 = PlayerRow(playerName: idOponente.toString(), esBlanca: false);
    } else {
      print('Soy negras');
      player1 = PlayerRow(playerName: idUsuario.toString(), esBlanca: false);
      player2 = PlayerRow(playerName: idOponente.toString(), esBlanca: true);
    }
    if (tableroString.contains('"has_perdido":true')) {
      finPartida = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Has perdido la partida!')));
      eliminarPartidaAsincrona(roomIdP);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PartidasAsincronas(
                  id: idUsuario, modoJuego: Modos.ASINCRONO)));
    }
    if (tableroString.contains('"hay_tablas":true')) {
      finPartida = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tablas!')));
      eliminarPartidaAsincrona(roomIdP);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PartidasAsincronas(
                  id: idUsuario, modoJuego: Modos.ASINCRONO)));
    }
    enviarTab(tableroString);
    tablero = inicializarTableroDesdeJson(
        jsonDecode(tableroString) as Map<String, dynamic>, "defecto");
    jsonMapTablero = jsonDecode(tableroString) as Map<String, dynamic>;
    super.initState();
  }

  void eliminarPartidaAsincrona(int roomId) async {
    Uri uriklk = Uri.parse(
        ('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/remove_partida_asincrona/$roomIdP'));
    http.post(uriklk);
  }

  Future<void> postTab(String str) async {
    Uri uri = Uri.parse(
        'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_cambio_partida_asincrona/$roomIdP');
    Map<String, String> body = {"tablero_actual": str};
    String jsonBody = jsonEncode(body);
    http.Response response = await http.post(
      uri,
      body: jsonBody,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      print('TABLERO POSTEADO');
    } else if (response.statusCode == 500) {
      throw Exception('Error en la solicitud POST: ${response.statusCode}');
    }
  }

  List<String> obtenerMovimientosReyJaque() {
    print('MOVIMIENTOS REY EN JAQUE\n');
    print(jsonMapMovimientos['allMovements']['rey'][0][1]);
    List<String> movimientosValidosString = [];
    int len = (jsonMapMovimientos['allMovements']['rey'][0].length as int);
    for (int i = 1; i < len; i++) {
      String mov = jsonEncode(jsonMapMovimientos['allMovements']['rey'][0][i]);
      print('Anyadiendo el siguiente movimiento: ');
      print(mov);
      movimientosValidosString.add(mov);
    }
    return movimientosValidosString;
  }

  List<List<int>> obtenerMovimientosValidosJaque(
      int fila, int columna, PiezaAjedrez pieza) {
    List<List<int>> movimientosValidosInt = [];
    List<int> coordenadasApi = convertirAppToApi(fila, columna);
    bool blanca = pieza.esBlanca;
    String npieza = nombrePieza(pieza);

    print('COMER O BLOQUEAR\n');

    print('MOVIMIENTOS BLOQUEAR\n');
    if (jsonMapMovimientos['allMovements']['bloquear'][0][npieza] != null) {
      print('ENTRA EN BLOQUEAR\n');
      if (jsonMapMovimientos['allMovements']['bloquear'][0][npieza] as List !=
          []) {
        if (jsonMapMovimientos['allMovements']['bloquear'][0][npieza][0]
                    ['fromX'] ==
                coordenadasApi[0] &&
            jsonMapMovimientos['allMovements']['bloquear'][0][npieza][0]
                    ['fromY'] ==
                coordenadasApi[1]) {
          print('HAY MOVIMIENTOS PARA BLOQUEAR\n');
          movimientosValidosInt.add(convertirApiToApp(
              jsonMapMovimientos['allMovements']['bloquear'][0][npieza][0]['x']
                  as int,
              jsonMapMovimientos['allMovements']['bloquear'][0][npieza][0]['y']
                  as int));
        } else {
          print('NO HAY MOVIMIENTOS PARA BLOQUEAR\n');
        }
      }
    }

    print('MOVIMIENTOS COMER\n');
    if (jsonMapMovimientos['allMovements']['comer'][0][npieza] is List &&
        (jsonMapMovimientos['allMovements']['comer'][0][npieza] as List)
            .isNotEmpty) {
      print('ENTRA EN COMER\n');

      if ((jsonMapMovimientos['allMovements']['comer'][0][npieza][0]
                  as Map<String, dynamic>?)
              ?.isNotEmpty ??
          false) {
        if ((jsonMapMovimientos['allMovements']['comer'][0][npieza][0]['fromX']
                    as int?) ==
                coordenadasApi[0] &&
            (jsonMapMovimientos['allMovements']['comer'][0][npieza][0]['fromY']
                    as int?) ==
                coordenadasApi[1]) {
          print('HAY MOVIMIENTOS PARA COMER\n');
          movimientosValidosInt.add(convertirApiToApp(
              (jsonMapMovimientos['allMovements']['comer'][0][npieza][0]['x']
                  as int),
              (jsonMapMovimientos['allMovements']['comer'][0][npieza][0]['y']
                  as int)));
        } else {
          print('NO HAY MOVIMIENTOS PARA COMER\n');
        }
      }
    }
    return movimientosValidosInt;
  }

  List<String> obtenerMovimientosValidos(
      int fila, int columna, PiezaAjedrez pieza) {
    List<String> movimientosValidosString = [];
    // Transformar la fila y la columna en el formato de la API para que pueda ser leído
    List<int> coordenadasApi = convertirAppToApi(fila, columna);
    bool blanca = pieza.esBlanca;
    String color = blanca ? '"fromColor":"blancas"' : '"fromColor":"negras"';
    String coordenadasApiString = '{"fromX":' +
        coordenadasApi[0].toString() +
        ',"fromY":' +
        coordenadasApi[1].toString() +
        ',' +
        color +
        '}';

    print('Coordenadas a buscar: ');
    print(coordenadasApiString);

    String nPieza = nombrePieza(pieza);

    //Recorremos el mapa de movimientos válidos
    int len = jsonMapMovimientos['allMovements'][nPieza].length as int;

    for (int i = 0; i < len; i++) {
      String coor =
          jsonEncode(jsonMapMovimientos['allMovements'][nPieza][i][0]);
      if (coor == coordenadasApiString) {
        int lenMov =
            jsonMapMovimientos['allMovements'][nPieza][i].length as int;
        for (int j = 1; j < lenMov; j++) {
          String mov =
              jsonEncode(jsonMapMovimientos['allMovements'][nPieza][i][j]);
          print('Anyadiendo el siguiente movimiento: ');
          print(mov);
          movimientosValidosString.add(mov);
        }
        break;
      }
    }

    return movimientosValidosString;
  }

  List<int> obtenerXYFromString(String coordenadaString) {
    // Parsear el string a un mapa
    Map<String, dynamic> coordenadaMap =
        jsonDecode(coordenadaString) as Map<String, dynamic>;

    // Obtener los valores de x e y
    int x = coordenadaMap['x'] as int;
    int y = coordenadaMap['y'] as int;

    // Devolver una lista con los valores de x e y
    return [x, y];
  }

  List<List<int>> calcularMovimientos(List<String> movimientosValidos) {
    List<List<int>> movimientosValidosInt = [];

    //Recorrer la lista de movimientos válidos
    for (int i = 0; i < movimientosValidos.length; i++) {
      // Obtener las coordenadas de la lista de movimientos válidos
      List<int> coordenadas = obtenerXYFromString(movimientosValidos[i]);
      coordenadas = convertirApiToApp(coordenadas[0], coordenadas[1]);
      // Añadir las coordenadas a la lista de movimientos válidos
      movimientosValidosInt.add([coordenadas[0], coordenadas[1]]);
    }
    return movimientosValidosInt;
  }

  //REALIZAR MOVIMIENTO
  Future<void> _realizarMovimiento(int fila, int columna) async {
    if (esTurnoBlancas &&
        piezaSeleccionada?.tipoPieza == TipoPieza.peon &&
        fila == 0) {
      print('CORONAR PEON BLANCO\n');
      hayCoronacion = true;
      while (!terminadaCoronacion) {
        await Future.delayed(Duration(
            milliseconds: 1)); // Espera 1 segundo antes de verificar de nuevo
      }
      print('CORONACION TERMINADA\n');
    } else if (piezaSeleccionada?.tipoPieza == TipoPieza.peon && fila == 7) {
      hayCoronacion = true;
      while (!terminadaCoronacion) {
        await Future.delayed(Duration(
            milliseconds: 1)); // Espera 1 segundo antes de verificar de nuevo
      }
    }
    terminadaCoronacion = false;
    moverPieza(fila, columna);
  }

  void seleccionadaPieza(int fila, int columna) {
    setState(() {
      meToca = esTurnoBlancas == soyBlancas;
      if (meToca) {
        if (piezaSeleccionada == null && tablero[fila][columna] != null) {
          print("SELECCIONANDO PIEZA\n");
          if (tablero[fila][columna]!.esBlanca == soyBlancas) {
            piezaSeleccionada = tablero[fila][columna];
            filaSeleccionada = fila;
            columnaSeleccionada = columna;
          }
        } else if (tablero[fila][columna] != null &&
            tablero[fila][columna]!.esBlanca == piezaSeleccionada!.esBlanca) {
          piezaSeleccionada = tablero[fila][columna];
          filaSeleccionada = fila;
          columnaSeleccionada = columna;
        } else if (piezaSeleccionada != null &&
            movimientosValidos.any(
                (element) => element[0] == fila && element[1] == columna)) {
          if (esTurnoBlancas &&
              piezaSeleccionada?.tipoPieza == TipoPieza.peon &&
              fila == 0) {
            hayCoronacion = true;
          } else if (piezaSeleccionada?.tipoPieza == TipoPieza.peon &&
              fila == 7) {
            hayCoronacion = true;
          }
          print("REALIZANDO MOVIMIENTO\n");
          _realizarMovimiento(fila, columna);
        }

        print('Fila: ' + fila.toString() + ' Columna: ' + columna.toString());
        if (!hayJaque) {
          movimientosValidos = calcularMovimientos(
              obtenerMovimientosValidos(fila, columna, piezaSeleccionada!));
        } else if (piezaSeleccionada?.tipoPieza == TipoPieza.rey) {
          movimientosValidos =
              calcularMovimientos(obtenerMovimientosReyJaque());
        } else {
          movimientosValidos =
              obtenerMovimientosValidosJaque(fila, columna, piezaSeleccionada!);
        }
      }
    });
  }

  //MOVER PIEZA
  void moverPieza(int filaNueva, int columnaNueva) async {
    List<int> coordenadasAntiguasApi =
        convertirAppToApi(filaSeleccionada, columnaSeleccionada);
    List<int> coordenadasNuevasApi = convertirAppToApi(filaNueva, columnaNueva);

    print('TABLERO ANTES DE MOVER LA PIEZA\n');
    jsonString = jsonEncode(jsonMapTablero) as String;
    print(jsonString);

    Map<String, dynamic> jsonMapTableroAntiguo =
        jsonDecode(jsonString) as Map<String, dynamic>;

    if (tablero[filaNueva][columnaNueva] != null) {
      if (tablero[filaNueva][columnaNueva]!.esBlanca) {
        piezasBlancasMuertas.add(tablero[filaNueva][columnaNueva]!);
        setState(() {
          player1.incrementPiecesCaptured();
        });
      } else {
        piezasNegrasMuertas.add(tablero[filaNueva][columnaNueva]!);
        setState(() {
          player2.incrementPiecesCaptured();
        });
      }
      //si se trata de una muerte, debemos eliminar la pieza del tablero
      jsonMapTablero.forEach((tipoPieza, listaPiezas) {
        if (listaPiezas is List) {
          // Filtra la lista de piezas para eliminar la pieza con las coordenadas dadas
          listaPiezas.removeWhere((pieza) =>
              pieza['x'] == coordenadasNuevasApi[0] &&
              pieza['y'] == coordenadasNuevasApi[1]);
        }
      });
    }

    //Coronación
    if (hayCoronacion && esTurnoBlancas) {
      print("CORONANDO PEON BLANCO");
      String imagen = obtenerRutaImagen(tipoPiezaCoronada, esTurnoBlancas);
      //Coronamos peon blanco
      jsonMapTablero.forEach((tipoPieza, listaPiezas) {
        if (listaPiezas is List) {
          // Filtra la lista de piezas para eliminar la pieza con las coordenadas dadas
          listaPiezas.removeWhere((pieza) =>
              pieza['x'] == coordenadasNuevasApi[0] &&
              pieza['y'] == coordenadasNuevasApi[1]);
          listaPiezas.removeWhere((pieza) =>
              pieza['x'] == coordenadasNuevasApi[0] &&
              pieza['y'] == coordenadasNuevasApi[1] - 1);
        }
      });
      String color = "blancas";
      jsonMapTablero[nombrePiezaTipo(tipoPiezaCoronada)].add({
        'x': coordenadasNuevasApi[0],
        'y': coordenadasNuevasApi[1],
        'color': color
      });
      jsonMapTablero['piezaCoronada'] = nombrePiezaTipo(tipoPiezaCoronada);
      piezaSeleccionada =
          piezaSeleccionada?.cambiarTipoPieza(tipoPiezaCoronada, imagen);
    } else if (hayCoronacion && !esTurnoBlancas) {
      print("CORONANDO PEON NEGRO");
      String imagen = obtenerRutaImagen(tipoPiezaCoronada, esTurnoBlancas);
      //Coronamos peon negro
      jsonMapTablero.forEach((tipoPieza, listaPiezas) {
        if (listaPiezas is List) {
          // Filtra la lista de piezas para eliminar la pieza con las coordenadas dadas
          listaPiezas.removeWhere((pieza) =>
              pieza['x'] == coordenadasNuevasApi[0] &&
              pieza['y'] == coordenadasNuevasApi[1]);
          listaPiezas.removeWhere((pieza) =>
              pieza['x'] == coordenadasNuevasApi[0] &&
              pieza['y'] == coordenadasNuevasApi[1] - 1);
        }
      });

      String color = "negras";
      jsonMapTablero[nombrePiezaTipo(tipoPiezaCoronada)].add({
        'x': coordenadasNuevasApi[0],
        'y': coordenadasNuevasApi[1],
        'color': color
      });
      jsonMapTablero['piezaCoronada'] = nombrePiezaTipo(tipoPiezaCoronada);
      piezaSeleccionada =
          piezaSeleccionada?.cambiarTipoPieza(tipoPiezaCoronada, imagen);
    }

    if (meToca && soyBlancas) {
      print("CAMBIANDO DE TURNO BLANCAS - NEGRAS");
      jsonMapTablero['turno'] = 'negras';
    } else {
      print("CAMBIANDO DE TURNO NEGRAS - BLANCAS");
      jsonMapTablero['turno'] = 'blancas';
    }

    //Marcamos que la pieza torre ha sido movida para que el backend no permita enrocar
    if (piezaSeleccionada!.tipoPieza == TipoPieza.torre) {
      if (piezaSeleccionada!.esBlanca && piezaSeleccionada!.ladoIzquierdo) {
        jsonMapTablero['ha_movido_torre_blanca_izqda'] = true;
      } else if (piezaSeleccionada!.esBlanca) {
        jsonMapTablero['ha_movido_torre_blanca_dcha'] = true;
      } else if (piezaSeleccionada!.ladoIzquierdo) {
        jsonMapTablero['ha_movido_torre_negra_izqda'] = true;
      } else {
        jsonMapTablero['ha_movido_torre_negra_dcha'] = true;
      }
    }

    //Revisamos si hay enroque y si existe hacemos los cambios correspondientes
    if (piezaSeleccionada!.tipoPieza == TipoPieza.rey &&
        (jsonMapTablero['ha_movido_rey_blanco'] == false &&
                (jsonMapTablero['ha_movido_torre_blanca_izqda'] == false ||
                    jsonMapTablero['ha_movido_torre_blanca_dcha'] == false) ||
            jsonMapTablero['ha_movido_rey_negro'] == false &&
                (jsonMapTablero['ha_movido_torre_negra_izqda'] == false ||
                    jsonMapTablero['ha_movido_torre_negra_dcha'] == false)) &&
        hayEnroque(coordenadasAntiguasApi, coordenadasNuevasApi)) {
      int filaNueva = 0, columnaNueva = 0, filaAntigua = 0, columnaAntigua = 0;
      bool hayEnroque = false;

      List<bool> torreEnrocar = torreEnroque(coordenadasNuevasApi);

      if (jsonMapTablero['ha_movido_rey_blanco'] == false) {
        //Si se trata de un enroque con la torre blanca izquierda
        if (torreEnrocar[0]) {
          print("ENROQUE BLANCA IZQUIERDA");
          filaNueva = filaSeleccionada;
          columnaNueva = columnaSeleccionada - 1;
          filaAntigua = 7;
          columnaAntigua = 0;

          jsonMapTablero['ha_movido_torre_blanca_izqda'] = true;
          hayEnroque = true;
        } else if (torreEnrocar[1]) {
          print("ENROQUE BLANCA DERECHA");
          filaNueva = filaSeleccionada;
          columnaNueva = columnaSeleccionada + 1;
          filaAntigua = 7;
          columnaAntigua = 7;

          jsonMapTablero['ha_movido_torre_blanca_dcha'] = true;
          hayEnroque = true;
        }
      } else if (jsonMapTablero['ha_movido_rey_negro'] == false) {
        if (torreEnrocar[3]) {
          print("ENROQUE NEGRA IZQUIERDA");
          filaNueva = filaSeleccionada;
          columnaNueva = columnaSeleccionada + 1;
          filaAntigua = 0;
          columnaAntigua = 7;

          jsonMapTablero['ha_movido_torre_negra_izqda'] = true;
          hayEnroque = true;
        } else if (torreEnrocar[2]) {
          print("ENROQUE NEGRA DERECHA");
          filaNueva = filaSeleccionada;
          columnaNueva = columnaSeleccionada - 1;
          filaAntigua = 0;
          columnaAntigua = 0;

          jsonMapTablero['ha_movido_torre_negra_dcha'] = true;
          hayEnroque = true;
        }
      }

      if (hayEnroque) {
        tablero[filaNueva][columnaNueva] = tablero[filaAntigua][columnaAntigua];
        tablero[filaAntigua][columnaAntigua] = null;

        List<int> auxAntiguasApi =
            convertirAppToApi(filaAntigua, columnaAntigua);
        List<int> auxNuevasApi = convertirAppToApi(filaNueva, columnaNueva);
        //Esto se puede cambiar con asignación de variables pedazo de vago
        jsonMapTablero.forEach((tipoPieza, listaPiezas) {
          if (listaPiezas is List) {
            // Itera sobre cada pieza en la lista
            for (var pieza in listaPiezas) {
              // Verifica si las coordenadas coinciden con las coordenadas antiguas
              if (pieza['x'] == auxAntiguasApi[0] &&
                  pieza['y'] == auxAntiguasApi[1]) {
                // Modifica las coordenadas con las nuevas coordenadas
                pieza['x'] = auxNuevasApi[0];
                pieza['y'] = auxNuevasApi[1];
                break;
              }
            }
          }
        });
      }
    }

    //Marcamos que la pieza rey ha sido movida para que el backend no permita enrocar
    if (piezaSeleccionada!.tipoPieza == TipoPieza.rey) {
      if (piezaSeleccionada!.esBlanca) {
        jsonMapTablero['ha_movido_rey_blanco'] = true;
      } else {
        jsonMapTablero['ha_movido_rey_negro'] = true;
      }
    }

    //Esto igual, se puede cambiar con asignación de variables

    if (!hayCoronacion) {
      jsonMapTablero.forEach((tipoPieza, listaPiezas) {
        if (listaPiezas is List) {
          // Itera sobre cada pieza en la lista
          for (var pieza in listaPiezas) {
            // Verifica si las coordenadas coinciden con las coordenadas antiguas
            if (pieza['x'] == coordenadasAntiguasApi[0] &&
                pieza['y'] == coordenadasAntiguasApi[1]) {
              // Modifica las coordenadas con las nuevas coordenadas
              pieza['x'] = coordenadasNuevasApi[0];
              pieza['y'] = coordenadasNuevasApi[1];
              break;
            }
          }
        }
      });
    }
    hayCoronacion = false;

    if (meToca) {
      meToca = false;
    } else {
      meToca = true;
    }

    //Enviamos el tablero con la posible jugada
    //bool jugadaValida = await _postTablero();

    print('TABLERO DESPUÉS DE MOVER LA PIEZA\n');
    print(jsonString);

    jsonString = jsonEncode(jsonMapTablero);

    bool jugadaValida = await enviarTab(jsonString);

    if (!jugadaValida) {
      print('Jugada no valida');
      //devolvemos el string a su estado original
      jsonString = jsonEncode(jsonMapTableroAntiguo);
      jsonMapTablero = jsonMapTableroAntiguo;
      //PONER VARIABLES DE CONTROL A FALSE
      hayJaque = false;
      hayJaqueMate = false;
      hayTablas = false;
      return;
    }

    print("JAQUE MATE: " + hayJaqueMate.toString());
    // Convertir el mapa en formato JSON
    if (!finPartida) {
      // Crear un mapa que contenga el tablero y el roomIdP
      Map<String, dynamic> data = {
        'tableroEnviar': jsonString,
        'roomId': roomIdP.toString()
      };
      print(data);
      // Enviar el tablero al servidor
      //socket.emit("move", {data});

      print('Jugada valida');
      tablero[filaNueva][columnaNueva] = piezaSeleccionada as PiezaAjedrez;
      tablero[filaSeleccionada][columnaSeleccionada] = null;
      postTab(jsonString);
    }

    //limpiamos la selección
    setState(() {
      piezaSeleccionada = null;
      filaSeleccionada = -1;
      columnaSeleccionada = -1;
      movimientosValidos = [];
      movimientoRealizado = true;
    });
  }

  Future<bool> enviarTab(String tablero) async {
    Uri uri = Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/play/');
    http.Response response = await http.post(
      uri,
      body: tablero,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    if (response.statusCode == 200) {
      print('TABLERO ENVIADO');
      jsonMapMovimientos = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonMapMovimientos['allMovements'] != null) {
        if (jsonMapMovimientos['jaque'] as bool) {
          print('JAQUE');
          print(jsonMapMovimientos);
          hayJaque = true;
        } else {
          hayJaque = false;
        }
        print('MOVIMIENTOS VÁLIDOS\n');
        print(jsonMapMovimientos);
      } else if (jsonMapMovimientos['jaqueMate'] as bool) {
        print('JAQUE MATE');
        hayJaqueMate = jsonMapMovimientos['jaqueMate'] as bool;
        return true;
      } else if (jsonMapMovimientos['tablas'] as bool) {
        print('TABLAS');
        hayTablas = jsonMapMovimientos['tablas'] as bool;
        return true;
      }
      return jsonMapMovimientos['jugadaLegal'] as bool;
    } else {
      throw Exception('Error en la solicitud POST: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(49, 45, 45, 1),
        child: Column(
          children: [
            // MODO DE JUEGO
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'PARTIDA ASÍNCRONA',
                style: GoogleFonts.play(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            // PlayRow de Jugador 1
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.0),
                child: Text(
                  !soyBlancas
                      ? player1.playerName.toString()
                      : player2.playerName.toString(),
                  style: GoogleFonts.play(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            // TABLERO
            Expanded(
              flex: 4, // Ajusta este valor según tus necesidades
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: finPartida && (hayJaqueMate || hayTablas)
                    ? FinPartida(
                        esColorBlanca: !esTurnoBlancas,
                        esJaqueMate: hayJaqueMate,
                        esAhogado: hayTablas)
                    : GridView.builder(
                        itemCount: 8 * 8,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                        ),
                        itemBuilder: (context, index) {
                          int fila = index ~/ 8;
                          int columna = index % 8;

                          bool seleccionada = filaSeleccionada == fila &&
                              columnaSeleccionada == columna;

                          bool esValido = movimientosValidos.any((position) =>
                              position[0] == fila && position[1] == columna);

                          return CasillaAjedrez(
                            seleccionada: seleccionada,
                            esBlanca: esBlanca(index),
                            pieza: tablero[fila][columna],
                            esValido: esValido,
                            onTap: () => !movimientoRealizado
                                ? seleccionadaPieza(fila, columna)
                                : null,
                            colorCasillaBlanca: Color(0xFFADF597),
                            colorCasillaNegra: Color(0XFF2E960F),
                          );
                        },
                      ),
              ),
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // PlayRow de Jugador 2
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.0),
                child: Text(
                  soyBlancas
                      ? player1.playerName.toString()
                      : player2.playerName.toString(),
                  style: GoogleFonts.play(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Se muestra si la partida ha finalizado
                finPartida
                    ? Text(
                        'PARTIDA FINALIZADA',
                        style: GoogleFonts.play(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox(), // Espacio vacío si la partida no ha finalizado
                // Se muestra si es posible rendirse
                !finPartida && salir
                    ? Container(
                        // Contenedor con pregunta y botones de sí y no
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                '¿Estás seguro de que quieres salir?',
                                style: GoogleFonts.play(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    //postTab(jsonString);
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => PartidasAsincronas(id: idUsuario, modoJuego: Modos.ASINCRONO)));
                                    Navigator.of(context).pop();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.red,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Sí',
                                    style: GoogleFonts.play(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      //posibleRendicion = false; // Cambia el estado de posibleRendicion
                                    });
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.grey,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'No',
                                    style: GoogleFonts.play(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : ElevatedButton(
                        // Botón de rendirse
                        onPressed: () {
                          // Realiza la lógica para rendirse o continuar la partida
                          setState(() {
                            salir = true;
                            //posibleRendicion = true; // Cambia el estado de posibleRendicion
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(255, 136, 0, 1),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: Text(
                          'SALIR',
                          style: GoogleFonts.play(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                if (hayCoronacion)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Acción a realizar cuando se toca la pieza dama
                              tipoPiezaCoronada = TipoPieza.dama;
                              terminadaCoronacion = true;
                            },
                            child: PiezaCoronar(
                                esBlanca: esTurnoBlancas,
                                tipoPieza: TipoPieza.dama),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Acción a realizar cuando se toca la pieza alfil
                              tipoPiezaCoronada = TipoPieza.alfil;
                              terminadaCoronacion = true;
                            },
                            child: PiezaCoronar(
                                esBlanca: esTurnoBlancas,
                                tipoPieza: TipoPieza.alfil),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Acción a realizar cuando se toca la pieza caballo
                              tipoPiezaCoronada = TipoPieza.caballo;
                              terminadaCoronacion = true;
                            },
                            child: PiezaCoronar(
                                esBlanca: esTurnoBlancas,
                                tipoPieza: TipoPieza.caballo),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Acción a realizar cuando se toca la pieza torre
                              tipoPiezaCoronada = TipoPieza.torre;
                              terminadaCoronacion = true;
                            },
                            child: PiezaCoronar(
                                esBlanca: esTurnoBlancas,
                                tipoPieza: TipoPieza.torre),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
