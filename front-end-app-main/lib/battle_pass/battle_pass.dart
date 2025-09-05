import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../log_in/log_in_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class BattlePass extends StatefulWidget {
  int id = 0;
  BattlePass({Key? key, required this.id}) : super(key: key);
  @override
  _BattlePassState createState() => _BattlePassState();
}

class Tier {
  final int level;
  final String reward;
  final String rewardType;
  final String requiredPoints;

  Tier({
    required this.level,
    required this.reward,
    required this.rewardType,
    required this.requiredPoints,
  });
}

class UserBattlePass {
  int nivelpase;

  final int derrotas;
  final int victorias;
  final int empates;
  final int puntosexperiencia;

  UserBattlePass({
    required this.nivelpase,
    required this.derrotas,
    required this.victorias,
    required this.empates,
    required this.puntosexperiencia,
  });

  UserBattlePass.fromJson(Map<String, dynamic> json)
      : nivelpase = json['nivelpase'] as int,
        derrotas = json['derrotas'] as int,
        victorias = json['victorias'] as int,
        empates = json['empates'] as int,
        puntosexperiencia = json['puntosexperiencia'] as int;
}

final List<Tier> tiers = [
  Tier(level: 1, reward: '😁️', rewardType: 'emoticono', requiredPoints: '10'),
  Tier(level: 2, reward: 'alpha', rewardType: 'pieza', requiredPoints: '20'),
  Tier(level: 3, reward: '😂️', rewardType: 'emoticono', requiredPoints: '30'),
  Tier(level: 4, reward: 'cardinal', rewardType: 'pieza', requiredPoints: '40'),
  Tier(level: 5, reward: '👍️', rewardType: 'emoticono', requiredPoints: '50'),
  Tier(level: 6, reward: 'celtic', rewardType: 'pieza', requiredPoints: '60'),
  Tier(level: 7, reward: '😎️', rewardType: 'emoticono', requiredPoints: '70'),
  Tier(level: 8, reward: 'chess7', rewardType: 'pieza', requiredPoints: '80'),
  Tier(level: 9, reward: '😭️', rewardType: 'emoticono', requiredPoints: '90'),
  Tier(
      level: 10,
      reward: 'chessnut',
      rewardType: 'pieza',
      requiredPoints: '100'),
  Tier(
      level: 11, reward: '😅️', rewardType: 'emoticono', requiredPoints: '110'),
  Tier(
      level: 12,
      reward: 'companion',
      rewardType: 'pieza',
      requiredPoints: '120'),
  Tier(
      level: 13, reward: '👊️', rewardType: 'emoticono', requiredPoints: '130'),
  Tier(
      level: 14, reward: 'fantasy', rewardType: 'pieza', requiredPoints: '140'),
  Tier(
      level: 15, reward: '🤩️', rewardType: 'emoticono', requiredPoints: '150'),
  Tier(level: 16, reward: 'fresca', rewardType: 'pieza', requiredPoints: '160'),
  Tier(
      level: 17, reward: '🤯️', rewardType: 'emoticono', requiredPoints: '170'),
  Tier(
      level: 18,
      reward: 'governor',
      rewardType: 'pieza',
      requiredPoints: '180'),
  Tier(
      level: 19, reward: '😜️', rewardType: 'emoticono', requiredPoints: '190'),
  Tier(level: 20, reward: 'kosal', rewardType: 'pieza', requiredPoints: '200'),
  Tier(
      level: 21, reward: '🫠️', rewardType: 'emoticono', requiredPoints: '210'),
  Tier(
      level: 22, reward: 'leipzig', rewardType: 'pieza', requiredPoints: '220'),
  Tier(
      level: 23, reward: '😎️', rewardType: 'emoticono', requiredPoints: '230'),
  Tier(
      level: 24, reward: 'mpchess', rewardType: 'pieza', requiredPoints: '240'),
  Tier(
      level: 25, reward: '😡️', rewardType: 'emoticono', requiredPoints: '250'),
  Tier(level: 26, reward: 'pixel', rewardType: 'pieza', requiredPoints: '260'),
  Tier(
      level: 27, reward: '😈️', rewardType: 'emoticono', requiredPoints: '270'),
  Tier(
      level: 28, reward: 'maestro', rewardType: 'pieza', requiredPoints: '280'),
  Tier(
      level: 29, reward: '👻️', rewardType: 'emoticono', requiredPoints: '290'),
  Tier(
      level: 30,
      reward: 'anarcandy',
      rewardType: 'pieza',
      requiredPoints: '300'),
];

