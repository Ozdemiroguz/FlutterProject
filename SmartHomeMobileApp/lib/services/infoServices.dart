
import 'package:untitled5/Info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<User>getUser(int userId)async{

  //Get data from database
//with email
  var tempUser=User(1,"email", "name", "surname","password",  "phoneNumber", 1, 1);


  return tempUser;
}

Future<List<Room>>getRooms(userId)async{
  //Get data from database

  try {
    final response = await http.get(
      Uri.parse("https://nodejs-mysql-api-sand.vercel.app/api/v1/room/${"33"}/rooms"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Room> roomList = [];

      for (var roomData in data['data']) {
        try {
          Room room = Room(
            roomId: roomData["RoomID"],
            roomType: roomData['RoomType'],
            userId: userId,
            optimumTemperature: roomData["OptimumTemperature"].toDouble(),
            optimumHumidity: roomData["OptimumHumidity"].toDouble(),
            optimumGase: roomData["OptimumGase"].toDouble(),

          );
          roomList.add(room);
        } catch (e) {
          print("Hata oluştu: $e");
          print("Hata oluşan veri: $roomData");
          rethrow; // Hatanın tekrar fırlatılması
        }
      }

      return roomList;
    } else {
      throw Exception('Veri çekme hatası. StatusCode: ${response.statusCode}');
    }
  } catch (error) {
  print('İstek hatası: $error');
  throw Exception('İstek hatası: $error');
  }
}
class AuthService
{

}

Future<bool> registerUser(User user) async {
  try {
    final response = await http.post(
      Uri.parse('https://nodejs-mysql-api-sand.vercel.app/api/v1/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': user.email,
        'password': user.password,
        'name': user.name,
        'surname': user.surname,
        'phone': user.phone,
        'numberOfRooms': user.numberOfRooms,
        'active': user.active,
      }),
    );

    if (response.statusCode == 200) {
      // Decode the JSON response
      final Map<String, dynamic> result = jsonDecode(response.body);

      // Check if the registration was successful
      if (result['message'] == 'Registration successful') {
        // Registration successful
        print('Registration successful');
        return true;
      } else {
        // Registration failed
        print('Registration failed: ${result['message']}');
        return false;
      }
    } else {
      // Registration request failed
      print('Registration request failed with status code ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Error occurred
    print('Error occurred: $e');
    return false;
  }
}

Future<bool> loginUser(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('https://nodejs-mysql-api-sand.vercel.app/api/v1/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('accessToken')) {
        print('Access Token: ${data['accessToken']}');
        // Kullanıcı ID'sini almak için:
        int userId = data['data']['userId'];
        print('User ID: $userId');
        _storeCredentials(email, password,userId);

        return true;

        // Flutter'da sayfa yönlendirme işlemi
        // Örneğin: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => YourMainPage()));
      } else {
        print('Giriş başarısız: ${data['error']}');
        return false;
      }
    }

    return false; // Try bloğundan çıkış yaparsa

  } catch (error) {
    print('İstek hatası: $error');
    return false;
  }
}
Future<void> _storeCredentials(String email, String password,int userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  User user=await getUser(userId);
  prefs.setString('email', email);
  prefs.setString('password', password);
  prefs.setInt('userId', userId);
  print("${user.name}setusername");
  prefs.setString("userName", user.name);
  prefs.setString("userSurName", user.surname);
  prefs.setString("userPhone", user.phone);



}
Future<Map<String, dynamic>> _getStoredCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Kullanıcı kimlik bilgilerini ayrı ayrı key'lerden alın
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');
  int? userId = prefs.getInt('userId');

  // Map olarak döndürün
  Map<String, dynamic> userCredentials = {
    'email': email,
    'password': password,
    'userId': userId,
  };

  return userCredentials;
}
Future<User?> getUserById(int id) async {
  try {
    final response = await http.get(
      Uri.parse('https://nodejs-mysql-api-sand.vercel.app/api/v1/user/$id'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['data'] != null && data['data'].isNotEmpty) {
        var userData = data['data'][0];

        return User(
           userData['UserID'],
          userData['Mail'],
       userData['Name'],
           userData['Surname'],
           '', // Burada şifreyi alıp almamak size bağlı, güvenlik nedeniyle şifre alınmamıştır.
           userData['Phone'],
           userData['NumberOfRooms'],
           userData['Active'],
        );
      } else {
        print('API yanıtında beklenen veri yapılandırması eksik veya boş: $data');
        return null;
      }
    } else {
      print('API isteği başarısız. StatusCode: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('İstek hatası: $error');
    return null;
  }
}
Future<SensorReading?> fetchData(roomID) async {
  const String apiKey = 'YOUR_API_KEY';
  const String apiUrl = 'https://nodejs-mysql-api-sand.vercel.app/api/v1/getSensor/getAllLatestSensorReadings';

  // Headers objesi oluşturuluyor
  Map<String, String> headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  // GET isteği yapılıyor
  try {
    final response = await http.get(Uri.parse('$apiUrl?roomID=$roomID'), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      // JSON verisinin parça parça yazdırılması
      print('Data1: $data');
      print('Data1: ${data["data"][0]["LastTemperature"]}');


      SensorReading sensorReading = SensorReading(
        roomID,
        data["data"][0]["LastTemperature"].toDouble(),
        data["data"][0]["LastHumidity"].toDouble(),
        data["data"][0]["LastGas"].toDouble(),
        data["data"][0]["LastFire"],
        data["data"][0]["LastMove"],
      );

      return sensorReading;
    } else {
      print('HTTP error! Status: ${response.statusCode}');
      print('Error body: ${response.body}');
      throw Exception('HTTP error! Status: ${response.statusCode}');
    }
  } catch (error) {
    print('Fetch error: $error');
    throw Exception('Fetch error: $error');
  }
}