import 'package:flutter/material.dart';

class Constants{
  final primaryColor = const Color(0xff6b9dfc);
  final secondaryColor = const Color(0xff6b9dfc);
  final territoryColor = const Color(0xff6b9dfc);
  final blackColor = const Color(0xff6b9dfc);
  final greyColor = const Color(0xffd9dadb);

  final primaryColorDark = const Color(0xff5476b3); // Dark mode alternative for primaryColor
  final secondaryColorDark = const Color(0xff5476b3); // Dark mode alternative for secondaryColor
  final territoryColorDark = const Color(0xff5476b3); // Dark mode alternative for territoryColor
  final blackColorDark = const Color(0xff5476b3); // Dark mode alternative for blackColor
  final greyColorDark = const Color(0xffb0b0b0); // Dark mode alternative for greyColor


  final Shader shader = const LinearGradient(colors: <Color>[Color(0xffABCFF2),Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

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

  final Shader shaderDark = const LinearGradient(
    colors: <Color>[Color(0xff6e95e1), Color(0xff5c89d6)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final LinearGradient linearGradientBlueDark = const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    stops: [0.0, 1.0],
    colors: [Color(0xff5476b3), Color(0xff1747a3)],
  );

  final LinearGradient linearGradientPurpleDark = const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    stops: [0.0, 1.0],
    colors: [Color(0xff3c0f5d), Color(0xff511a76)],
  );

}

