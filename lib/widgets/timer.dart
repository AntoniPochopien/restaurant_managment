import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TimerWidget extends StatefulWidget {
  int timeStampMiliseconds;

  TimerWidget({required this.timeStampMiliseconds});

  @override
  State<TimerWidget> createState() =>
      _TimerWidgetState(timeStampMiliseconds: timeStampMiliseconds);
}

class _TimerWidgetState extends State<TimerWidget> {
  int timeStampMiliseconds;

  _TimerWidgetState({required this.timeStampMiliseconds});

  var now = DateTime.now().millisecondsSinceEpoch;
  Duration duration = Duration();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: (timeStampMiliseconds / 1000).round());
    startTimer();
  }

  void addTime() {
    final addSecond = 1;
    setState(() {
      final seconds = duration.inSeconds + addSecond;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text('$minutes:$seconds',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: int.parse(minutes) > 15 ? Colors.red : Colors.black));
  }
}
