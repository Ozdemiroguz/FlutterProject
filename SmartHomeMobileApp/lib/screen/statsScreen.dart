import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:untitled5/Info.dart';
import 'package:untitled5/models/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled5/services/infoServices.dart';
import 'package:untitled5/services/getSensorValues.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StatsScreen(),
      debugShowCheckedModeBanner: false,
      color: softBack,
    );
  }
}

const Duration roomsInterval = Duration(seconds: 5);
const Duration tempHumInterval = Duration(seconds: 5);
const Duration gasInterval = Duration(seconds: 10);
const Duration moveInterval = Duration(seconds: 20);
const Duration fireInterval = Duration(seconds: 5);

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Room? _selectedRoom;
  List<Room>? _roomlist;
  List<Temp_Hum>? _temp_hum;
  List<Gas>? _gasList;
  List<Fire>? fire;
  List<Move>? move;

  List<Timer> timers = [];
  Timer? timer;


  @override
  void initState() {
    super.initState();
    _fetchRooms();

    // Timer'ları oluştur ve listeye ekle

    _fetchGas();
    timers.add(Timer.periodic(gasInterval, (Timer timer) {
      _fetchGas();
    }));
    _fetchGas();
    timers.add(Timer.periodic(tempHumInterval, (Timer timer) {
      _fetcTempHum();
    }));
   // timers.add(Timer.periodic(fireInterval, (Timer timer) {
    // _fetchFire();
    //}));

  }

  void dispose() {
    // Widget kapatıldığında timer'ları iptal et
    for (var timer in timers) {
      timer.cancel();
    }
    super.dispose();
  }

  _fetchRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId') ?? 1;
    List<Room>? roomlist = await getRooms(userId);
    if (roomlist != null) {
      setState(() {
        _selectedRoom = roomlist[0];
        _roomlist = roomlist;
      });
    } else {
      // Hata durumunu ele alabilirsiniz
      print('Kullanıcı bilgileri alınamadı.');
    }
  }

  Future<Map<String, dynamic>> fetchData(String statisticType) async {
    // Bu metodun içeriği InfoServices.dart içerisindeki getStatistics metoduna göre güncellenmelidir.
    // Bu metod veriyi sunucudan alacak şekilde ayarlanmalıdır.
    // Şu anda sadece örnek bir Map dönüyor.
    return {
      'temperature': 25.0,
      'humidity': 50,
      'gasLevel': 0.2,
      'movement': true,
    };
  }
  _fetchGas()async{
    List<Gas>? gasList= await getGas(_selectedRoom!.roomId);
    if (gasList != null) {
      setState(() {
        _gasList = gasList.reversed.toList();
        print("Gas List${_gasList?[1].gas}}");

      });
    } else {
      // Hata durumunu ele alabilirsiniz
      print('Kullanıcı bilgileri alınamadı.');
    }
    print('Fetching gas data...');


  }

  _fetcTempHum()async{
    List<Temp_Hum>? tempHumList= await getTempHum(_selectedRoom!.roomId);
    if (tempHumList != null) {
      setState(() {
        _temp_hum = tempHumList.reversed.toList();
        print("Temp Hum List$_temp_hum");

      });
    } else {
      // Hata durumunu ele alabilirsiniz
      print('Kullanıcı bilgileri alınamadı.');
    }
    print('Fetching temp hum data...');


  }
  _fetchFire() async{
    // _fetchFire işlemleri buraya eklenir
    print('Fetching fire data...');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: softBack,
        title: DropdownButton<Room>(
          value: _selectedRoom,
          underline: Container(),
          icon: Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          dropdownColor: softBack,
          onChanged: (Room? newValue) {
            setState(() {
              _selectedRoom = newValue;
              print("${_selectedRoom?.roomId}");
            });
          },
          items: _roomlist?.map<DropdownMenuItem<Room>>((Room room) {
            return DropdownMenuItem<Room>(
              value: room,
              child: Text(
                room.roomType,
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            );
          }).toList() ??
              [],
        ),
        centerTitle: true,
      ),
      body: _selectedRoom == null
          ? Center(child: Text('Select a room'))
          : Container(
        color: darkBack,
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      "Temprature",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Humidity",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Gas Level",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Movement",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Fire",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                labelColor: Colors.white,
                indicatorColor: Colors.white,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _temp_hum !=null ?
                    _builTemp(_temp_hum,screenWidth,"Gas")
                        :Text("No room data available"),
                    _temp_hum !=null ?
                    _buildHum(_temp_hum,screenWidth,"Humidity")
                        :Text("No room data available"),
                    _gasList !=null ?
                     _buildGas(_gasList,screenWidth,"Gas")
                  :Text("No room data available"), // _roomList boş ise bu metni göster:
                    _buildTab('movement'),
                    _buildTab('fire'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String statisticType) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Room: ${_selectedRoom!.roomType}'),
          Text('Room: ${_selectedRoom!.roomId}'),
          SizedBox(height: 16),
          if ("_statsData" != null) ...[
          ] else ...[
            Text('Fetching $statisticType data...'),
          ],
        ],
      ),
    );
  }
}
Widget _buildGas(List<Gas>? _gasList,double screenWidth,String type) {

  return Column(
    children: [
      Text("${_gasList?[9].gas}"),
      SizedBox(width: screenWidth/1.1,height: 200,
        child: SfCartesianChart(

            primaryXAxis: CategoryAxis(
              labelRotation: 90,
              title: AxisTitle(
                text: 'Tarih',
              ),
            ),
            series: <CartesianSeries>[
              // Renders line chart,
              LineSeries<Gas, String>(
                  dataSource: _gasList  ,
                  xValueMapper: (Gas data, _) => data.time,
                  yValueMapper: (Gas data, _) => data.gas
              )
            ]
        ),
      ),
      buildStable("Gas", _gasList![9].gas),
    ],
  );
}
Widget _builTemp(List<Temp_Hum>? _tempHumList,double screenWidth,String type) {

  return Column(
    children: [
      SizedBox(height: 20,),
      SizedBox(height: 100,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 51,
              axisLineStyle: AxisLineStyle(thickness: 5),
              axisLabelStyle: GaugeTextStyle(color: Colors.white),
              showLabels: false,
              pointers: <GaugePointer>[
                RangePointer(
                  value: _tempHumList![9].temprature,
                  width: 5,
                  enableAnimation: true,
                  gradient: const SweepGradient(
                    colors: <Color>[Color(0xFF753A88), Color(0xFFCC2B5E)],
                    stops: <double>[0.25, 0.75],
                  ),
                  dashArray: <double>[5, 2],
                ),
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          '${_tempHumList![9].temprature}°C',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(width: screenWidth/1.1,height: 200,
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: 'Instant Temperature',
                textStyle: TextStyle(color: Colors.white)
              ),
              labelStyle: TextStyle(color: Colors.white),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
                labelFormat: '{value}°C'

            ),
            series: <CartesianSeries>[
              // Renders line chart,

              LineSeries<Temp_Hum, String>(
                  dataSource: _tempHumList  ,
                  xValueMapper: (Temp_Hum data, _) => data.time,
                  yValueMapper: (Temp_Hum data, _) => data.temprature,
                color:Colors.red,

              )
            ]
        ),
      ),
      SizedBox(width: screenWidth/1.1,height: 200,
        child: SfCartesianChart(
          borderWidth: 0,

            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: 'Instant Temperature',
                textStyle: TextStyle(color: Colors.white),

              ),

              labelStyle: TextStyle(color: Colors.white),

              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
                labelFormat: '{value}°C'
            ),
            series: <CartesianSeries>[
              // Renders line chart,

              ColumnSeries<Temp_Hum, String>(
                  dataSource: _tempHumList  ,
                  xValueMapper: (Temp_Hum data, _) => data.time,
                  yValueMapper: (Temp_Hum data, _) => data.temprature,
                  color:Colors.red,
              )
            ]
        ),
      )
    ],
  );
}Widget _buildHum(List<Temp_Hum>? _tempHumList,double screenWidth,String type) {

  return Column(
    children: [
      Text("${_tempHumList?[9].temprature}"),
      SizedBox(height: 100,
        child: _buildRadial(_tempHumList![9].humidty,"%")
      ),
      SizedBox(width: screenWidth/1.1,height: 200,
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: 'Instant Humidity',
              ),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelFormat: '{value}%'

            ),
            series: <CartesianSeries>[
              // Renders line chart,

              LineSeries<Temp_Hum, String>(
                dataSource: _tempHumList  ,
                xValueMapper: (Temp_Hum data, _) => data.time,
                yValueMapper: (Temp_Hum data, _) => data.humidty,
                color:Colors.red,

              )
            ]
        ),
      ),
      SizedBox(width: screenWidth/1.1,height: 200,
        child: SfCartesianChart(
            borderWidth: 0,

            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: 'Tarih',
                textStyle: TextStyle(color: Colors.white),

              ),

              labelStyle: TextStyle(color: Colors.white),

              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelFormat: '{value}°C'
            ),
            series: <CartesianSeries>[
              // Renders line chart,

              ColumnSeries<Temp_Hum, String>(
                dataSource: _tempHumList  ,
                xValueMapper: (Temp_Hum data, _) => data.time,
                yValueMapper: (Temp_Hum data, _) => data.humidty,
                color:Colors.red,
              )
            ]
        ),
      )
    ],
  );
}
Widget _buildRadial(double value,String symbol){
return SfRadialGauge(
  axes: <RadialAxis>[
    RadialAxis(
      minimum: 0,
      maximum: 100,
      axisLineStyle: AxisLineStyle(thickness: 5),
      axisLabelStyle: GaugeTextStyle(color: Colors.white),
      showLabels: false,
      pointers: <GaugePointer>[
        RangePointer(
          value: value,
          width: 5,
          enableAnimation: true,
          gradient: const SweepGradient(
            colors: <Color>[Color(0xFF753A88), Color(0xFFCC2B5E)],
            stops: <double>[0.25, 0.75],
          ),
          dashArray: <double>[5, 2],
        ),
      ],
      annotations: <GaugeAnnotation>[
        GaugeAnnotation(
          widget: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  '$value$symbol',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ],
);
}
Widget buildStable(String type,double value)
{
  return Column(
    children: [
      Icon(Icons.gas_meter_outlined,size: 100,color: Colors.green,),

      Text(value >360 ?"Gas level is not stable!!" :"Gas level is stable.",style: TextStyle(color: Colors.white),)
    ],
  );

}
