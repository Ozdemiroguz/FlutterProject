import 'dart:convert';

import 'package:untitled5/Info.dart';
import 'package:http/http.dart' as http;

Future<List<Gas>?> getGas(int roomId) async {
  try {
    final response = await http.get(
      Uri.parse('https://nodejs-mysql-api-sand.vercel.app/api/v1/getSensor/getSensorReadings10?sensorType=Gas&roomID=$roomId'),
      headers: {
        'Authorization': 'Bearer YOUR_API_KEY', // Add your API key here
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> data = body['data'];

      List<Gas>? gasList=[];
      for (var gas in data) {
        String time=gas["Time"];
        time=time.substring(11,19);
        print("$time");
        gasList?.add(Gas( time,gas["Gas"].toDouble()));
      }
      // = data.map((dynamic item) => Gas.fromJson(item)).toList();
      return gasList;

    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  } catch (error) {
    print('Error: $error');
    throw error;
  }
}
Future<List<Temp_Hum>?> getTempHum(int roomId) async {
  try {
    final response = await http.get(
      Uri.parse('https://nodejs-mysql-api-sand.vercel.app/api/v1/getSensor/getSensorReadings10?sensorType=Temp_Hum&roomID=$roomId'),
      headers: {
        'Authorization': 'Bearer YOUR_API_KEY', // Add your API key here
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> data = body['data'];

      List<Temp_Hum>? tempHumList=[];
      for (var tempHum in data) {
        String time=tempHum["Time"];
        time=time.substring(11,19);
        print("Tmp$time");

      tempHumList?.add(Temp_Hum( time,tempHum["Temperature"].toDouble(),tempHum["Humidity"].toDouble(),));
      }
      // = data.map((dynamic item) => Gas.fromJson(item)).toList();
      return tempHumList;

    } else {
      print('Error: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  } catch (error) {
    print('Error: $error');
    throw error;
  }
}