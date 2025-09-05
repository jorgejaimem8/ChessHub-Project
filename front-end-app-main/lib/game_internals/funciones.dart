//Nombre: funciones.dart
//Descripción: Contiene las funciones necesarias para el juego de ajedrez.
import 'dart:io';

import 'package:ChessHub/local_game_sesion/pieza_ajedrez.dart';
import 'package:ChessHub/constantes/constantes.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

bool esBlanca(int index) {
  int x = index ~/ 8;
  int y = index % 8;
  bool res = (x + y) % 2 == 0;

  return res;
}

String nombrePieza(PiezaAjedrez? tipoPieza) {
  String pieza = '';

  if (tipoPieza!.tipoPieza == TipoPieza.peon) {
    pieza = 'peon';
  } else if (tipoPieza.tipoPieza == TipoPieza.torre) {
    pieza = 'torre';
  } else if (tipoPieza.tipoPieza == TipoPieza.alfil) {
    pieza = 'alfil';
  } else if (tipoPieza.tipoPieza == TipoPieza.caballo) {
    pieza = 'caballo';
  } else if (tipoPieza.tipoPieza == TipoPieza.rey) {
    pieza = 'rey';
  } else if (tipoPieza.tipoPieza == TipoPieza.dama) {
    pieza = 'dama';
  }

  return pieza;
}

List<Color> getColorCasilla(String arena) {
  List<Color> colorCasilla = [];
  print('Arenita mejillas: $arena');
  if (arena == "Madera") {
    colorCasilla.add(Color(0xFF8B4513));
    colorCasilla.add(Color(0xFFD2B48C));
  } else if (arena == "Marmol") {
    colorCasilla.add(Color(0xFFf5f5f5));
    colorCasilla.add(Color(0xFFB8B8B8));
  } else if (arena == "Oro") {
    colorCasilla.add(Color(0xFFFFEA70));
    colorCasilla.add(Color(0xFFF5D000));
  } else if (arena == "Esmeralda") {
    colorCasilla.add(Color(0xFF50C878));
    colorCasilla.add(Color(0xFF38A869));
  } else if (arena == "Diamante") {
    colorCasilla.add(Color(0xFFF0F0F0));
    colorCasilla.add(Color(0xFFB0E0E6));
  } else {
    colorCasilla.add(Color(0xFFF0F0F0));
    colorCasilla.add(Color(0xFFB0E0E6));
  }

  return colorCasilla;
}

String nombrePiezaTipo(TipoPieza tipoPieza) {
  String pieza = '';

  if (tipoPieza == TipoPieza.peon) {
    pieza = 'peon';
  } else if (tipoPieza == TipoPieza.torre) {
    pieza = 'torre';
  } else if (tipoPieza == TipoPieza.alfil) {
    pieza = 'alfil';
  } else if (tipoPieza == TipoPieza.caballo) {
    pieza = 'caballo';
  } else if (tipoPieza == TipoPieza.rey) {
    pieza = 'rey';
  } else if (tipoPieza == TipoPieza.dama) {
    pieza = 'dama';
  }

  return pieza;
}

String obtenerRutaImagen(TipoPieza tipoPieza, bool esBlanca) {
  String colorPrefix = esBlanca ? 'w' : 'b';
  String pieceName;

  switch (tipoPieza) {
    case TipoPieza.peon:
      pieceName = 'pawn';
      break;
    case TipoPieza.torre:
      pieceName = 'rook';
      break;
    case TipoPieza.caballo:
      pieceName = 'knight';
      break;
    case TipoPieza.alfil:
      pieceName = 'bishop';
      break;
    case TipoPieza.dama:
      pieceName = 'queen';
      break;
    case TipoPieza.rey:
      pieceName = 'king';
      break;
  }

  return 'assets/images/$pieceName-$colorPrefix.svg';
}

String obtenerModo(Modos modo) {
  switch (modo) {
    case Modos.BLITZ:
      return 'Blitz';
    case Modos.RAPID:
      return 'Rapid';
    case Modos.BULLET:
      return 'Bullet';
    case Modos.ASINCRONO:
      return 'Correspondencia';
  }
}

// Función para convertir coordenadas de la aplicación a las de la API
List<int> convertirAppToApi(int fila, int columna) {
  int xApi = columna;
  int yApi = TAMANYO_TABLERO - fila - 1;
  return [xApi, yApi];
}

