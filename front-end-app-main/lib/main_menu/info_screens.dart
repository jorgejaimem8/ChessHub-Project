import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoScreens extends StatelessWidget {
  final String title;
  final String text;
  final String subtitle;

  const InfoScreens({Key? key, required this.text, required this.title, required this.subtitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color color = Color(0xFF506C64);
    return Container(
      color: color,
      child: Column(
        children: [
          Container(
            child: Text(
              title,
              style: GoogleFonts.play(
                fontSize: 30,
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationThickness: 1, // Grosor del subrayado
                decorationColor: Colors.white, // Color del subrayado (blanco)
              ),
            ),
          ),
          SizedBox(height: 150),
          Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              top: 10.0,
              right: 20.0,
              bottom: 10.0,
            ),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                  color: Colors.black, // Puedes cambiar el color del borde según tu preferencia
                  width: 2.0, // Puedes ajustar el ancho del borde
                ),
              ),
              child: Column(
                children: [
                  Text(
                    subtitle,
                    style: GoogleFonts.play(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0), // Esto agrega 8.0 de margen en todas las direcciones
                    child: Text(
                    text,
                    style: GoogleFonts.play(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    ),
                  )
                ],
              ),
              ),
            )
          ],
      ),
    );
  }
}