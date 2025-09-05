import 'dart:io';

import 'package:ChessHub/constantes/constantes.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

//import '../audio/audio_controller.dart';
import 'package:ChessHub/game_internals/funciones.dart';
//import '../audio/sounds.dart';
import '../settings/settings.dart';
//import '../style/my_button.dart';
//import '../style/palette.dart';
//import '../style/responsive_screen.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
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
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(49, 45, 45, 1),
            title: Text('Iniciar Sesión',
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

class LoginState extends ChangeNotifier {
  // Dart client

  int _id = 0;
  bool _logueado = false;
  String _imagen = '';
  int _eloBlitz = 0;
  int _eloRapid = 0;
  int _eloBullet = 0;
  String _arena = '';
  int _puntosPase = 0;
  String _nombre = '';

  int get id => _id;
  bool get logueado => _logueado;
  String get imagen => _imagen;
  int get eloBlitz => _eloBlitz;
  int get eloRapid => _eloRapid;
  int get eloBullet => _eloBullet;
  String get arena => _arena;
  int get puntosPase => _puntosPase;
  String get nombre => _nombre;

  String getNombre() {
    return _nombre;
  }

  void setId(int id) {
    _id = id;
    notifyListeners(); // Notifica a los oyentes que 'id' ha cambiado
  }

  void setLogueado(bool logueado) {
    _logueado = logueado;
    notifyListeners(); // Notifica a los oyentes que 'logueado' ha cambiado
  }

  String getImagenPieza() {
    getInfo(id.toString());
    return _imagen;
  }

  String getArena() {
    return _arena;
  }

  String getId() {
    return _id.toString();
  }

  int getIdInt() {
    return _id;
  }

  int getEloBlitzUsuario() {
    getInfo(id.toString());
    return _eloBlitz;
  }

  int getEloRapidUsuario() {
    getInfo(id.toString());
    return _eloRapid;
  }

  int getEloBulletUsuario() {
    getInfo(id.toString());
    return _eloBullet;
  }

  void getInfo(String id) async {
    // Construye la URL y realiza la solicitud POST
    //https://chesshub-api-ffvrx5sara-ew.a.run.app/play/
    print('OBTENIENDO INFORMACION DE USUARIO\n');
    Uri uri =
        Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/$id');
    http.Response response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader:
            'application/json', // Especifica el tipo de contenido como JSON
      },
    );
    print('OBTENEIENDO DATOS DE USUARIO');
    Map<String, dynamic> res =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      print(res);
      _eloBlitz = res['eloblitz'] as int;
      _eloRapid = res['elorapid'] as int;
      _eloBullet = res['elobullet'] as int;
      _imagen = res['setpiezas'] as String;
      _arena = res['arena'] as String;
      _puntosPase = res['puntospase'] as int;
      _nombre = res['nombre'] as String;
      notifyListeners();
    } else {
      throw Exception('Error en la solicitud GET: ${response.statusCode}');
    }
  }
}

class LoginFormWidget extends StatefulWidget {
  LoginFormWidget({super.key});
  @override
  LoginFormWidgetState createState() => LoginFormWidgetState();
}

class LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    int id = 0;
    bool logueado = false;
    LoginState loginState = context.watch<LoginState>();
    final settingsController = context.watch<SettingsController>();

    void _login(String jsonString) async {
      // Construye la URL y realiza la solicitud POST
      //https://chesshub-api-ffvrx5sara-ew.a.run.app/play/
      Uri uri =
          Uri.parse('https://chesshub-api-ffvrx5sara-ew.a.run.app/users/login');
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
      if (response.statusCode == 404) {
        print(res['message']);
      } else if (response.statusCode == 401) {
        print(res['message']);
      } else if (response.statusCode == 500) {
        print(res['message']);
      } else if (response.statusCode == 200) {
        print(res['message']);
        id = res['userId'] as int;
        loginState.setId(id);
        settingsController.setSessionId(id);
        logueado = true;
        loginState.setLogueado(logueado);
        settingsController.toggleLoggedIn();
        loginState.getInfo(id.toString());
        //await loginState.conectarseServidor();
        GoRouter.of(context).go('/');
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
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text('Iniciar Sesión',
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
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: ElevatedButton(
                    onPressed: () {
                      String username = _username;
                      String password = _password;
                      Map<String, dynamic> login = {
                        'nombre': username,
                        'contraseña': password
                      };
                      String jsonString = jsonEncode(login);
                      _login(jsonString);
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
                    child: Text('Acceder',
                        style: TextStyle(color: Color.fromRGBO(49, 45, 45, 1))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: GestureDetector(
                    onTap: () {
                      GoRouter.of(context).go('/register');
                    },
                    child: Text(
                      'Si no tienes cuenta puedes registrarte aquí',
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Color.fromRGBO(255, 136, 0, 1),
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromRGBO(255, 136, 0, 1)),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
