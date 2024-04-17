// import 'package:flutter/material.dart';
// import 'package:weather_app/weather_service.dart';
//
//
// import 'data_model.dart';
//
// class HomePage extends StatefulWidget{
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final _weatherService = WeatherService(apiKey: '98c640865fb44010d80e65b610afd036');
//   Weather? _weather;
//
//   //fetch weather
//   _fetchWeather()async{
//     //get the current city
//     String cityName = await _weatherService.getCurrentCity();
//
//     //get weather for city
//     try{
//       final weather = await _weatherService.getWeather(cityName);
//       setState(() {
//         _weather = weather;
//       });
//     }catch(e){
//       print(e);
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _fetchWeather();
//
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_weather?.cityName??"Loading city..."),
//             Text("${_weather?.temperature.round()}.C"),
//           ],
//         ),
//       ),
//     );
//   }
// }