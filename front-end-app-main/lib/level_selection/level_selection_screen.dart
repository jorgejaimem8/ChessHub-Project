// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Ahora esta pantalla es la resultante de darle a play, al darle dara dos
// opciones que sera personalizacion y buscar partida
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
//import '../player_progress/player_progress.dart';
import '../style/my_button.dart';
//import '../style/palette.dart';
import '../style/responsive_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final palette = context.watch<Palette>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/board.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(49, 45, 45, 1),
            title: GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/');
              },
              child: Text(
                'ChessHub',
                style: TextStyle(
                    fontFamily: 'Oswald',
                    color: Color.fromRGBO(255, 255, 255, 1)),
              ),
            ),
          ),
          body: ResponsiveScreen(
              squarishMainArea: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    onPressed: () {
                      final audioController = context.read<AudioController>();
                      audioController.playSfx(SfxType.buttonTap);

                      GoRouter.of(context)
                          .go('/chess'); // Cambia esto a la ruta correcta
                    },
                    child: const Text('Buscar Partida'),
                  ),
                  const SizedBox(height: 50),
                  MyButton(
                    onPressed: () {
                      final audioController = context.read<AudioController>();
                      audioController.playSfx(SfxType.buttonTap);

                      GoRouter.of(context).go('/personalizacion');
                    },
                    child: const Text('Personalización'),
                  ),
                ],
              ),
              rectangularMenuArea: Spacer()),
        ),
      ]),
    );
  }
}