// Función para convertir coordenadas de la API a las de la aplicación
List<int> convertirApiToApp(int xApi, int yApi) {
  int filaApp = TAMANYO_TABLERO - yApi - 1;
  int columnaApp = xApi;
  return [filaApp, columnaApp];
}

//Función para determinar si un enroque se ha realizado
bool hayEnroque(
    List<int> coordenadasAntiguasApi, List<int> coordenadasNuevasApi) {
  return (coordenadasNuevasApi[0] - coordenadasAntiguasApi[0]).abs() == 2;
}

List<bool> torreEnroque(List<int> coordenadasNuevasApi) {
  List<bool> res = [false, false, false, false];
  //Enroque blanco blanco izquierda
  if (coordenadasNuevasApi[0] == 2 && coordenadasNuevasApi[1] == 0) {
    res[0] = true;
  }
  //Enroque blanco blanco derecha
  else if (coordenadasNuevasApi[0] == 6 && coordenadasNuevasApi[1] == 0) {
    res[1] = true;
  }
  //Enroque negro derecha
  else if (coordenadasNuevasApi[0] == 2 && coordenadasNuevasApi[1] == 7) {
    res[2] = true;
  }
  //Enroque negro izquierda
  else if (coordenadasNuevasApi[0] == 6 && coordenadasNuevasApi[1] == 7) {
    res[3] = true;
  }
  return res;
}

String getImagePath(String nombrePieza, bool esBlanca, TipoPieza tipoPieza) {
  nombrePieza = nombrePieza.toLowerCase();
  String color = esBlanca ? 'w' : 'b';
  switch (tipoPieza) {
    case TipoPieza.alfil:
      return 'assets/images/images_pase/pieces/${nombrePieza}/${color}B.svg';
    case TipoPieza.caballo:
      return 'assets/images/images_pase/pieces/${nombrePieza}/${color}N.svg';
    case TipoPieza.torre:
      return 'assets/images/images_pase/pieces/${nombrePieza}/${color}R.svg';
    case TipoPieza.dama:
      return 'assets/images/images_pase/pieces/${nombrePieza}/${color}Q.svg';
    case TipoPieza.rey:
      return 'assets/images/images_pase/pieces/${nombrePieza}/${color}K.svg';
    case TipoPieza.peon:
      return 'assets/images/images_pase/pieces/${nombrePieza}/${color}P.svg';
    default:
      throw 'No existe imagen de pieza buscada'; // Si el tipo de pieza no coincide con ninguno conocido, devuelve una imagen predeterminada
  }
}

