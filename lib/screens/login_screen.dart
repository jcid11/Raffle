import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/HomePage.dart';
import 'package:raffle_project/constant.dart';
import 'package:raffle_project/screens/new_item.dart';
import 'package:raffle_project/screens/splash_screen.dart';

class LogInScreen extends StatelessWidget {
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void currentUser() async{
    final user = await _auth.currentUser;
    if(user!=null){
      final loggedInUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: txtEmail,
                  decoration: kEnterDecoration.copyWith(
                    hintText: 'Email'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  controller: txtPassword,
                  decoration: kEnterDecoration.copyWith(
                    hintText: 'Password'
                  ),
                ),
              ),
              RawMaterialButton(onPressed: ()async{
                try{
                  final user = await _auth.signInWithEmailAndPassword(email: txtEmail.text, password: txtPassword.text);
                  if(user != null){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SplashScreen()));
                  }
                }catch (e){
                  print(e);
                }
               await _auth.signInWithEmailAndPassword(email: txtEmail.text, password: txtPassword.text);
              },child: Container(
                color: Colors.blueGrey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Log in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
