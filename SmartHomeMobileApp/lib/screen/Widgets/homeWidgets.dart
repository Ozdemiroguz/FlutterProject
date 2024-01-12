import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:untitled5/Info.dart';

Widget buildRadial(SensorReading sensorReadings){

  return   Center(
    child: SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 180,
                child:                                   // Card(color:softBack,child: ,)
                SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 51,
                      axisLineStyle: AxisLineStyle(thickness: 10),
                      axisLabelStyle: GaugeTextStyle(color: Colors.white),
                      showLabels: false,
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: sensorReadings.temperature,
                          width: 10,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  '${sensorReadings.temperature}°C',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Text(
                                  "Temperature",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  buildCard('Humidty', sensorReadings.humidity),
                  buildCard('Gas', sensorReadings.gas),
                  buildCard('Fire',sensorReadings.fire.toDouble()),
                  buildCard('Move', sensorReadings.move.toDouble()),

                ],
              ),
            )
          ],
        ),

      ),

    ),
  );
}
Widget buildCard(String type, double value) {
  String symbol = type == 'Humidty' ? '%' : '';

  final Map<String, IconData> valueIcons = {
    'Gas': Icons.gas_meter_outlined,
    'Humidty': Icons.water_drop_outlined,
    'Fire': Icons.local_fire_department,

  };
  return
    Column(
      children: [

        Icon(
          valueIcons[type] ?? Icons.light_mode,
          color: Colors.white,
          size: 24,
        ),
        Text('$value$symbol',style: TextStyle(color: Colors.white),),
        Text(type ,style: TextStyle(color: Colors.white),),
      ],
    );

}
