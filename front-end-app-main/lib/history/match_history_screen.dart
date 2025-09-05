import 'package:flutter/material.dart';
import '../style/header.dart';

class Game {
  final String fecha;
  final String wl;
  final int elo;

  Game({required this.fecha, required this.wl, required this.elo});
}

class MatchHistory extends StatefulWidget {
  @override
  _MatchHistoryState createState() => _MatchHistoryState();
}

class _MatchHistoryState extends State<MatchHistory> {
  final List<Game> games = [
    Game(fecha: '10/10/10', elo: 30, wl: 'W'),
    Game(fecha: '11/10/10', elo: 27, wl: 'W'),
    Game(fecha: '11/10/10', elo: 25, wl: 'W'),
    Game(fecha: '12/10/10', elo: 32, wl: 'W'),
    Game(fecha: '12/10/10', elo: -15, wl: 'L'),
    Game(fecha: '15/10/10', elo: -20, wl: 'L'),
    Game(fecha: '16/10/10', elo: 32, wl: 'W'),
    Game(fecha: '16/10/10', elo: -15, wl: 'L'),
    Game(fecha: '17/10/10', elo: -20, wl: 'L'),
    Game(fecha: '18/10/10', elo: 32, wl: 'W'),
    Game(fecha: '19/10/10', elo: -15, wl: 'L'),
    Game(fecha: '19/10/10', elo: -20, wl: 'L'),
    Game(fecha: '20/10/10', elo: 32, wl: 'W'),
    Game(fecha: '20/10/10', elo: -15, wl: 'L'),
    Game(fecha: '21/10/10', elo: 33, wl: 'W'),
    // Añade más games aquí...
  ];

  @override
  Widget build(BuildContext context) {
    // Ordena la lista de usuarios por puntos en orden descendente
    return Stack(children: [
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
          title: Text(
            'Historial',
            style: TextStyle(color: Colors.white, fontFamily: 'Oswald'),
          ),
          backgroundColor: Color.fromRGBO(49, 45, 45, 1),
        ),
        body: Container(
          color: Colors.transparent,
          child: ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Color.fromRGBO(
                    49, 45, 45, 1), // Cambia el color de fondo de la tarjeta
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha: ${game.fecha}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('W/L: ${game.wl}',
                          style: TextStyle(fontSize: 18, color: Colors.orange)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text('+/-: ${game.elo}',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.orange)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      )
    ]);
  }
}
