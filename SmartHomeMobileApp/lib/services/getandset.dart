import 'package:shared_preferences/shared_preferences.dart';
Future<String?>getUserName() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? temp=prefs.getString("userName");
  return temp;
  

}