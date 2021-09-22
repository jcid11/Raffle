import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/screens/new_item.dart';
import 'package:raffle_project/screens/profile_page.dart';
import 'package:raffle_project/service/user_service.dart';
import 'package:raffle_project/type_of_account.dart';

import '../HomePage.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new UserService().getUserInfo().then((value){
      switch(value){
        case TypeOfAccount.RIFADOR:
          //ir a la pantalla del rifador
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ProfilePage(email: _auth.currentUser!.email.toString())));
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              ProfilePage(email: _auth.currentUser!.email.toString())), (Route<dynamic> route) => false);
          break;
        case TypeOfAccount.ADMIN:
        //ir a la pantalla del admin
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(email: _auth.currentUser!.email.toString())));
          break;
        default:
        //ir a la panalla del usuario
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()));

          break;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
