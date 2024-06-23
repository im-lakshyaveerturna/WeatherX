import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherData {
  Map<String, dynamic> weatherInfo = {};
  String backgroundImage = '';
  bool error = false;

  Future<void> getValue(value) async {
    try {
      http.Response weather_response = await http.get(Uri.parse(
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$value?unitGroup=us&key=3X64FMMPJAPJ7N97XUFTKZVUY&contentType=json'));

      weatherInfo = jsonDecode(weather_response.body);
      print(weatherInfo);
      print(weatherInfo['days'][0]['cloudcover']);

      if (weatherInfo['days'][0]['cloudcover'] >= 80) {
        backgroundImage = 'cloudy_weather.jpeg';
      }
      if (weatherInfo['days'][0]['cloudcover'] > 50 &&
          weatherInfo['days'][0]['cloudcover'] < 80) {
        backgroundImage = 'partly_cloudy_weather.jpeg';
      }
      if (weatherInfo['days'][0]['cloudcover'] <= 50) {
        backgroundImage = 'sunny_weather.jpeg';
      }

    } catch (e) {
      print('Error fetching weather data: $e');
      error = true;
    }
  }
}
