import 'dart:developer';

import 'package:untitled5/screen/BottomNavigationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:untitled5/screen/signup.dart';
import 'package:untitled5/services/infoServices.dart';

void main() {
  runApp(
     MyApp(),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const login(title: 'Flutter Demo Home Page'),
    );
  }
}

class login extends StatefulWidget {
  const login({super.key, required this.title});



  final String title;

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
   var formKey=GlobalKey<FormState>();
   var  tfmail=TextEditingController();
   var tfpassword=TextEditingController();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLoginStatus();

  }
   void _checkLoginStatus() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String? savedEmail = prefs.getString('email');
     String? savedPassword = prefs.getString('password');

     if (savedEmail != null && savedPassword != null) {
       // Localde kayıtlı email ve şifre var, otomatik giriş yapılabilir.
       print("User");
       bool loginSuccess = await loginUser(savedEmail, savedPassword);

       if (loginSuccess) {
         // Giriş başarılı, yönlendirme veya diğer işlemleri gerçekleştirin

         // SnackBar'ı anasayfada göster
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Giriş başarılı'),
             duration: Duration(seconds: 2),

           ),
         );
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationScreen()));
       } else {
         // Giriş başarısız

         // SnackBar'ı anasayfada göster
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Giriş başarısız'),
             duration: Duration(seconds: 2),

           ),
         );
       }
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:Center(

        child: SingleChildScrollView(
          child: Column(
              children: [
                SizedBox(
                    height:150,
                    child: Image.asset("images/loginlogo.png",)),
                const Text("Smart Home",style: TextStyle(fontSize: 36),),
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 45.0,right: 45,bottom: 15),
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              controller: tfmail,
                              decoration: const InputDecoration(
                                labelText: "Mail",
                                prefixIcon: Icon(Icons.mail),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 45.0,right:45,),
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              obscureText: true,
                              controller: tfpassword,
                              decoration: const InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10)
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(height: 40,
                            child: ElevatedButton(onPressed: () async {
                              bool loginSuccess = await loginUser(tfmail.text, tfpassword.text);

                              if (loginSuccess) {
                                // Giriş başarılı, yönlendirme veya diğer işlemleri gerçekleştirin

                                // SnackBar'ı anasayfada göster
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Giriş başarılı'),
                                    duration: Duration(seconds: 2),
                                    
                                  ),
                                );
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavigationScreen()));
                              } else {
                                // Giriş başarısız

                                // SnackBar'ı anasayfada göster
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Giriş başarısız'),
                                    duration: Duration(seconds: 2),
                                    
                                  ),
                                );
                              }






                            }, child: const Text("Sign In ",style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10)))
                            ),
                            ),
                            
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(height:40,width: 220,
                            child: ElevatedButton(onPressed: ()  {
                            }, child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width:30, child: Image.asset("images/google.png")),
                                const Text("Sign In With Google",style: TextStyle(color: Colors.white),),
                              ],
                            ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10)))
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
               Row(
                 mainAxisAlignment:MainAxisAlignment.center,
                   children: [
                    Text("Don't have an account?"),
                     GestureDetector(onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>signup()));
                     },
                       child:Text("Sign Up",style:TextStyle(color: Colors.deepPurpleAccent),),),
                     const SizedBox(height: 100,),
                  ],),



              ],
            )
        ),
      )
    );
  }
}


