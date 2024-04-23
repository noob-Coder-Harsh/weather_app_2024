import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherLoadingAnimation extends StatelessWidget {
  const WeatherLoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Lottie.asset(
        'assets/weather_loading_animation.json',
        height: 100, // Adjust the height as needed
        width: 100, // Adjust the width as needed
      ),
    );
  }
}
