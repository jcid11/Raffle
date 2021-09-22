import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:raffle_project/alertDialog.dart';

final _firestore = FirebaseFirestore.instance;

class RaffleScreen extends StatelessWidget {
  final String name;
  final String price;
  final String id;
  final String email;
  RaffleScreen({required this.id, required this.email, required this.name, required this.price});

  final List<String> items = List<String>.generate(100, (i) => '${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rifa de numeros(prueba)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                   return numberContainer(
                       index: index, number:int.parse(items[index]) , id: id,email: email,name: name,price: price,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> checkIfNumberWasTaken(int number)async {
    QuerySnapshot querySnapshot=await _firestore
        .collection('Entrance')
        .where('number', isEqualTo: number)
        .get();

      return querySnapshot.docs.length>0;

  }
}

class numberContainer extends StatefulWidget {
  final int number;
  final int index;
  final String id;
  final String email;
  final String name;
  final String price;


  numberContainer(
      {required this.number, required this.index, required this.id, required this.email, required this.name, required this.price});

  @override
  _numberContainerState createState() => _numberContainerState();
}

class _numberContainerState extends State<numberContainer> {
  bool backGround = false;
  Color color = Colors.green;
  final _auth = FirebaseAuth.instance;

  addEntrance() async {
    String dateTime = DateFormat( "dd/MM/yy hh:mm aa").format(DateTime.now());
    var map = new Map<String, dynamic>();
    map['user'] = _auth.currentUser!.email;
    map['number'] = widget.index + 1;
    map['idItem'] = widget.id;
    map['companyEmail']=widget.email;
    map['itemName'] =widget.name;
    map['itemPrice']= widget.price;
    map['date']= dateTime;
    await _firestore.collection('Entrance').add(map);
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: _firestore
              .collection('Entrance')
              .where('number', isEqualTo: widget.number).where('idItem',isEqualTo: widget.id)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              int qty = snapshot.data!.docs.length;
              if (qty > 0) {
                color=Colors.red;
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: color, borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                        child: RawMaterialButton(
                          onPressed: () {
                            //TODO
                            showDialog(context: context, builder: (_)=>alertDenialDialog(number: widget.number.toString()));
                          },
                          child: Text('${widget.number}'),
                        ),
                      ),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: color, borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))),
                        child: RawMaterialButton(
                          onPressed: () {
                            showDialog(context: context, builder: (_)=>alertDialogModel(number: widget.number.toString()));
                            addEntrance();
                            color=Colors.red;
                          },
                          child: Text('${widget.number}'),
                        ),
                      ),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                      )
                    ],
                  ),
                );
              }
            }
            return Text('Cargando...');
          },
        ),
      ],
    );
  }
}


