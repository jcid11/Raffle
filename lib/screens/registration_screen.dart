import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/alertDialog.dart';
import 'package:raffle_project/screens/profile_page.dart';
import 'package:raffle_project/screens/splash_screen.dart';
import 'package:raffle_project/service/user_service.dart';

import '../HomePage.dart';
import '../constant.dart';

class preregistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: registrationScreen(),
    );
  }
}

class registrationScreen extends StatefulWidget {
  @override
  _registrationScreenState createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  bool categoryActivator = false;

  var txtUser = TextEditingController();

  var txtEmail = TextEditingController();

  var txtPassword = TextEditingController();

  var txtIdentification = TextEditingController();

  var txtPhoneNumber = TextEditingController();

  String dropdownValue = '<Type of account>';

  String dropdowncategoryValue = 'Categoria';

  int typeOfAccount = 1;

  final _auth = FirebaseAuth.instance;


  addUser(String category) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: txtEmail.text, password: txtPassword.text);
      if (newUser != null) {
        UserService userService = UserService();
        await userService.createUserOnFirebase(
            email: txtEmail.text,
            password: txtPassword.text,
            name: txtUser.text.trim(),
            typeofaccount: typeOfAccount,
            identification: txtIdentification.text,
            phoneNumber: int.parse(txtPhoneNumber.text),
            category: category);
        txtUser.clear();
        txtPassword.clear();
        txtEmail.clear();
        txtIdentification.clear();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SplashScreen()));
      }
    } catch (e) {
      print(e);
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: txtUser,
                    decoration: kEnterDecoration.copyWith(hintText: 'User'),
                    validator: (String? value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: txtIdentification,
                    decoration: kEnterDecoration.copyWith(
                        hintText: 'Identification Number'),
                    validator: (String? value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: txtPhoneNumber,
                    decoration:
                        kEnterDecoration.copyWith(hintText: 'Phone Number'),
                    validator: (String? value) {
                      if (value!.contains(RegExp(r'[a-zA-Z\\-|\\+]')) &&
                          value != null) {
                        return 'Este campo solo tiene que contener numeros';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: txtEmail,
                    decoration: kEnterDecoration.copyWith(hintText: 'Email'),
                    validator: (String? value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: txtPassword,
                    decoration: kEnterDecoration.copyWith(hintText: 'Password'),
                    validator: (String? value) {
                      if (value.toString().trim().isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      if (newValue == 'Raffler') {
                        categoryActivator = true;
                      } else {
                        categoryActivator = false;
                      }
                    });
                  },
                  items: <String>['<Type of account>', 'Raffler', 'Player']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Visibility(
                  visible: categoryActivator ? true : false,
                  child: DropdownButton<String>(
                    value: dropdowncategoryValue,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdowncategoryValue = newValue!;
                        print(dropdowncategoryValue);
                      });
                    },
                    items: <String>[
                      'Categoria',
                      'Electronica',
                      'Farmacia',
                      'Hogar',
                      'Vehiculo',
                      'Celular'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                MaterialButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        if (dropdownValue == '<Type of account>') {
                          showDialog(
                              context: context,
                              builder: (_) => alertDialogTypeOfAccount(
                                    alertMessage:
                                        'Remember to choose the type of account you will be creating, Thanks.',
                                  ));
                        } else if (dropdownValue == 'Raffler') {
                          if (dropdowncategoryValue == 'Categoria') {
                            showDialog(
                                context: context,
                                builder: (_) => alertDialogTypeOfAccount(
                                    alertMessage:
                                    'Recordar elegir el tipo de compañia que quiere registrar'));
                          }else{
                            addUser(dropdowncategoryValue);
                          }
                        } else {
                          dropdowncategoryValue = 'user';
                          typeOfAccount = 2;
                          addUser(dropdowncategoryValue);
                        }
                      }
                    },
                    child: Container(
                      color: Colors.blueGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
