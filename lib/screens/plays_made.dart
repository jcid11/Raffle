import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/service/plays_model.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class PlaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plays Page'),
      ),
      body: Container(
          height:200,
          child: playStream()),
    );
  }
}

class playStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Entrance').where('user',isEqualTo: _auth.currentUser!.email).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return Text('no dataaaaaaaaaaaaaaaaaaaaaaaaaaa');
        }
        List<QueryDocumentSnapshot> items = snapshot.data!.docs;
        int playsMadeLength = snapshot.data!.docs.length;
        if(playsMadeLength>0){
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              QueryDocumentSnapshot doc = items[index];
              return ListTile(title: Text('Numero ${doc.get('number')} => ${doc.get('itemName')} => ${doc.get('date')} => ${doc.get('itemPrice')}'),);
            },
          );
        }else{
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Aun no ha jugado ningun numero'),
          );
        }
      },
    );
  }
}

class playsContentStream extends StatefulWidget {
  final PlaysModel playsModel;

  playsContentStream({required this.playsModel});

  @override
  _playsContentStreamState createState() => _playsContentStreamState();
}

class _playsContentStreamState extends State<playsContentStream> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.playsModel.id);
    print(widget.playsModel.email);
    print(widget.playsModel.length);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Entrance').where('itemName',isEqualTo: widget.playsModel.name).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(!snapshot.hasData){
            return Text('No data has been implemented yet');
          }
          int qty = snapshot.data.docs.length;
          List<PlaysTestModel>testList= [];
          var items = snapshot.data.docs;
          for(var item in items){
            final itemName = widget.playsModel.name;
            final itemPrice= widget.playsModel.price;
            final length= qty;

            testList.add(PlaysTestModel(name: itemName, price: itemPrice, length: qty));
          }
          return playcontentTest(price: widget.playsModel.price, length: qty, name: widget.playsModel.name,);
        });

  }
}

class playcontentTest extends StatelessWidget {
  final String name;
  final String price;
  final int length;

  const playcontentTest({ required this.name, required this.price, required this.length});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Text('Usted ha jugado el item $name, por un monto de $price, una cantidad de $length'),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}


