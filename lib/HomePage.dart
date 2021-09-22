import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/screens/profile_page.dart';
import 'package:raffle_project/screens/raffle_items.dart';
import 'package:raffle_project/service/homepagemodel.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(child: Text('Home')),
            RawMaterialButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(email: _auth.currentUser!.email.toString(),)));
                },
                child: CircleAvatar(backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1009159188549808130/XCxcD7eS.jpg'),)),
          ],
        ),

      ),
      body: homePageStream(),
    );
  }
}

class homePageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('user').where('typeOfAccount',isEqualTo: 1).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
        return Text('No data has been implemented yet');
        }
        List<HomeModel> homeContent=[];
        final items = snapshot.data!.docs;
        for(var item in items){
          final companyName = item.get('name');
          final companyEmail = item.get('email');
          final companyCategory = item.get('category');

          homeContent.add(HomeModel(name: companyName, email: companyEmail,category:companyCategory ));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: homeContent.length,
                itemBuilder: (BuildContext context,int index){
                  return homePageContent(homeModel: homeContent[index], index: index);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class homePageContent extends StatelessWidget {

  final HomeModel homeModel;
  final int index;

  homePageContent({required this.homeModel,required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: RawMaterialButton(
        padding: EdgeInsets.all(5),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RaffleItemPage(company: homeModel.email,)));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0,right: 12.0),
          child: Card(
            color: Colors.grey[200],
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1009159188549808130/XCxcD7eS.jpg'),),
              title: Text(homeModel.name),
              subtitle: Text(homeModel.email),
              trailing: Text(homeModel.category,style: TextStyle(fontSize: 12,color: Colors.grey[700]),),
            ),
            // child: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Icon(Icons.person,color: Colors.grey,),
            //       SizedBox(width: 5,),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(homeModel.name),
            //             SizedBox(height: 5,),
            //             Text(homeModel.email)
            //           ],
            //         ),
            //       ),
            //       Text(homeModel.category)
            //     ],
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}


