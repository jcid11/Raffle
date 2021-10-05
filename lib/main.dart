import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:raffle_project/HomePage.dart';
import 'package:raffle_project/screens/login_screen.dart';
import 'package:raffle_project/screens/new_item.dart';
import 'package:raffle_project/screens/profile_page.dart';
import 'package:raffle_project/screens/registration_screen.dart';
import 'package:raffle_project/screens/splash_screen.dart';
import 'package:raffle_project/screens/startingPage.dart';
import 'package:raffle_project/service/user_service.dart';

final _auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDefault();
  runApp(MyApp(
  ));
}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  assert(app != null);
  print('Initialized default app $app');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserService.checkIfUserIsLogged()?HomePage():LogInScreen(),
    );
  }
}

// ProfilePage(email: _auth.currentUser!.email.toString())
