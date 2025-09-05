import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PiezaMuerta extends StatelessWidget {
  final String pathImagen;
  final bool esBlanca;


  const PiezaMuerta({
    Key? key,
    required this.pathImagen,
    required this.esBlanca,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
                this.pathImagen,
                width: 10, // Ajusta el tamaño según sea necesario
                height: 10,
                color : esBlanca ? Colors.grey : Colors.grey[800],
              );
  }
}