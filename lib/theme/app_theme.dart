import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/pallete.dart';

// 이 문장이 58000% 이해된다. 항상 클래스를 이용해서 객체생성을 한걸 static 변수에 담아 놓은 예이다. 너무 아름답네.. 거기에 ThemeData.dart().copyWith() 함수로 값을 변경하였다.
class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blueColor,
    ),
  );
}

