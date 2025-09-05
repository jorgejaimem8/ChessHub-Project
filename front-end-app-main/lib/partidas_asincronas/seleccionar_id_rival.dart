import 'package:ChessHub/partidas_asincronas/menu_partidas_asincronas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../log_in/log_in_screen.dart';
import 'package:ChessHub/router.dart';
import 'package:go_router/go_router.dart';

class SeleccionarIdRival extends StatefulWidget {
  final int id;
  SeleccionarIdRival({Key? key, required this.id}) : super(key: key);

  @override
  _SeleccionarIdRivalState createState() => _SeleccionarIdRivalState();
}

class _SeleccionarIdRivalState extends State<SeleccionarIdRival> {
  int id = 0;
  late TextEditingController _idController;
  int? idRival = 0;
  @override
  void initState() {
    id = widget.id;
    _idController = TextEditingController();
    super.initState();
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
                'Seleccionar ID del Rival',
                style: TextStyle(color: Colors.white, fontFamily: 'Oswald'),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _idController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'ID del Rival',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        idRival = int.tryParse(value);
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(255, 136, 0, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_idController.text.isNotEmpty) {
                        _handleLogic(id, idRival);
                      }
                    },
                    child: Text('Crear Partida',
                        style: TextStyle(color: Color.fromRGBO(49, 45, 45, 1))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogic(int id, int? idRival) async {
    if (id != 0 && idRival != 0) {
      // Ejemplo de solicitud HTTP
      Uri url = Uri.parse(
          'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/register_partida_asincrona');
      Map<String, dynamic> requestData = {
        'usuarioBlancas': id,
        'usuarioNegras': idRival,
      };
      String jsonData = jsonEncode(requestData);
      print(jsonData);
      try {
        final response = await http.post(url,
            body: jsonData, headers: {'Content-Type': 'application/json'});
        if (response.statusCode == 200) {
          // Lógica para manejar la respuesta exitosa
          print('Solicitud exitosa');
          Uri url2 = Uri.parse(
              'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/update_partida_asincrona');
          
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Partida creada correctamente')));
        } else if (response.statusCode == 500) {
          // Lógica para manejar otros códigos de estado de respuesta
          print('Error en la solicitud: ${response.statusCode}');
        }
      } catch (e) {
        // Lógica para manejar errores de red
        print('Error de red: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error de red: $e')));
      }
    } else {
      context.go('/login');
    }
  }
}
