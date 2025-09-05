import 'package:ChessHub/main_menu/main_menu_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ChessHub/main_menu/info_screens.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController _controller = PageController();

  bool onLastPage = false;
  int index_page = 0;

  //STRINGD NECESARIOS PARA LAS PANTALLAS DE INFORMACIÓN
  String COMO_JUGAR = '\n\nCÓMO JUGAR';
  String MODOS_DE_JUEGO = '\n\nMODOS DE JUEGO';
  String ELO = 'Puntos de Elo';
  String PARTIDA = 'Partidas';
  String RECOMPENSAS = 'Puntos de Recompensas';
  String BULLET = 'Bullet';
  String BLITZ = 'Blitz';
  String RAPID = 'Rapid';

  String BulletText =
      'Esta variante del juego se caracteriza por partidas extremadamente rápidas,en las que cada jugador cuenta con 3 minuto de tiempo para realizar sus movimientos.';
  String BlitzText =
      'En el ajedrez Blitz, cada jugador tiene un tiempo máximo de 5 minutos. Esto hace que cada movimiento deba ser rápido y preciso, ya que no hay mucho margen para pensar demasiado.';
  String RapidText =
      "En este modo de juego los jugadores cuentan con 10 minutos. A diferencia de las partidas clásicas, donde se cuenta con varias horas para pensar y planificar cada jugada, en el ajedrez rápido el reloj es un factor determinante.";

  /* Información acerca del juego */
  String Partidas =
      " Juega partidas en modo local contra la máquina o en modo online contra otros usuarios. Existen tres modos de juego, Blitz, Bullet y Rapid. Estos se diferencian en el límite de tiempo para jugar. Al jugar partidas se te otrorgarán tanto puntos de recompensa como puntos de ELO.";
  String ELO_text =
      " Los puntos de ELO se utilizan para categorizar a los jugadores. ¡Gana partidas para conseguir gran cantidad de puntos de ELO y jugar contra los mejores jugadores! Al incrementar tu puntuación de ELO, jugarás en distintos ambientes de tableros llamados Arenas. En el apartado de \"Ranking\" puedes consultar los mejores jugadores en cada modo de juego.";
  String Recompensas =
      " Los puntos de recompensa se ganan independientemente de si ganas o pierdes partidas. Con estos puntos puedes acceder al apartado de \"Pase de batalla\" para reclamar recompensas asombrosas. Para poder utilizar las recompensas desbloqueadas en partida, accede al apartado de \"Personalización\".";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
            controller: _controller,
            onPageChanged: (index) {
              onLastPage = (index == 5);
              setState(() {
                index_page = index;
              });
            },
            children: [
              InfoScreens(text: ELO_text, title: COMO_JUGAR, subtitle: ELO),
              InfoScreens(text: Partidas, title: COMO_JUGAR, subtitle: PARTIDA),
              InfoScreens(
                  text: Recompensas, title: COMO_JUGAR, subtitle: RECOMPENSAS),
              InfoScreens(
                  text: BulletText, title: MODOS_DE_JUEGO, subtitle: BULLET),
              InfoScreens(
                  text: BlitzText, title: MODOS_DE_JUEGO, subtitle: BLITZ),
              InfoScreens(
                  text: RapidText, title: MODOS_DE_JUEGO, subtitle: RAPID),
            ]),
        Container(
            alignment: Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(index_page - 1);
                  },
                  child: Text(
                    'Atrás',
                    style: GoogleFonts.play(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),

                SmoothPageIndicator(
                  controller: _controller,
                  count: 6,
                  effect: SlideEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Color.fromRGBO(255, 136, 0, 1)),
                ),

                //next
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MainMenuScreen();
                          }));
                        },
                        child: Text(
                          'Completado',
                          style: GoogleFonts.play(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          'Siguiente',
                          style: GoogleFonts.play(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      )
              ],
            )),
      ],
    ));
  }
}
