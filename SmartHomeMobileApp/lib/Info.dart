import 'package:shared_preferences/shared_preferences.dart';

// user.dart
class User {
  int userId;
  String email;
  String name;
  String surname;
  String password;
  String phone;
  int numberOfRooms;
  int active;

  User(
     this.userId,
      this.email,
      this.name,
      this.surname,
     this.password,
     this.phone,
      this.numberOfRooms,
      this.active,
  );
  Future<void> saveUserDataLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId as String);
    prefs.setString('email', email);
  }


}
// room.dart
class Room {
  int roomId;
  String roomType;
  int userId;
  double optimumTemperature;
  double optimumHumidity;
  double optimumGase;

  Room({
    required this.roomId,
    required this.roomType,
    required this.userId,
    required this.optimumTemperature,
    required this.optimumHumidity,
    required this.optimumGase,

  });
}

// pot.dart
class Pot {
  int potId;
  String potName;
  int roomId;

  Pot({
    required this.potId,
    required this.potName,
    required this.roomId,
  });
}

// sensor_reading.dart
class SensorReading {
  int roomId;
  double temperature;
  double humidity;
  int fire;
  int move;
  double gas;

  SensorReading(this.roomId, this.temperature, this.humidity,
  this.gas,this.fire, this.move);
}
class Temp_Hum
{
  String time;
  double temprature;
  double humidty;

  Temp_Hum(this.time, this.temprature, this.humidty);
}
class Gas
{
  String time;
  double gas;

  Gas(this.time, this.gas);


}
class Fire
{
  String time;
  int fire;

  Fire(this.time, this.fire);
}
class Move
{
  String time;
  int move;

  Move(this.time, this.move);
}


