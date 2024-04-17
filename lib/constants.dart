import 'package:flutter/material.dart';

class Constants{
  final primaryColor = const Color(0xff6b9dfc);
  final secondaryColor = const Color(0xff6b9dfc);
  final teritoryColor = const Color(0xff6b9dfc);
  final blackColor = const Color(0xff6b9dfc);
  final greyColor = const Color(0xffd9dadb);

  final Shader shader = const LinearGradient(colors: <Color>[Color(0xffABCFF2),Color(0xff9AC6F3)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final linearGradientBlue = const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      stops: [0.0,1.0],
      colors: [Color(0xff6b9dfc),Color(0xff205cf1)]);

  final linearGradientPurple = const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      stops: [0.0,1.0],
      colors: [Color(0xff51087e),Color(0xff6c0ba9)]);

}