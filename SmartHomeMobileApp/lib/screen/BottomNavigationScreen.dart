import 'package:flutter/material.dart';
import 'package:untitled5/screen/statsScreen.dart';
import '../models/color.dart';
import 'home.dart';
import 'userScreen.dart';
import 'package:get/get.dart';
import 'chat_page.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color darkBack=ColorConverter.hexToColor("49108B");
    Color softBack=ColorConverter.hexToColor("7E30E1");
    double screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<BottomNavigationController>(
        init: BottomNavigationController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: IndexedStack(
                index: 0,
                children: [
                  [
                    HomePage(),
                    ChatPage(),
                    StatsScreen(),
                    UserInfo(),

                  ][controller.index]
                ],
              ),
              bottomNavigationBar: SizedBox(
                width: screenWidth/1.05,
                child: Container(
                  decoration: BoxDecoration(color: darkBack),
                  child: BottomNavigationBar(
                    elevation: 25,
                    currentIndex: controller.index,
                    onTap: controller.setIndex,
                    selectedLabelStyle: TextStyle(fontSize: 1),
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey,
                      items: [

                      BottomNavigationBarItem(

                        icon: Icon(Icons.home),
                        label: 'a',
                        backgroundColor:softBack,

                      ),

                      BottomNavigationBarItem(
                        icon: Icon(Icons.verified_user),
                        label: '',
                        backgroundColor:softBack,

                      ),
                       BottomNavigationBarItem(
                        icon: Icon(Icons.signal_cellular_alt),
                        label: '',
                        backgroundColor:softBack,

                      ),
                       BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: '',
                        backgroundColor:softBack,

                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class BottomNavigationController extends GetxController {
  int index = 0;
  var value = 20.0.obs;

  void setIndex(int index) {
    this.index = index;
    update();
  }

  void setValue(double value) {
    this.value.value = value;
  }
}