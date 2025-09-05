import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../log_in/log_in_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Set {
  final String name;
  final int level;
  Set({
    required this.name,
    required this.level,
  });
}

final List<Set> sets = [
  Set(name: 'defecto', level: 0),
  Set(name: 'alpha', level: 2),
  Set(name: 'cardinal', level: 4),
  Set(name: 'celtic', level: 6),
  Set(name: 'chess7', level: 8),
  Set(name: 'chessnut', level: 10),
  Set(name: 'companion', level: 12),
  Set(name: 'fantasy', level: 14),
  Set(name: 'fresca', level: 16),
  Set(name: 'governor', level: 18),
  Set(name: 'kosal', level: 20),
  Set(name: 'leipzig', level: 22),
  Set(name: 'mpchess', level: 24),
  Set(name: 'pixel', level: 26),
  Set(name: 'maestro', level: 28),
  Set(name: 'anarcandy', level: 30),
];

class Emote {
  final String emoji;
  final int level;
  Emote({
    required this.emoji,
    required this.level,
  });
}

final List<Emote> emotes = [
  Emote(emoji: '😁️', level: 1),
  Emote(emoji: '😂️', level: 3),
  Emote(emoji: '👍️', level: 5),
  Emote(emoji: '😎️', level: 7),
  Emote(emoji: '😭️', level: 9),
  Emote(emoji: '😅️', level: 11),
  Emote(emoji: '👊️', level: 13),
  Emote(emoji: '🤩️', level: 15),
  Emote(emoji: '🤯️', level: 17),
  Emote(emoji: '😜️', level: 19),
  Emote(emoji: '🫠️', level: 21),
  Emote(emoji: '😎️', level: 23),
  Emote(emoji: '😡️', level: 25),
  Emote(emoji: '😈️', level: 27),
  Emote(emoji: '👻️', level: 29),
];

class NivelPase {
  final int nivel;
  NivelPase({
    required this.nivel,
  });
  NivelPase.fromJson(Map<String, dynamic> json)
      : nivel = json['nivelpase'] as int;
}

class Personalizacion extends StatefulWidget {
  int id = 0;
  Personalizacion({Key? key, required this.id}) : super(key: key);

  @override
  _PersonalizacionState createState() => _PersonalizacionState();
}

Future<NivelPase> leerDatosUsuario(int id) async {
  final url =
      Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/$id');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    NivelPase nivelPase = NivelPase.fromJson(data);
    return nivelPase;
  } else {
    throw Exception('Error al leer los datos del usuario');
  }
}

class _PersonalizacionState extends State<Personalizacion> {
  late NivelPase nivelPase;
  late int id;
  late List<bool> pressedSets;
  late List<bool> pressedEmotes;
  List<String> emojislist = ["😁️", "😁️", "😁️", "😁️"];
  List<int> emotesPulsados = [];

  @override
  void initState() {
    id = widget.id;
    nivelPase = NivelPase(nivel: 0);
    pressedSets = List.generate(sets.length, (index) => false);
    pressedEmotes = List.generate(emotes.length, (index) => false);
    _establecerDatosUsuario();
    super.initState();
  }

