import 'package:flutter/material.dart';
import 'dart:async';

class CountDown extends StatefulWidget {
  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  DateTime targetDate = DateTime(2024, 1, 28, 20, 59, 59);
  late Duration countdownDuration;
  late Timer countdownTimer;

  @override
  void initState() {
    super.initState();

    countdownDuration = targetDate.difference(DateTime.now());

    countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        countdownDuration = targetDate.difference(DateTime.now());

        // Check if the countdown is complete
        if (countdownDuration.isNegative) {
          timer.cancel();
          // Handle countdown completion here
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'The Effigy burns in...',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CountDownItem(
                value: countdownDuration.inDays.toString(),
                label: 'Days',
              ),
              CountDownItem(
                value: countdownDuration.inHours.remainder(24).toString(),
                label: 'Hours',
              ),
              CountDownItem(
                value: countdownDuration.inMinutes.remainder(60).toString(),
                label: 'Minutes',
              ),
              CountDownItem(
                value: countdownDuration.inSeconds.remainder(60).toString(),
                label: 'Seconds',
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }
}

class CountDownItem extends StatelessWidget {
  final String value;
  final String label;

  CountDownItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white)),
          Text(label,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}
