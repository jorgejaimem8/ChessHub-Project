import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ChessHub/main.dart';
class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(49, 45, 45, 1),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(),
            ),
          );
        },
        child: Text(
          'ChessHub',
          style: TextStyle(
            fontFamily: 'Oswald',
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

