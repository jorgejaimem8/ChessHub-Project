import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../log_in/log_in_screen.dart';
import '../settings/settings.dart';

class User {
  final int id;
  final String nombre;
  final int elo;

  User({required this.id, required this.nombre, required this.elo});

  // Constructor factory para crear un objeto User desde un mapa JSON
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        nombre = json['nombre'] as String,
        elo = json['elo'] as int;
}

class RankingScreenRapid extends StatefulWidget {
  @override
  _RankingScreenStateRapid createState() => _RankingScreenStateRapid();
}

class _RankingScreenStateRapid extends State<RankingScreenRapid> {
  List<User> users = [];
  int idUsuario = 0;
  @override
  void initState() {
    super.initState();
    fetchLeaderBoard();
  }

  Future<void> fetchLeaderBoard() async {
    final url = Uri.parse(
        'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/ranking/rapid');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final userMap = jsonDecode(response.body) as List<dynamic>;
      List<User> userList = [];
      userMap.forEach((userData) {
        userList.add(User.fromJson(userData as Map<String, dynamic>));
      });
      // Ordena la lista de usuarios por puntos en orden descendente
      userList.sort((a, b) => b.elo.compareTo(a.elo));
      setState(() {
        users = userList;
      });
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    int id = settingsController.session.value;

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
                  title: Text(
                    'Ranking RAPID',
                    style: TextStyle(color: Colors.white, fontFamily: 'Oswald'),
                  ),
                  backgroundColor: Color.fromRGBO(49, 45, 45, 1),
                ),
                body: Container(
                  color: Colors.transparent,
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      User user = users[index];
                      // Define el color de fondo de la caja
                      Color tileColor = Colors.transparent;
                      if (user.id == id) {
                        tileColor = Colors.orange[200]!;
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              '${index + 1}.\t ${user.nombre}.\t${user.elo} pts',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            // Establece el color de fondo de la caja
                            tileColor: tileColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ]));
  }
}
