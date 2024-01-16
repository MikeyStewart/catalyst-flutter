import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:text_scroll/text_scroll.dart';

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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.orange, Colors.deepOrange]),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'The effigy burns in: ',
              style: TextStyle(color: Colors.white),
            ),
          ),
          AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              RotateAnimatedText(
                countdownDuration.inDays.toString() + ' days, ',
                textStyle: TextStyle(color: Colors.white),
              ),
              RotateAnimatedText(
                countdownDuration.inHours.remainder(24).toString() + ' hours, ',
                textStyle: TextStyle(color: Colors.white),
              ),
              RotateAnimatedText(
                countdownDuration.inMinutes.remainder(60).toString() +
                    ' minutes, ',
                textStyle: TextStyle(color: Colors.white),
              ),
              RotateAnimatedText(
                countdownDuration.inSeconds.remainder(60).toString() +
                    ' seconds.',
                textStyle: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );

    // @override
    // Widget build(BuildContext context) {
    //   return Container(
    //     decoration: const BoxDecoration(
    //       gradient: LinearGradient(
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //           colors: <Color>[Colors.orange, Colors.deepOrange]),
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //       child: Align(
    //         alignment: Alignment.centerLeft,
    //         child: Text(
    //           'The effigy burns in: ',
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         child: Text(
    //           'The effigy burns in: ' +
    //               '\n'+
    //               countdownDuration.inDays.toString() +
    //               ' days, ' +
    //               countdownDuration.inHours.remainder(24).toString() +
    //               ' hours, ' +
    //               countdownDuration.inMinutes.remainder(60).toString() +
    //               ' minutes, ' +
    //               countdownDuration.inSeconds.remainder(60).toString() +
    //               ' seconds.',
    //           style: TextStyle(color: Colors.white),
    //         ),
    //       ),
    //     ),
    //   );
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
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.white)),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
