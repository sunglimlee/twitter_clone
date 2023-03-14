import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

String getNameFromEmail(String email) {
  return email.split('@')[0]; // 정말 천재들이다. @ 를 지준으로 List 를 만들고 [0] 번째를 리턴해라는 것
}

Future<List<File>> pickImages() async {
  List<File> images = []; // 언제나 그렇듯 로컬변수 선언하고 초기화하고
  final ImagePicker picker = ImagePicker(); // image picker 객체 만들고
  final imageFiles = await picker.pickMultiImage(); // 화면에 보여주고
  if (imageFiles.isNotEmpty) { // 선택한게 있으면
    for (final image in imageFiles) {
      images.add(File(image.path)); // xfile 인데 어떻게 file 로 변환이 되는거지?
    }
  }
  return images;
}