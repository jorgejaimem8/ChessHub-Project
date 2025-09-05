// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../player_progress/player_progress.dart';
import '../style/my_button.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 60);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Stack(children: [
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
          title: Text('Settings',
              style: TextStyle(color: Colors.white, fontFamily: 'Oswald')),
        ),
        body: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Color.fromRGBO(
              49, 45, 45, 1), // Cambia el color de fondo de la tarjeta
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ResponsiveScreen(
              squarishMainArea: ListView(
                children: [
                  _gap,
                  const _NameChangeLine(
                    'Setting',
                  ),
                  _gap,
                  Text(settings.playerName.value,
                      style:
                          TextStyle(color: Colors.red, fontFamily: 'Oswald')),
                  _gap,
                  Text(settings.playerName.value,
                      style:
                          TextStyle(color: Colors.green, fontFamily: 'Oswald')),
                  _gap,
                  Text(settings.playerName.value,
                      style:
                          TextStyle(color: Colors.blue, fontFamily: 'Oswald')),
                  _gap,
                  IconButton(
                    tooltip: 'Recargar',
                    onPressed: () {
                      Navigator.of(context).pop();
                      GoRouter.of(context).push('/settings');
                    },
                    icon: Icon(Icons.replay),
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ],
              ),
              rectangularMenuArea: Spacer(),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                )),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '‘$name’',
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
