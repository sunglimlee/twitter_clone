import 'dart:async';

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}

// 그냥 x초 기다리게 하는 함수
void timerDelay(int seconds, VoidCallback callback) {
  Timer(Duration(seconds: seconds), callback);
}

void timerRepeat(int seconds, Function(Timer) callback) {
  Timer.periodic(Duration(seconds: seconds), callback);
}

void timerImmediately(int seconds, VoidCallback callback) {
  Timer(const Duration(seconds: 0), callback);
}

