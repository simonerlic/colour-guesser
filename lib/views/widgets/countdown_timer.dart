// countdown_timer.dart

import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final Duration initialDuration;

  const CountdownTimer({super.key, required this.initialDuration});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _duration = widget.initialDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration = Duration(seconds: _duration.inSeconds - 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Next daily challenge in: ${_duration.inHours.toString().padLeft(2, '0')}:'
      '${(_duration.inMinutes % 60).toString().padLeft(2, '0')}:'
      '${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: Theme.of(context).textTheme.labelSmall,
    );
  }
}