List<List<PiezaAjedrez?>> inicializarTablero(String nombre) {
  List<List<PiezaAjedrez?>> nuevoTablero =
      List.generate(8, (index) => List.generate(8, (index) => null));

  //Place pawn
  for (int i = 0; i < 8; i++) {
    nuevoTablero[1][i] = PiezaAjedrez(
        tipoPieza: TipoPieza.peon,
        esBlanca: false,
        nombreImagen: getImagePath(nombre, false, TipoPieza.peon));

    nuevoTablero[6][i] = PiezaAjedrez(
        tipoPieza: TipoPieza.peon,
        esBlanca: true,
        nombreImagen: getImagePath(nombre, true, TipoPieza.peon));
  }

  //Place rooks
  nuevoTablero[0][0] = PiezaAjedrez(
      tipoPieza: TipoPieza.torre,
      esBlanca: false,
      nombreImagen: getImagePath(nombre, false, TipoPieza.torre),
      ladoIzquierdo: true);
  nuevoTablero[0][7] = PiezaAjedrez(
      tipoPieza: TipoPieza.torre,
      esBlanca: false,
      nombreImagen: getImagePath(nombre, false, TipoPieza.torre),
      ladoIzquierdo: false);
  nuevoTablero[7][0] = PiezaAjedrez(
      tipoPieza: TipoPieza.torre,
      esBlanca: true,
      nombreImagen: getImagePath(nombre, true, TipoPieza.torre),
      ladoIzquierdo: true);
  nuevoTablero[7][7] = PiezaAjedrez(
      tipoPieza: TipoPieza.torre,
      esBlanca: true,
      nombreImagen: getImagePath(nombre, true, TipoPieza.torre),
      ladoIzquierdo: false);

  //Place knights
  nuevoTablero[0][1] = PiezaAjedrez(
      tipoPieza: TipoPieza.caballo,
      esBlanca: false,
      nombreImagen: getImagePath(nombre, false, TipoPieza.caballo));
  nuevoTablero[0][6] = PiezaAjedrez(
      tipoPieza: TipoPieza.caballo,
      esBlanca: false,
      nombreImagen: getImagePath(nombre, false, TipoPieza.caballo));
  nuevoTablero[7][1] = PiezaAjedrez(
      tipoPieza: TipoPieza.caballo,
      esBlanca: true,
      nombreImagen: getImagePath(nombre, true, TipoPieza.caballo));
  nuevoTablero[7][6] = PiezaAjedrez(
      tipoPieza: TipoPieza.caballo,
      esBlanca: true,
      nombreImagen: getImagePath(nombre, true, TipoPieza.caballo));

  //Place bishops
  nuevoTablero[0][2] = PiezaAjedrez(
      tipoPieza: TipoPieza.alfil,
      esBlanca: false,
      nombreImagen: getImagePath(nombre, false, TipoPieza.alfil));
  nuevoTablero[0][5] = PiezaAjedrez(
      tipoPieza: TipoPieza.alfil,
      esBlanca: false,
      nombreImagen: getImagePath(nombre, false, TipoPieza.alfil));
  nuevoTablero[7][2] = PiezaAjedrez(
      tipoPieza: TipoPieza.alfil,
      esBlanca: true,
      nombreImagen: getImagePath(nombre, true, TipoPieza.alfil));
  nuevoTablero[7][5] = PiezaAjedrez(
      tipoPieza: TipoPieza.alfil,
      esBlanca: true,
      nombreImagen: getImagePath(nombre, true, TipoPieza.alfil));

  //Place queens
  nuevoTablero[0][3] = PiezaAjedrez(
      tipoPieza: TipoPieza.dama,
      esBlanca: false,
      nombreImagen: getImagePath(nombre, false, TipoPieza.dama));
  nuevoTablero[7][3] = PiezaAjedrez(
      tipoPieza: TipoPieza.dama,
      esBlanca: true,
      nombreImagen: getImagePath(nombre, true, TipoPieza.dama));
  //Place kings
  nuevoTablero[0][4] = PiezaAjedrez(
      tipoPieza: TipoPieza.rey,
      esBlanca: false,
      nombreImagen: getImagePath(nombre, false, TipoPieza.rey));
  nuevoTablero[7][4] = PiezaAjedrez(
      tipoPieza: TipoPieza.rey,
      esBlanca: true,
      nombreImagen: getImagePath(nombre, true, TipoPieza.rey));

  return nuevoTablero;
}

Future<String> getNombre(String id) async {
  // Construye la URL y realiza la solicitud POST
  String nombre = '';
  //https://chesshub-api-ffvrx5sara-ew.a.run.app/play/
  print('OBTENIENDO INFORMACION DE USUARIO\n');
  Uri uri = Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/$id');
  http.Response response = await http.get(
    uri,
    headers: {
      HttpHeaders.contentTypeHeader:
          'application/json', // Especifica el tipo de contenido como JSON
    },
  );
  print('OBTENEIENDO DATOS DE USUARIO CONTRARIO EN PARTIDA AAAAAr');
  Map<String, dynamic> res = jsonDecode(response.body) as Map<String, dynamic>;

  if (response.statusCode == 200) {
    print(res);
    nombre = res['nombre'] as String;
  } else {
    throw Exception('Error en la solicitud GET: ${response.statusCode}');
  }

  return nombre;
}

