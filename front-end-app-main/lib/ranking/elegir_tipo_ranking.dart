import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../log_in/log_in_screen.dart';
import 'package:provider/provider.dart';
import '../settings/settings.dart';

class ElegirTipoRanking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();

    bool logueado = settingsController.loggedIn.value;

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
                  title: Text('Elegir Tipo de Ranking',
                      style:
                          TextStyle(color: Colors.white, fontFamily: 'Oswald')),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (logueado) {
                            context.go('/ranking/blitz');
                          } else {
                            context.go('/login');
                          }
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 21)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(255, 136, 0, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: Text('BLITZ',
                            style: TextStyle(
                                color: Color.fromRGBO(49, 45, 45, 1),
                                fontFamily: 'Oswald')),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (logueado) {
                            context.go('/ranking/rapid');
                          } else {
                            context.go('/login');
                          }
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 21)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(255, 136, 0, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: Text('RAPID',
                            style: TextStyle(
                                color: Color.fromRGBO(49, 45, 45, 1),
                                fontFamily: 'Oswald')),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (logueado) {
                            context.go('/ranking/bullet');
                          } else {
                            context.go('/login');
                          }
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 21)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(255, 136, 0, 1)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: Text('BULLET',
                            style: TextStyle(
                                color: Color.fromRGBO(49, 45, 45, 1),
                                fontFamily: 'Oswald')),
                      ),
                    ],
                  ),
                ),
              )
            ]));
  }
}
