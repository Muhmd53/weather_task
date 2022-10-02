import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService
{
  Future<String> getWeather(String city) async
  {
    final queryParameters = {
      'q': city,
      'appid': '98e8dfcf4ea2319b693eb4c58b2a6018',
      'units': 'metric'
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    if(json['cod'] != 200)
      {
        return "-1";
      }
    else
      {
        return jsonEncode(json).toString();
      }

  }
  Future<String> getForecast(String lat, String lon) async
  {
    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'appid': '98e8dfcf4ea2319b693eb4c58b2a6018',
      'units': 'metric',
      'exclude': 'current,minutely,hourly,alerts'
    };

    final uri = Uri.https(
        'api.openweathermap.org', '/data/2.5/onecall', queryParameters);

    final response = await http.get(uri);
    final json = jsonDecode(response.body);

    return jsonEncode(json).toString();

  }
}