import 'dart:async';


import 'package:flutter/material.dart';

class TimeOutWidget extends StatefulWidget {
  const TimeOutWidget({
    super.key,
    required this.duration,
    this.onTimeOut,
  });

  final Duration duration;

  final VoidCallback? onTimeOut;

  @override
  State<TimeOutWidget> createState() => _TimeOutWidgetState();
}

class _TimeOutWidgetState extends State<TimeOutWidget> {
  late Timer _timer;

  String text = '';

  @override
  void initState() {
    super.initState();

    String padLeft(int value) => value.toString().padLeft(2, '0');

    //! Currently not using any state/backend
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (widget.duration.inSeconds < t.tick) {
        t.cancel();
      }

      Duration remaining = widget.duration - Duration(seconds: t.tick);
      text = '${padLeft(remaining.inMinutes)}:${padLeft(remaining.inSeconds.remainder(60))}';
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _timer.isActive
        ? Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          )
        : TextButton(
            onPressed: widget.onTimeOut,
            child: Text(
              'Resend',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
  }
}
