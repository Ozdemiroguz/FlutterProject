import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/color.dart';
import '../models/weatherModel.dart';
import 'package:untitled5/services/weatherService.dart';
import 'package:untitled5/services/infoServices.dart';
import '../Info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled5/services/getandset.dart';

import 'Widgets/homeWidgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer timer;
  int? currentRoomId=7;

  void initState() {
    super.initState();
    _fetchWeather();
    _fetchUserData();
    _fetchRooms();
    _fetchSensorDatas();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchData(currentRoomId));

    // initState içinde hava durumu getirme işlemini çağırın
  }
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
  _fetchRooms() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId')?? 1;
    print("${userId}get rooms");
    List<Room>? roomlist= await getRooms(userId);
    if (roomlist != null) {
      setState(() {
        _roomlist = roomlist;
        print(_roomlist?[1].roomId);
      });
    } else {
      // Hata durumunu ele alabilirsiniz
      print('Kullanıcı bilgileri alınamadı.');
    }
}
  _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId')?? 1;
    _userId=userId;
// Eğer kullanıcı kimliği yoksa varsayılan olarak 1 kullanılacak
    User? user = await getUserById(userId);
    if (user != null) {
      setState(() {
        _user = user;
        print(_user);
      });
    } else {
      // Hata durumunu ele alabilirsiniz
      print('Kullanıcı bilgileri alınamadı.');
    }
  }
  _fetchWeather() async {
    // get weather for city
    String cityName ="Eskisehir";
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }
  _fetchSensorDatas()async{
      print("Timer triggerd $currentRoomId");

  }
  final _weatherService = WeatherService('bf9ba31da6a2f4eb21dc70cb79c87151');
  Weather? _weather;
  User? _user;
  int? _userId;
  List<Room>? _roomlist;
  SensorReading? _sensorReading;


  // fetch weather




  @override


  Widget build(BuildContext context) {
    Color darkBack = ColorConverter.hexToColor("49108B");
    Color softBack = ColorConverter.hexToColor("7E30E1");

    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    // Şu anki tarih ve saat bilgisini al
    DateTime now = DateTime.now();
    // Yıl, ay ve günü içeren bir metin oluştur
    String formattedDate = "${now.year}-${now.month.toString().padLeft(
        2, '0')}-${now.day.toString().padLeft(2, '0')}";



    // Eğer kullanıcı bilgileri henüz alınmadıysa bir bekleme ekranı gösterilebilir

    if (_user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else{
      return Scaffold(
        backgroundColor: darkBack,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0), // Sıfır yükseklikte AppBar
          child: AppBar(
            automaticallyImplyLeading: false, // Geri gitme tuşunu kaldırmak için
          ),
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(width: screenWidth / 1.05,
                  child: Card(
                    elevation: 15,
                    color: softBack,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome ${_user?.name}",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),),
                                SizedBox(height: 10,),
                                Text("Let's see your smarthome",
                                  style: TextStyle(color: Colors.white),),
                              ],
                            ),
                            Icon(
                              Icons.person_pin, size: 54, color: Colors.white,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: softBack,
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: screenWidth / 3,
                            child: Lottie.asset(getWeatherAnimation(_weather
                                ?.mainCondition ?? "Clouds"))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_weather?.mainCondition ?? "",
                              style: TextStyle(fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),),
                            Text(formattedDate, style: TextStyle(
                                color: Colors.white),),
                            Text(_weather?.cityName ?? "loading city",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.white),),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${_weather?.temprature.round().toString()}°C',
                              style: TextStyle(
                                  fontSize: 36, color: Colors.white),),
                            Text('${_weather?.humidity.round().toString()}%',
                              style: TextStyle(
                                  fontSize: 36, color: Colors.white),),
                            //Text('${_weather?.humidity.round().toString()}%' ),

                          ],
                        ),
                        SizedBox(width: 10,)
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child:
                      DefaultTabController(
                          length: _roomlist?.length ?? 0,
                          child:Column(
                            children: [
                              TabBar(
                                indicatorWeight: 4,
                                indicatorColor: Colors.white,
                                isScrollable: true,
                                tabs: _roomlist?.map((room) => Tab(
                                child: Text(room?.roomType ?? '', // room veya roomType null ise, boş bir string olarak kabul eder
                                style: TextStyle(color: Colors.white),
                                  ) ,
                                ))?.toList() ?? [],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: _roomlist?.map((room) {
                                    print("${room.roomId}");
                                      return  FutureBuilder<SensorReading?>(
                                      future: fetchData(room.roomId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else if (snapshot.data == null) {
                                          return Text('Data is null'); // veya uygun bir hata mesajı
                                        } else {
                                          SensorReading? sensor;
                                          sensor = snapshot.data!;
                                            print("room${room.roomId}");
                                            currentRoomId=room.roomId;
                                          return buildRadial(sensor);
                                        }
                                      },
                                    );
                                  })?.toList() ?? [],
                                ),
                              ),

                            ],
                          ),
                      )
                    )

                ,
              ],
            ),

          ),
        ),

      );
  }
  }
  }



Icon setIcon(String roomName)
{


  final Map<String, IconData> roomIcons = {
    'Mutfak': Icons.kitchen,
    'Banyo': Icons.bathtub,
    'Yatak Odası': Icons.bedroom_parent,
    'Oturma Odası': Icons.living,
  };

  return Icon(
    roomIcons[roomName] ?? Icons.home,
    color: Colors.white,
    size: 56,
  );
}
String getWeatherAnimation(String weatherCondition) {
  switch (weatherCondition) {
    case "Clouds":
      return "weatheranimations/Animation - 1702679736586.json"; // Bulutlu
    case "Drizzle":
      return "weatheranimations/Animation - 1702679500514.json"; // Çisenti
    case "Clear":
      return "weatheranimations/Animation - 1702679286357.json"; // Açık Hava
    case "Rain":
      return "weatheranimations/Animation - 1702679615743.json"; // Yağmurlu
    case "Thunderstorm":
      return "weatheranimations/Animation - 1702679414151.json"; // Gökgürültülü Fırtına
    case "Snow":
      return "weatheranimations/Animation - 1702730698823.json"; // Karlı
    default:
      return "weatheranimations/Animation - 1702679736586.json"; // Varsayılan bir animasyon dosyası ya da hata durumu
  }
}


