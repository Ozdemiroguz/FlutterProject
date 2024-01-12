import 'package:flutter/material.dart';
import 'package:untitled5/screen/login.dart';
import 'package:untitled5/Info.dart';

import '../services/infoServices.dart';

void main() {
  runApp(const MyApp());
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
      home: const signup(),
    );
  }
}

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  var formKey = GlobalKey<FormState>();
  var tfmail = TextEditingController();
  var tfphone = TextEditingController();

  var tfname = TextEditingController();
  var tfsurname = TextEditingController();
  var tfPassword = TextEditingController();
  var tfconfirmPassword = TextEditingController();
  double ilerleme = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              SizedBox(
                  height: 50,
                  child: Image.asset(
                    "images/loginlogo.png",
                  )),
              Text(
                "Smart Home",
                style: TextStyle(fontSize: 36),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 45.0, right: 45, bottom: 15),
                        child: SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: tfname,
                            decoration: InputDecoration(
                                labelText: "Name",
                                prefixIcon: Icon(Icons.person_pin),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                            validator: (tfinput) {
                              if (tfinput!.isEmpty) {
                                return "Please enter a name";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 45.0, right: 45, bottom: 15),
                        child: SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: tfsurname,
                            decoration: InputDecoration(
                                labelText: "Surname",
                                prefixIcon: Icon(Icons.person_pin),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                            validator: (tfinput) {
                              if (tfinput!.isEmpty) {
                                return "Please enter a surname";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 45.0, right: 45, bottom: 15),
                        child: SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: tfmail,
                            decoration: InputDecoration(
                                labelText: "Mail",
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                            validator: (tfinput) {
                              if (tfinput!.isEmpty) {
                                return "Please enter a email address";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 45.0, right: 45, bottom: 15),
                        child: SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: tfphone,
                            decoration: InputDecoration(
                                labelText: "Phone",
                                prefixIcon: Icon(Icons.phone_paused_sharp),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                            validator: (tfinput) {
                              if (tfinput!.isEmpty) {
                                return "Please enter a phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 45.0, right: 45, bottom: 15),
                        child: SizedBox(
                          height: 60,
                          child: TextFormField(
                            obscureText: true,
                            controller: tfPassword,
                            decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                            validator: (tfinput) {
                              if (tfinput!.isEmpty) {
                                return "Please enter a password";
                              }
                              if (tfinput.length < 6) {
                                return "Your password must consist of at least 6 characters";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 45.0,
                          right: 45,
                        ),
                        child: SizedBox(
                          height: 60,
                          child: TextFormField(
                            obscureText: true,
                            controller: tfconfirmPassword,
                            decoration: InputDecoration(
                                labelText: "Confirm Password",
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10)),
                            validator: (tfinput) {
                              if (tfinput!.isEmpty) {
                                return "Please enter a password";
                              }
                              if (tfinput.length < 6) {
                                return "Your password must consist of at least 6 characters";
                              }
                              if (tfinput! != tfPassword.text) {
                                return "Your passwords must match";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              bool kontrolSonucu =
                                  formKey.currentState!.validate();
                              if (kontrolSonucu) {
                                //kullanıcı nesnesini oluştur ve doldur
                                User user = User(
                                    1,
                                    tfname.text,
                                    tfsurname.text,
                                    tfmail.text,
                                    tfPassword.text,
                                    tfphone.text,
                                    0,
                                    0);
                                //nesneyi kısım kısım yazdır
                                print(user.name);
                                print(user.surname);
                                print(user.email);

                                // Kullanıcıyı kaydet
                                bool isRegistered = await registerUser(user);

                                if (isRegistered) {
                                  // Kayıt başarılı
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Kayıt başarılı'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                   Navigator.push(
                                     context,
                                    MaterialPageRoute(builder: (context) => login(title: "title")),
                                   );
                                } else {
                                  // Kayıt başarısız
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Kayıt başarısız'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 40,
                          width: 220,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 30,
                                    child: Image.asset("images/google.png")),
                                const Text(
                                  "Sign In With Google",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)))),
                          ),
                        ),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => login(title: "Login")));
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ],
          )),
        ));
  }
}
