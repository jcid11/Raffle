import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/screens/item_history.dart';
import 'package:raffle_project/service/plays_model.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de items creados'),
      ),
      body: itemStream(),
    );
  }
}

class itemStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Company').doc(_auth.currentUser!.email.toString()).collection('Products').where('CompanyEmail',isEqualTo: _auth.currentUser!.email.toString()).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('no data');
        }
        List<QueryDocumentSnapshot> items = snapshot.data!.docs;
        int itemQty = snapshot.data!.docs.length;
        if(itemQty>0){
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              QueryDocumentSnapshot doc = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: RawMaterialButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemHistory(itemName: doc.get('ItemName'))));
                      },
                      child: Row(
                        children: [
                          Expanded(child: Text('${doc.get('ItemName')} => ${doc.get('date')}')),
                          Text('Ver historial',style: TextStyle(fontSize: 12,color: Colors.blueGrey),)
                        ],
                      )),
                ),
              );
            },
          );
        }else{
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No se ha creado ningun articulo aun'),
          );
        }

      },
    );
  }
}