Future<UserBattlePass> leerDatosUsuario(int id) async {
  final url =
      Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/$id');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final userMap = jsonDecode(response.body) as Map<String, dynamic>;
    UserBattlePass user = UserBattlePass.fromJson(userMap);
    return user;
  } else {
    throw Exception('Failed to load user');
  }
}

class _BattlePassState extends State<BattlePass> {
  int puntos = 0;
  int id = 0;
  UserBattlePass user = UserBattlePass(
      nivelpase: 0,
      derrotas: 0,
      victorias: 0,
      empates: 0,
      puntosexperiencia: 0);

  @override
  void initState() {
    id = widget.id;
    print('ID DE USUARIO: $id');
    _establecerDatosUsuario();
    super.initState();
  }

  Future<void> _establecerDatosUsuario() async {
    user = await leerDatosUsuario(id);
    setState(() {
      user = user;
    });
    puntos = user
        .puntosexperiencia; //victorias.toInt()*4 + user.empates.toInt()*2 + user.derrotas.toInt();
    print('PUNTOS: $puntos, NIVEL DEL PASE: ${user.nivelpase}');
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
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(49, 45, 45, 1),
              title: Text(
                'Pase de Batalla',
                style: TextStyle(color: Colors.white, fontFamily: 'Oswald'),
              ),
            ),
            body: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
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
                      onPressed: () async {
                        if (value.logueado) {
                          int ultimoNivel = puntos ~/ 10;
                          print('NIVEL DEL PASE estimado: $ultimoNivel');
                          if (ultimoNivel > user.nivelpase) {
                            Uri url = Uri.parse(
                                'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_nivel_pase/$id');
                            print(ultimoNivel.toString());
                            Map<String, dynamic> bodyData = {
                              'nivelPase': ultimoNivel.toString(),
                            };
                            String jsonData = jsonEncode(bodyData);
                            final response = await http.post(url,
                                body: jsonData,
                                headers: {'Content-Type': 'application/json'});
                            print('enviado');
                            if (response.statusCode == 500) {
                              print(
                                  'No se ha podido actualizar el nivel del pase');
                            } else if (response.statusCode == 200) {
                              print('Nivel del pase actualizado');
                            } else if (response.statusCode == 400) {
                              print('No proporcionados');
                            }
                          }
                        }
                      },
                      child: Text(
                        'RECLAMAR TODAS RECOMPENSAS',
                        style: TextStyle(
                            color: Color.fromRGBO(49, 45, 45, 1),
                            fontFamily: 'Oswald'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tiers.length,
                      itemBuilder: (context, index) {
                        final tier = tiers[index];
                        return Card(
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Color.fromRGBO(49, 45, 45, 1),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recompensa ${tier.level}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Oswald',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Puntos requeridos: ${tier.requiredPoints}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.orange,
                                          fontFamily: 'Oswald'),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Tipo de recompensa: ${tier.rewardType}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.orange,
                                          fontFamily: 'Oswald'),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (tier.rewardType == 'pieza') ...[
                                      SvgPicture.asset(
                                        'assets/images/images_pase/pieces/${tier.reward}/bK.svg',
                                        width: 46,
                                        height: 46,
                                      ),
                                      SizedBox(width: 8),
                                      SvgPicture.asset(
                                        'assets/images/images_pase/pieces/${tier.reward}/wQ.svg',
                                        width: 46,
                                        height: 46,
                                      ),
                                    ],
                                    if (tier.rewardType == 'emoticono')
                                      Text(
                                        tier.reward,
                                        style: TextStyle(
                                            fontSize: 46, color: Colors.white),
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    tier.level <= user.nivelpase
                                        ? Image.asset(
                                            'assets/images/check.png',
                                            width: 30,
                                            height: 30,
                                          )
                                        : tier.level > puntos ~/ 10
                                            ? Image.asset(
                                                'assets/images/lock.png',
                                                width: 30,
                                                height: 30,
                                              )
                                            : Image.asset(
                                                'assets/images/unlock.png',
                                                width: 30,
                                                height: 30,
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




//  class _BattlePassState extends State<BattlePass> {
//   int puntos = 0;
//   int id = 0;
//   UserBattlePass user = UserBattlePass(level: 0, rewardsClaimed: 0);
//   @override
//   void initState(){
//     puntos = widget.puntos;
//     id = widget.id;
//     print('ID DE USUARIO: $id');
//     _establecerDatosUsuario();
//     super.initState();
//   }

//   Future<void> _establecerDatosUsuario() async {
//     user = await leerDatosUsuario(id);
//     setState(() {
//       // Actualiza el estado del widget con los nuevos datos del usuario
//       user = user;
//     });
//   }

  
  
  
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoginState>( builder:(context,value,child) => Stack(children: [
//       Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/board2.jpg"),
//             fit: BoxFit.fill,
//           ),
//         ),
//       ),
//       Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Color.fromRGBO(49, 45, 45, 1),
//           title: Text('Pase de Batalla',
//               style: TextStyle(color: Colors.white, fontFamily: 'Oswald')),
//         ),
//         body: Container(
//           color: Colors.transparent,
//           child: ListView.builder(
//             itemCount: tiers.length,
//             itemBuilder: (context, index) {
//               final tier = tiers[index];
//               return Card(
//                 elevation: 3,
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 color: Color.fromRGBO(
//                     49, 45, 45, 1), // Cambia el color de fondo de la tarjeta
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Recompensa ${tier.level}',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Text('Puntos requeridos: ${tier.requiredPoints}',
//                               style: TextStyle(
//                                   fontSize: 14, color: Colors.orange)),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             'Tipo de recompensa: ${tier.rewardType}',
//                             style:
//                                 TextStyle(fontSize: 14, color: Colors.orange),
//                           )
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment
//                             .center, // Centra las imágenes y los emoticonos
//                         children: [
//                           if (tier.rewardType == 'pieza') ...[
//                             SvgPicture.asset(
//                               'assets/images/images_pase/pieces/${tier.reward}/bK.svg',
//                               width: 42,
//                               height: 42,
//                             ),
//                             SizedBox(width: 8),
//                             SvgPicture.asset(
//                               'assets/images/images_pase/pieces/${tier.reward}/wQ.svg',
//                               width: 42,
//                               height: 42,
//                             ),
//                           ],
//                           if (tier.rewardType == 'emoticono')
//                             Text(
//                               tier.reward,
//                               style:
//                                   TextStyle(fontSize: 42, color: Colors.white),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             right: 16,
//             child: ElevatedButton(
//               onPressed: () async {
//                 if (puntos >= int.parse(tier.requiredPoints) &&
//                     value.logueado &&
//                     tier.level > user.rewardsClaimed) {
//                   Uri url = Uri.parse(
//                       'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_recompensa/${value.id}/${tier.level}');
//                   final response = await http.put(url, body: {});
//                   if (response.statusCode == 500) {
//                     print('No se ha podido reclamar');
//                   } else if (response.statusCode == 200) {
//                     print('Recompensa reclamada');
//                     user.rewardsClaimed++;
//                     Uri url = Uri.parse(
//                         'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_nivel_pase/${value.id}');
//                     final response = await http.put(url,
//                         body: {"recompensamasalta": user.rewardsClaimed.toString()});
//                     if (response.statusCode == 500) {
//                       print('No se ha podido actualizar las recompenas reclamadas');
//                     } else if (response.statusCode == 200) {
//                       print('Recompensas actualizadas reclamadas');
//                     }
//                   }
//                 }
//               },
//               child: Text(
//                 puntos >= int.parse(tier.requiredPoints) &&
//                         value.logueado == true &&
//                         tier.level > user.rewardsClaimed
//                     ? 'Reclamar'
//                     : (puntos >= int.parse(tier.requiredPoints) &&
//                             value.logueado == true &&
//                             tier.level <= user.rewardsClaimed)
//                         ? 'Reclamado'
//                         : 'No disponible',
//                 style: TextStyle(
//                     color: puntos >= int.parse(tier.requiredPoints) &&
//                             value.logueado == true &&
//                             tier.level > user.rewardsClaimed
//                         ? Colors.blue
//                         : (puntos >= int.parse(tier.requiredPoints) &&
//                                 value.logueado == true &&
//                                 tier.level <= user.rewardsClaimed)
//                             ? Colors.grey
//                             : const Color.fromARGB(255, 39, 39, 39)),
//               ),
//         ),
//       ),
//         ),
//       ),
//     ),
//     ],
//     ),
    
//     );
//   }
// }