  Future<void> _establecerDatosUsuario() async {
    nivelPase = await leerDatosUsuario(id);
    setState(() {
      nivelPase = nivelPase;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (context, value, child) => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/board2.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          DefaultTabController(
            initialIndex: 0,
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(49, 45, 45, 1),
                title: Text('Personalización',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Oswald')),
                bottom: TabBar(
                  labelColor: Color.fromRGBO(255, 136, 0, 1),
                  indicatorColor: Color.fromRGBO(255, 136, 0, 1),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.brush),
                    ),
                    Tab(
                      icon: Icon(Icons.emoji_emotions),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  _buildSetListView(value),
                  _buildEmoteListView(value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetListView(LoginState value) {
    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: sets.length,
        itemBuilder: (context, index) {
          final set = sets[index];

          return _buildCard(
            name: set.name,
            onPressed: () async {
              _activateSet(index, value, set.name);
            },
            isActive: pressedSets[index],
            isEnabled: value.logueado == true && nivelPase.nivel >= set.level,
          );
        },
      ),
    );
  }

  Widget _buildEmoteListView(LoginState value) {
    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: emotes.length,
        itemBuilder: (context, index) {
          final emote = emotes[index];

          return _buildCard(
            name: emote.emoji,
            onPressed: () async {
              // emojislist.removeAt(0);
              // emojislist.add(emote.emoji);
              _activateEmote(index, value, emote.emoji);
            },
            isActive: pressedEmotes[index],
            isEnabled: value.logueado == true && nivelPase.nivel >= emote.level,
          );
        },
      ),
    );
  }

  Widget _buildCard({
    required String name,
    required VoidCallback onPressed,
    required bool isActive,
    required bool isEnabled,
  }) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: Color.fromRGBO(49, 45, 45, 1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$name',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            if (name.length >= 5)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/images_pase/pieces/$name/bK.svg',
                    width: 42,
                    height: 42,
                  ),
                  SvgPicture.asset(
                    'assets/images/images_pase/pieces/$name/wQ.svg',
                    width: 42,
                    height: 42,
                  ),
                ],
              ),
            if (name == 'DEFECTO')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/bK.svg',
                    width: 42,
                    height: 42,
                  ),
                  SvgPicture.asset(
                    'assets/images/wQ.svg',
                    width: 42,
                    height: 42,
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: isEnabled ? onPressed : null,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    isActive ? Colors.green : Colors.transparent),
              ),
              child: Text(
                isActive
                    ? 'Activado'
                    : (isEnabled ? 'Activar' : 'No Disponible'),
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : (isEnabled ? Colors.green : Colors.red),
                  fontFamily: 'Oswald',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _activateSet(int index, LoginState value, String setName) {
    setState(() {
      for (int i = 0; i < pressedSets.length; i++) {
        pressedSets[i] = i == index;
      }

      if (value.logueado == true && nivelPase.nivel >= sets[index].level) {
        _activateFichas(setName, id);
      }
    });
  }

  void _activateEmote(int index, LoginState value, String emoteName) {
    setState(() {
      if (emotesPulsados.length < 4) {
        emotesPulsados.add(index);
        emojislist.removeAt(0);
        emojislist.add(emoteName);
        for (int i = 0; i < pressedEmotes.length; i++) {
          if (emotesPulsados.contains(i)) {
            pressedEmotes[i] = true;
          } else {
            pressedEmotes[i] = false;
          }
        }
        if (value.logueado == true && nivelPase.nivel >= emotes[index].level) {
          _activateEmojis(emojislist, value.id);
        }
      } else {
        emotesPulsados.removeAt(0);
        emotesPulsados.add(index);
        emojislist.removeAt(0);
        emojislist.add(emoteName);
        for (int i = 0; i < pressedEmotes.length; i++) {
          pressedEmotes[i] = emotesPulsados.contains(i);
        }
        if (value.logueado == true && nivelPase.nivel >= emotes[index].level) {
          _activateEmojis(emojislist, value.id);
        }
      }
    });
  }

  void _activateFichas(String itemName, int id) {
    Uri url = Uri.parse(
        'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_set_piezas/$id');
    Map<String, dynamic> bodyData = {
      'setPiezas': itemName.toUpperCase(),
    };
    String jsonData = jsonEncode(bodyData);
    http.post(url,
        body: jsonData,
        headers: {'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode == 200) {
        print('$itemName activado');
      } else if (response.statusCode == 400) {
        print('Error al proporcionar $itemName');
      } else if (response.statusCode == 500) {
        print('Error al actualizar');
      } else {
        print('Error al activar $itemName');
      }
    });
  }

  void _activateEmojis(List<String> items, int id) {
    Uri url = Uri.parse(
        'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_emoticonos/$id');
    Map<String, dynamic> bodyData = {
      'emoticonos': items,
    };
    String jsonData = jsonEncode(bodyData);
    http.post(url,
        body: jsonData,
        headers: {'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode == 200) {
        print('$items activado');
      } else if (response.statusCode == 400) {
        print('Error al proporcionar $items');
      } else if (response.statusCode == 500) {
        print('Error al actualizar');
      } else {
        print('Error al activar $items');
      }
    });
  }
}























// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../log_in/log_in_screen.dart';
// import 'package:provider/provider.dart';
// import 'dart:async';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class Set {
//   final String name;
//   final int level;
//   Set({
//     required this.name,
//     required this.level,
//   });
// }

