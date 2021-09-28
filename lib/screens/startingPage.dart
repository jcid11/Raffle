import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/screens/login_screen.dart';
import 'package:raffle_project/screens/registration_screen.dart';

class startingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyPage(),
    );
  }
}

class bodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LogInScreen()));
              },
              child: Container(
                child: Text('Login'),
              )),
          RawMaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => preregistrationScreen()));
              },
              child: Container(
                child: Text('Register'),
              ))
        ],
      ),
    );
  }
}
