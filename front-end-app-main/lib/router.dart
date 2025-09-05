// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

//import 'dart:js';

import 'package:ChessHub/local_game_sesion/tablero_widget.dart';
import 'package:ChessHub/ranking/elegir_tipo_ranking.dart';
import 'package:ChessHub/online_game_sesion/tablero_online_widget.dart';

import 'ranking/ranking_screen_blitz.dart';
import 'ranking/ranking_screen_bullet.dart';
import 'ranking/ranking_screen_rapid.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'level_selection/personalizacion.dart';
import 'game_internals/score.dart';
import 'level_selection/level_selection_screen.dart';
import 'level_selection/levels.dart';
import 'main_menu/main_menu_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';
import 'local_game_sesion/chess_play_session_screen.dart';
import 'log_in/log_in_screen.dart';
import 'battle_pass/battle_pass.dart';
//import 'battle_pass/pase_de_recompensas.dart';
import 'log_in/user_screen.dart';
import 'history/match_history_screen.dart';
import 'arenas/arenas_screen.dart';
import 'register/register_screen.dart';
import 'package:ChessHub/constantes/constantes.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainMenuScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: 'chess',
          pageBuilder: (context, state) {
            return buildMyTransition<void>(
              key: ValueKey('chess'),
              color: context.watch<Palette>().backgroundPlaySession,
              child: const ChessPlaySessionScreen(
                key: Key('chess play session'),
              ),
            );
          },
        ),
        /*
        GoRoute(
            path: 'play',
            pageBuilder: (context, state) => buildMyTransition<void>(
                  key: ValueKey('play'),
                  color: context.watch<Palette>().backgroundLevelSelection,
                  child: const LevelSelectionScreen(
                    key: Key('level selection'),
                  ),
                ),
            routes: [
              GoRoute(
                path: 'won',
                redirect: (context, state) {
                  if (state.extra == null) {
                    // Trying to navigate to a win screen without any data.
                    // Possibly by using the browser's back button.
                    return '/';
                  }

                  // Otherwise, do not redirect.
                  return null;
                },
                pageBuilder: (context, state) {
                  final map = state.extra! as Map<String, dynamic>;
                  final score = map['score'] as Score;

                  return buildMyTransition<void>(
                    key: ValueKey('won'),
                    color: context.watch<Palette>().backgroundPlaySession,
                    child: WinGameScreen(
                      score: score,
                      key: const Key('win game'),
                    ),
                  );
                },
              )
            ])
        */
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
        GoRoute(
          path: 'ranking',
          builder: (context, state) => ElegirTipoRanking(),
        ),
        GoRoute(
          path: 'login',
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => UserProfileScreen(),
        ),
        GoRoute(
          path: 'history',
          builder: (context, state) => MatchHistory(),
        ),
        GoRoute(
          path: 'arenas',
          builder: (context, state) => Arenas(),
        ),
        GoRoute(
          path: 'register',
          builder: (context, state) => RegisterScreen(),
        ),
        GoRoute(
          path: 'ranking/blitz',
          builder: (context, state) => RankingScreenBlitz(),
        ),
        GoRoute(
          path: 'ranking/bullet',
          builder: (context, state) => RankingScreenBullet(),
        ),
        GoRoute(
          path: 'ranking/rapid',
          builder: (context, state) => RankingScreenRapid(),
        ),
        GoRoute(
          path: 'chess/bullet',
          builder: (context, state) => TableroAjedrez(modoJuego: Modos.BULLET),
        ),
        GoRoute(
          path: 'chess/rapid',
          builder: (context, state) => TableroAjedrez(modoJuego: Modos.RAPID),
        ),
        GoRoute(
          path: 'chess/blitz',
          builder: (context, state) => TableroAjedrez(modoJuego: Modos.BLITZ),
        ),
      ],
    ),
  ],
);
