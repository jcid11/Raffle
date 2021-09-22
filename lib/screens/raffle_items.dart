import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/ItemModel.dart';
import 'package:raffle_project/screens/raffle_screen.dart';
import 'package:raffle_project/service/raffle_model.dart';
import 'package:raffle_project/service/user_service.dart';

final _firestore = FirebaseFirestore.instance;

class RaffleItemPage extends StatefulWidget {
  final String company;


  RaffleItemPage({required this.company});

  @override
  _RaffleItemPageState createState() => _RaffleItemPageState();
}

class _RaffleItemPageState extends State<RaffleItemPage> {


  @override
  void initState() {
    // TODO: implement initState
    UserService().getUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: Text('Raffle Items'),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
            child: Container(
              color: Colors.grey[100],
              height: 70,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('user').where('email',isEqualTo: widget.company).snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData){
                    return Text('has no data yet');
                  }
                  List<RaffleModel> raffleList = [];
                  final items = snapshot.data!.docs;
                  for(var item in items){
                    final companyName = item.get('name');
                    final companyEmail =  item.get('email');

                    raffleList.add(RaffleModel(name: companyName, email: companyEmail));
                  }
                  return  ListView.builder(
                    itemCount: raffleList.length,
                    itemBuilder: (BuildContext context, int index){
                      return companyStreamContent(raffleModel: raffleList[index], index: index);
                    },
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('Company').doc(widget.company).collection('Products').snapshots(),
                  builder:(context, snapshot){
                    if(!snapshot.hasData){
                      return Text('No item for raffle has been sorted yet');
                    }
                    List<ItemModel> ListModel=[];
                    final items =snapshot.data!.docs;
                    for(var item in items){
                      final messageName = item.get('ItemName');
                      final messagePrice = item.get('ItemPrice');
                      final itemID = item.id;
                      final companyEmail = item.get('CompanyEmail');
                      ListModel.add(ItemModel(name:messageName,price:messagePrice,id:itemID,email: companyEmail));
                    }
                    return ListView.builder(
                      itemCount: ListModel.length,
                      itemBuilder: (BuildContext context, int index){
                        return bodyStreamContent( itemModel:ListModel[index], index:index);
                      },);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}


class bodyStreamContent extends StatelessWidget {
  final ItemModel itemModel;
  final int index;


  bodyStreamContent({required this.itemModel, required this.index});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: _firestore.collection('Entrance').where('idItem',isEqualTo: itemModel.id).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          int quantity = snapshot.data.docs.length;
          return Padding(
            padding: const EdgeInsets.only(top: 4.0,bottom: 4,left: 8,right: 8),
            child: RawMaterialButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RaffleScreen(id:itemModel.id,email: itemModel.email,name: itemModel.name,price: itemModel.price,)));
              },
              child: Card(
                color: Colors.grey[200],
                elevation: 2,
                child: ListTile(
                  title: Text(itemModel.name),
                  subtitle: Text('Boletos ${itemModel.price} c/u, quedan ${100-quantity} boletos '),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('images/1.png',width: 60,height:60,fit: BoxFit.fill,),
                  ),
                ),
              ),
            ),
          );
        }else{
          return Padding(
            padding: const EdgeInsets.only(top: 4.0,bottom: 4,left: 8,right: 8),
            child: RawMaterialButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RaffleScreen(id:itemModel.id,email: itemModel.email,name: itemModel.name,price: itemModel.price,)));
              },
              child: Card(
                color: Colors.grey[200],
                elevation: 2,
                child: ListTile(
                  title: Text(itemModel.name),
                  subtitle: Text('Boletos ${itemModel.price} c/u, quedan 100 boletos '),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset('images/1.png',width: 60,height:60,fit: BoxFit.fill,),
                  ),
                ),
              ),
            ),
          );
        }
      },);
  }
}

class companyStreamContent extends StatelessWidget {
  final RaffleModel raffleModel;
  final int index;

  companyStreamContent({required this.raffleModel, required this.index});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:CircleAvatar(backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1009159188549808130/XCxcD7eS.jpg'),),
      title: Text(raffleModel.name),
      subtitle: Text(raffleModel.email),
    );
  }
}



