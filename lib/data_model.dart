
class Weather{
  final String cityName;
  final double temperature;
  final String mainCondition;

  Weather({required this.temperature,
    required this.cityName,
    required this.mainCondition});

  factory Weather.fromJson(Map<String,dynamic>json){
    return Weather(
        temperature: json['main']['temp'].toDouble(),
        cityName: json['name'],
        mainCondition: json['weather'][0]['main']);
  }
}