// final List<Set> sets = [
//   Set(name: 'alpha', level: 2),
//   Set(name: 'cardinal',level: 4),
//   Set(name: 'celtic', level: 6),
//   Set(name: 'chess7', level: 8),
//   Set(name: 'chessnut', level: 10),
//   Set(name: 'companion', level: 12),
//   Set(name: 'fantasy', level: 14),
//   Set(name: 'fresca', level: 16),
//   Set(name: 'governor', level: 18),
//   Set(name: 'kosal', level: 20),
//   Set(name: 'leipzig', level: 22),
//   Set(name: 'mpchess', level: 24),
//   Set(name: 'pixel', level: 26),
//   Set(name: 'maestro', level: 28),
//   Set(name: 'anarcandy', level: 30),
// ];

// class Emote {
//   final String emoji;
//   final int level;
//   Emote({
//     required this.emoji,
//     required this.level,
//   });
// }

// final List<Emote> emotes = [
//   Emote(emoji: '😁️', level: 1),
//   Emote(emoji: '😂️', level: 3),
//   Emote(emoji: '👍️', level: 5),
//   Emote(emoji: '😎️', level: 7),
//   Emote(emoji: '😭️', level: 9),
//   Emote(emoji: '😅️', level: 11),
//   Emote(emoji: '👊️', level: 13),
//   Emote(emoji: '🤩️', level: 15),
//   Emote(emoji: '🤯️', level: 17),
//   Emote(emoji: '😜️', level: 19),
//   Emote(emoji: '🫠️', level: 21),
//   Emote(emoji: '😎️', level: 23),
//   Emote(emoji: '😡️', level: 25),
//   Emote(emoji: '😈️', level: 27),
//   Emote(emoji: '👻️', level: 29),
// ];

// class NivelPase {
//   final int nivel;
//   NivelPase({
//     required this.nivel,
//   });
//   NivelPase.fromJson(Map<String, dynamic> json)
//       : nivel = json['nivelpase'] as int;
// }

// class Personalizacion extends StatefulWidget {
//   int id = 0;
//   Personalizacion({Key? key, required this.id}) : super(key: key);
  
//   @override
//   _PersonalizacionState createState() => _PersonalizacionState();
// }

// Future<NivelPase> leerDatosUsuario(int id) async {
//   // Aquí puedes programar la lógica para obtener los datos del usuario
//   // Por ejemplo, puedes obtener los datos del usuario desde una base de datos, una API, etc.
//   final url = Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/$id');
//   final response = await http.get(url);
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body) as Map<String, dynamic>;
//     NivelPase nivelPase = NivelPase.fromJson(data);
//     return nivelPase;
    
//   } else {
//     throw Exception('Error al leer los datos del usuario');
//   }
// }

// class _PersonalizacionState extends State<Personalizacion> {
//   NivelPase nivelPase = NivelPase(nivel: 0);
//   int id = 0;
//   List <bool> pressed = List.generate(sets.length+emotes.length, (index) => false);
//   @override
//   void initState() {
//     id = widget.id;
//     _establecerDatosUsuario();
//     super.initState();
//   }

//   Future<void> _establecerDatosUsuario() async {
//     // Aquí puedes programar la lógica para obtener los datos del usuario
//     // Por ejemplo, puedes obtener los datos del usuario desde una base de datos, una API, etc.
//     nivelPase = await leerDatosUsuario(id);
//     setState((){
//       nivelPase = nivelPase;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoginState>(
//       builder: (context, value, child) => Stack(children: [
//       Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/board2.jpg"),
//             fit: BoxFit.fill,
//           ),
//         ),
//       ),
//       DefaultTabController(
//         initialIndex: 0,
//         length: 2,
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Color.fromRGBO(49, 45, 45, 1),
//             title: Text('Personalización',
//                 style: TextStyle(color: Colors.white, fontFamily: 'Oswald')),
//             bottom: const TabBar(
//               labelColor: Color.fromRGBO(255, 136, 0, 1),
//               indicatorColor: Color.fromRGBO(255, 136, 0, 1),
//               overlayColor: MaterialStatePropertyAll(Colors.transparent),
//               tabs: <Widget>[
//                 Tab(
//                   icon: Icon(Icons.brush),
//                 ),
//                 Tab(
//                   icon: Icon(Icons.emoji_emotions),
//                 ),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: <Widget>[
//               Container(
//                 color: Colors.transparent,
//                 child: ListView.builder(
//                   itemCount: sets.length,
//                   itemBuilder: (context, index) {
//                     final set = sets[index];

