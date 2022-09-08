import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:raffle_project/HomePage.dart';
import 'package:raffle_project/constant.dart';
import 'package:raffle_project/constants.dart';
import 'package:raffle_project/screens/new_item.dart';
import 'package:raffle_project/screens/registration_screen.dart';
import 'package:raffle_project/screens/splash_screen.dart';

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: loginBody());
  }
}

class loginBody extends StatelessWidget {
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            padding: kStartingPagePadding,
            decoration: kBackgroundColorDesign,
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          style: kTextFieldStyle,
                          controller: txtEmail,
                          decoration: kTextFormStyle.copyWith()),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          style: kTextFieldStyle,
                          obscureText: true,
                          controller: txtPassword,
                          decoration:
                              kTextFormStyle.copyWith(labelText: 'Contraseña')),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    RawMaterialButton(
                      onPressed: () async {
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: txtEmail.text, password: txtPassword.text);
                          if (user != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SplashScreen()));
                          }
                        } catch (e) {
                          print(e);
                        }
                        await _auth.signInWithEmailAndPassword(
                            email: txtEmail.text, password: txtPassword.text);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Material(
                              borderRadius: kButtonRadius,
                              elevation: 1,
                              child: Container(
                                child: Padding(
                                  padding: kButtonPadding,
                                  child: Text(
                                    'LOG IN',
                                    textAlign: TextAlign.center,
                                    style: kButtonStyle,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xFFdef6ff),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => preregistrationScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Material(
                              borderRadius: kButtonRadius,
                              elevation: 1,
                              child: Container(
                                child: Padding(
                                  padding: kButtonPadding,
                                  child: Text(
                                    'REGISTRARSE',
                                    textAlign: TextAlign.center,
                                    style: kButtonStyle.copyWith(
                                        color: Colors.white70),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xFF02a1cf),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: RawMaterialButton(
                      onPressed: () {},
                      child: Text(
                        'Olvido su contraseña?',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    )),
                    Center(
                        child: Text(
                      'Made by SnowEats',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 10),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
