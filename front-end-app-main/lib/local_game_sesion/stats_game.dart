import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerRow extends StatefulWidget {
  final String playerName;
  Duration initialTime = Duration(minutes: 0, seconds: 0);
  final bool esBlanca;
  bool _timerPaused = true;

  int piecesCaptured = 0;

  PlayerRow({
    Key? key,
    required this.playerName,
    required this.esBlanca,
  }) : super(key: key);

  void changeTimer(Duration newTime) {
    this.initialTime = newTime;
    if (esBlanca) {
      this._timerPaused = false;
    }
  }
  
  void pauseTimer() {
    this._timerPaused = true;
  }

  void resumeTimer() {
    this._timerPaused = false;
  }

  void incrementPiecesCaptured() {
    this.piecesCaptured++;
  }

  bool tiempoAgotado() {
    return this.initialTime.inSeconds == 0;
  }
  @override
  _PlayerRowState createState() => _PlayerRowState();
}

class _PlayerRowState extends State<PlayerRow> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _decrementTimer);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _decrementTimer(Timer timer) {
    if (!widget._timerPaused) {
      setState(() {
        widget.initialTime -= Duration(seconds: 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[300],
        border: Border.all(color: Colors.white, width: 1),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.playerName,
              style: GoogleFonts.play(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Text(
            '${widget.initialTime.inMinutes} : ${widget.initialTime.inSeconds % 60}',
            style: GoogleFonts.play(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            'Fichas comidas: ${widget.piecesCaptured}',
            style: GoogleFonts.play(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