//                     return Card(
//                       elevation: 3,
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                       color: Color.fromRGBO(49, 45, 45,
//                           1), // Cambia el color de fondo de la tarjeta
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               '${set.name}',
//                               style: TextStyle(
//                                 fontSize: 30,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset(
//                                   'assets/images/images_pase/pieces/${set.name}/bK.svg',
//                                   width: 42,
//                                   height: 42,
//                                 ),
//                                 SvgPicture.asset(
//                                   'assets/images/images_pase/pieces/${set.name}/wQ.svg',
//                                   width: 42,
//                                   height: 42,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 16),
//                             ElevatedButton(
//                                 onPressed: () async {
//                                   // Aquí puedes programar la lógica para el botón de este componente
//                                   // Por ejemplo, puedes navegar a otra pantalla, realizar una acción, etc.
//                                   if(value.logueado == true && nivelPase.nivel >= set.level){
//                                     //Aqui se activa el set
//                                     Uri url = Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_set_piezas/$id');
//                                     print(set.name.toString());
//                                     Map<String, dynamic> bodyData = {
//                                       'setPiezas': set.name,
//                                     };
//                                     String jsonData = jsonEncode(bodyData);
//                                     final response = await http.post(url,body : jsonData, headers: {'Content-Type': 'application/json'});
//                                     if (response.statusCode == 200) {
//                                       print('Set ${set.name} activado');
//                                     } 
//                                     else if(response.statusCode == 400){
//                                       print('Error al proporcionar set');
//                                     }
//                                     else if(response.statusCode == 500){
//                                       print('Error al actualizar');
//                                     }
//                                     else {
//                                       print('Error al activar set');
//                                     }

//                                   }
//                                 },
//                                 child:  value.logueado == true && nivelPase.nivel >= set.level ? Text('Activar', style: TextStyle(color: Colors.green, fontFamily: 'Oswald'),) : Text('Nivel insuficiente', style: TextStyle(color: Colors.red, fontFamily: 'Oswald'),),),
//                         ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 color: Colors.transparent,
//                 child: ListView.builder(
//                   itemCount: emotes.length,
//                   itemBuilder: (context, index) {
//                     final emote = emotes[index];

//                     return Card(
//                       elevation: 3,
//                       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//                       color: Color.fromRGBO(49, 45, 45,
//                           1), // Cambia el color de fondo de la tarjeta
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text(
//                               '${emote.emoji}',
//                               style: TextStyle(
//                                 fontSize: 30,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             ElevatedButton(
//                                 onPressed: () async {
//                                   // Aquí puedes programar la lógica para el botón de este componente
//                                   // Por ejemplo, puedes navegar a otra pantalla, realizar una acción, etc.
//                                   if(value.logueado == true && nivelPase.nivel >= emote.level){
//                                     //Aqui se activa el set
//                                     Uri url = Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_emoticonos/$id');
//                                     print(emote.emoji.toString());
//                                     Map<String, dynamic> bodyData = {
//                                       'emoticonos': emote.emoji,
//                                     };
//                                     String jsonData = jsonEncode(bodyData);
//                                     final response = await http.post(url,body : jsonData, headers: {'Content-Type': 'application/json'});
//                                     if (response.statusCode == 200) {
//                                       print('Set ${emote.emoji} activado');
//                                     } 
//                                     else if(response.statusCode == 400){
//                                       print('Error al proporcionar set');
//                                     }
//                                     else if(response.statusCode == 500){
//                                       print('Error al actualizar');
//                                     }
//                                     else {
//                                       print('Error al activar set');
//                                     }

//                                   }
//                                 },
//                                 child:  value.logueado == true && nivelPase.nivel >= emote.level ? Text('Activar', style: TextStyle(color: Colors.green, fontFamily: 'Oswald')) : Text('Nivel insuficiente', style: TextStyle(color: Colors.red, fontFamily: 'Oswald'),),),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ]));
//   }
// }