// Función para inicializar el tablero a partir de un JSON
// Función para inicializar el tablero a partir de un JSON
List<List<PiezaAjedrez?>> inicializarTableroDesdeJson(
    Map<String, dynamic> jsonData, String tipoPiezaImagen) {
  List<List<PiezaAjedrez?>> nuevoTablero = List.generate(TAMANYO_TABLERO,
      (index) => List.generate(TAMANYO_TABLERO, (index) => null));

  // Colocar peones
  List<dynamic> peones = jsonData['peon'] as List<dynamic>;
  peones.forEach((peon) {
    int x = peon['x'] as int;
    int y = peon['y'] as int;
    List<int> coordenadas = convertirApiToApp(x, y);
    String color = peon['color'] as String;
    bool esBlanca = color == 'blancas';
    nuevoTablero[coordenadas[0]][coordenadas[1]] = PiezaAjedrez(
      tipoPieza: TipoPieza.peon,
      esBlanca: esBlanca,
      nombreImagen: getImagePath(tipoPiezaImagen, esBlanca, TipoPieza.peon),
    );
  });

  // Colocar alfiles
  List<dynamic> alfiles = jsonData['alfil'] as List<dynamic>;
  alfiles.forEach((alfil) {
    int x = alfil['x'] as int;
    int y = alfil['y'] as int;
    List<int> coordenadas = convertirApiToApp(x, y);
    String color = alfil['color'] as String;
    bool esBlanca = color == 'blancas';
    nuevoTablero[coordenadas[0]][coordenadas[1]] = PiezaAjedrez(
      tipoPieza: TipoPieza.alfil,
      esBlanca: esBlanca,
      nombreImagen: getImagePath(tipoPiezaImagen, esBlanca, TipoPieza.alfil),
    );
  });

  // Colocar caballos
  List<dynamic> caballos = jsonData['caballo'] as List<dynamic>;
  caballos.forEach((caballo) {
    int x = caballo['x'] as int;
    int y = caballo['y'] as int;
    List<int> coordenadas = convertirApiToApp(x, y);
    String color = caballo['color'] as String;
    bool esBlanca = color == 'blancas';
    nuevoTablero[coordenadas[0]][coordenadas[1]] = PiezaAjedrez(
      tipoPieza: TipoPieza.caballo,
      esBlanca: esBlanca,
      nombreImagen: getImagePath(tipoPiezaImagen, esBlanca, TipoPieza.caballo),
    );
  });

  // Colocar torres
  List<dynamic> torres = jsonData['torre'] as List<dynamic>;
  torres.forEach((torre) {
    int x = torre['x'] as int;
    int y = torre['y'] as int;
    List<int> coordenadas = convertirApiToApp(x, y);
    String color = torre['color'] as String;
    bool esBlanca = color == 'blancas';
    bool ladoIzquierdo = false;
    if (coordenadas[0] == 0 && coordenadas[1] == 0) {
      ladoIzquierdo = true;
    } else if (coordenadas[0] == 7 && coordenadas[1] == 0) {
      ladoIzquierdo = true;
    }

    nuevoTablero[coordenadas[0]][coordenadas[1]] = PiezaAjedrez(
      tipoPieza: TipoPieza.torre,
      esBlanca: esBlanca,
      nombreImagen: getImagePath(tipoPiezaImagen, esBlanca, TipoPieza.torre),
      ladoIzquierdo: ladoIzquierdo,
    );
  });

  // Colocar damas
  List<dynamic> damas = jsonData['dama'] as List<dynamic>;
  damas.forEach((dama) {
    int x = dama['x'] as int;
    int y = dama['y'] as int;
    List<int> coordenadas = convertirApiToApp(x, y);
    String color = dama['color'] as String;
    bool esBlanca = color == 'blancas';
    nuevoTablero[coordenadas[0]][coordenadas[1]] = PiezaAjedrez(
      tipoPieza: TipoPieza.dama,
      esBlanca: esBlanca,
      nombreImagen: getImagePath(tipoPiezaImagen, esBlanca, TipoPieza.dama),
    );
  });

  // Colocar reyes
  List<dynamic> reyes = jsonData['rey'] as List<dynamic>;
  reyes.forEach((rey) {
    int x = rey['x'] as int;
    int y = rey['y'] as int;
    List<int> coordenadas = convertirApiToApp(x, y);
    String color = rey['color'] as String;
    bool esBlanca = color == 'blancas';
    nuevoTablero[coordenadas[0]][coordenadas[1]] = PiezaAjedrez(
      tipoPieza: TipoPieza.rey,
      esBlanca: esBlanca,
      nombreImagen: getImagePath(tipoPiezaImagen, esBlanca, TipoPieza.rey),
    );
  });

  return nuevoTablero;
}
