import 'package:dincer_health_check_service/page/bottom_page.dart';
import 'package:dincer_health_check_service/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String routeName = '/loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService _authService = AuthService();

  isUserLogged() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => BottomPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isUserLogged();
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),

                Padding(
                  padding: const EdgeInsets.all(10),

                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Image.asset('lib/assets/dincer_logo.png')),
                ),
                
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () {
                        print(emailController.text);
                        print(passwordController.text);

                        _authService
                            .signIn(emailController.text, passwordController.text)
                            .then((value) {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => BottomPage()));
                        });
                      },
                    )),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: const Text('Register'),
                      onPressed: () {
                        print(emailController.text);
                        print(passwordController.text);

                        _authService
                            .createPerson(
                                emailController.text, passwordController.text)
                            .then((value) {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => BottomPage()));
                        });
                      },
                    )),
              ],
            )),
      ),
    );
  }
}
