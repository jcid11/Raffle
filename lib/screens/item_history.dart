import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ItemHistory extends StatelessWidget {
  final String itemName;

  const ItemHistory({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$itemName historial'),
      ),
      body: itemStream(
        itemName: itemName,
      ),
    );
  }
}

class itemStream extends StatelessWidget {
  final String itemName;

  const itemStream({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Entrance')
            .where('itemName', isEqualTo: itemName)
            .where('user', isEqualTo: _auth.currentUser!.email.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('no data');
          }
          print(snapshot.data!.docs.length);
          List<QueryDocumentSnapshot> items = snapshot.data!.docs;
          return Container(
            height: 500,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                QueryDocumentSnapshot doc = items[index];
                return ListTile(
                  title: Text(
                      'Numero ${doc.get('number')} articulo ${doc.get('itemName')} => ${doc.get('date')} por el usuario de correo ${doc.get('user')}'),
                );
              },
            ),
          );
        });
  }
}
