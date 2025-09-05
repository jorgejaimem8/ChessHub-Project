import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//import '../audio/audio_controller.dart';
//import '../audio/sounds.dart';
import '../settings/settings.dart';
//import '../style/my_button.dart';
//import '../style/palette.dart';
//import '../style/responsive_screen.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

void main() {
  runApp(RegisterScreen());
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
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
            title: Text('Registrar Cuenta',
                style: TextStyle(color: Colors.white, fontFamily: 'Oswald')),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: LoginFormWidget(),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});
  @override
  LoginFormWidgetState createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();

  String _username = '';
  String _password = '';
  String _mail = '';

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    void _register(String jsonString) async {
      // Construye la URL y realiza la solicitud POST
      //https://chesshub-api-ffvrx5sara-ew.a.run.app/play/
      Uri uri = Uri.parse(
          'https://chesshub-api-ffvrx5sara-ew.a.run.app/users/register');
      http.Response response = await http.post(
        uri,
        body:
            jsonString, // Utiliza el contenido del archivo JSON como el cuerpo de la solicitud
        headers: {
          HttpHeaders.contentTypeHeader:
              'application/json', // Especifica el tipo de contenido como JSON
        },
      );
      Map<String, dynamic> res =
          jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 500) {
        print(res['message']);
      } else if (response.statusCode == 200) {
        print(res['message']);

        GoRouter.of(context).go(
            '/login'); //Mandamos al login pero se podría dejar la sesión ya iniciada (liada)
      } else {
        throw Exception('Error en la solicitud POST: ${response.statusCode}');
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            color: Color.fromRGBO(49, 45, 45, 1),
            width: 350,
            height: 350,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text('Registrar Cuenta',
                        style:
                            TextStyle(color: Color.fromRGBO(255, 136, 0, 1)))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: TextField(
                    expands: false,
                    cursorColor: Color.fromRGBO(255, 136, 0, 1),
                    controller: _usernameController,
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      floatingLabelStyle:
                          TextStyle(color: Color.fromRGBO(255, 136, 0, 1)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(255, 136, 0,
                                1)), // Color de resaltado al hacer clic
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: TextField(
                    cursorColor: Color.fromRGBO(255, 136, 0, 1),
                    controller: _passwordController,
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      floatingLabelStyle:
                          TextStyle(color: Color.fromRGBO(255, 136, 0, 1)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(255, 136, 0,
                                1)), // Color de resaltado al hacer clic
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: TextField(
                    expands: false,
                    cursorColor: Color.fromRGBO(255, 136, 0, 1),
                    controller: _mailController,
                    onChanged: (value) {
                      setState(() {
                        _mail = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      floatingLabelStyle:
                          TextStyle(color: Color.fromRGBO(255, 136, 0, 1)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(255, 136, 0,
                                1)), // Color de resaltado al hacer clic
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      String username = _username;
                      String password = _password;
                      String mail = _mail;
                      Map<String, dynamic> register = {
                        'nombre': username,
                        'contraseña': password,
                        'correoElectronico': mail,
                        'victorias': 0,
                        'empates': 0,
                        'derrotas': 0
                      };
                      String jsonString = jsonEncode(register);

                      _register(jsonString);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(255, 136, 0, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: Text('Registrarse',
                        style: TextStyle(color: Color.fromRGBO(49, 45, 45, 1))),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
