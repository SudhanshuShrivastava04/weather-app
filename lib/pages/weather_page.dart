import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('def0b77348e777d6f182f605990a38c6');
  Weather? _weather;

  //fetch the weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();

    // weather for the current city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstrom':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_weather?.cityName ?? "Loading city...",
              style: const TextStyle(color: Colors.white, fontSize: 32)),
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
          Text('${_weather?.temperature.round()}°C',
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          Text(_weather?.mainCondition ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w300)),
        ]),
      ),
    );
  }
}
