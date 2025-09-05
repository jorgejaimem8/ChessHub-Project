import 'package:flutter/material.dart';
import '../style/header.dart';

class Arenas extends StatefulWidget {
  @override
  _ArenasState createState() => _ArenasState();
}

class Arena {
  final int level;
  final int elo;
  final int elo2;

  Arena({
    required this.level,
    required this.elo,
    required this.elo2,
  });
}

final List<Arena> tiers = [
  Arena(level: 1, elo: 0, elo2: 1500),
  Arena(level: 2, elo: 1500, elo2: 1800),
  Arena(level: 3, elo: 1800, elo2: 2100),
  Arena(level: 4, elo: 2100, elo2: 2400),
  Arena(level: 5, elo: 2400, elo2: 9999),
];

class _ArenasState extends State<Arenas> {
  @override
  Widget build(BuildContext context) {
    // Ordenar los tiers por nivel
    tiers.sort((a, b) => a.level.compareTo(b.level));
    return Scaffold(
      appBar: Header(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/board2.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView.builder(
          itemCount: tiers.length,
          itemBuilder: (context, index) {
            final tier = tiers[index];

            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Color.fromRGBO(49, 45, 45, 1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Arena ${tier.level}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Elo requerido: ${tier.elo} - ${tier.elo2}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Image(
                        image: AssetImage(
                            'assets/images/images_pase/boards/arena_${tier.level}.png'),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
