import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/screens/items_made.dart';
import 'package:raffle_project/screens/plays_made.dart';
import 'package:raffle_project/screens/raffle_items.dart';
import 'package:raffle_project/screens/startingPage.dart';
import 'package:raffle_project/service/profile_model.dart';
import 'package:raffle_project/service/user_service.dart';
import '../constants.dart';
import '../type_of_account.dart';
import 'new_item.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: Row(
          children: [
            Expanded(child: Text('Profile Page')),
            RawMaterialButton(onPressed: (){_auth.signOut();Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>startingPage()));},child: Text('Sign out',style: TextStyle(color: Colors.white),),),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.lightBlue,
            child: Column(
              children: [
                RawMaterialButton(
                  onPressed: (){
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('https://uifaces.co/our-content/donated/rSuiu_Hr.jpg'),
                      radius: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0,left: 12.0,right: 12.0,bottom: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('12',style: kProfileTextColor,),
                            Text('Items listed',style: kProfileTextColor,)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('12',style: kProfileTextColor,),
                            Text('Items done',style: kProfileTextColor,)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('user').where('email',isEqualTo: widget.email).snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Text('has no data');
                }
                List<ProfilelowerModel> lowermodelList=[];
                final items = snapshot.data!.docs;
                for(var item in items){
                  final profileName = item.get('name');
                  final profileEmail = item.get('email');
                  final profileIdentification = item.get('identification');
                  final profileCategory = item.get('category');
                  lowermodelList.add(ProfilelowerModel(name: profileName, email: profileEmail, identification: profileIdentification, category: profileCategory));
                }
                return ListView.builder(
                  itemCount: lowermodelList.length,
                  itemBuilder: (BuildContext context, int index){
                    return lowerProfileContent(profilelowerModel: lowermodelList[index],index: index,);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class lowerProfileContent extends StatefulWidget {
  bool userPage = true;
  final ProfilelowerModel profilelowerModel;
  final int index;

  lowerProfileContent({required this.profilelowerModel, required this.index});
  @override
  _lowerProfileContentState createState() => _lowerProfileContentState();
}

class _lowerProfileContentState extends State<lowerProfileContent> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.profilelowerModel.category!='user'){
      widget.userPage = false;
    }else{
      widget.userPage =true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.userPage?false:true,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewItem()));
            }, icon: Icon(Icons.add,color: Colors.white,), label: Text('Register new item'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0,top: 8),
              child: Text('Change profile picture',style: kProfileTextMiniature,),
            ),
            RawMaterialButton(
              onPressed: (){
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://uifaces.co/our-content/donated/rSuiu_Hr.jpg'),
                        ),
                        SizedBox(width: 15,),
                        Expanded(child: Text('Change profile picture',style: kProfileTextMiniature,)),
                        Icon(Icons.keyboard_arrow_right_sharp,color: Colors.grey,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0,top: 16),
              child: Text('User information',style: kProfileTextMiniature,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right:8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.mail,size: 24,color: Colors.grey,),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Text(widget.profilelowerModel.email,style: kProfileTextMiniature,)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right:8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.person,size: 24,color: Colors.grey,),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Text(widget.profilelowerModel.name,style: kProfileTextMiniature,)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right:8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.credit_card,size: 24,color: Colors.grey,),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Text(widget.profilelowerModel.identification,style: kProfileTextMiniature,)),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0,top: 16),
              child: Text('Password',style: kProfileTextMiniature,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right:8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.lock,size: 24,color: Colors.grey,),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Text('Change your password',style: kProfileTextMiniature,)),
                      Icon(Icons.keyboard_arrow_right_sharp,color: Colors.grey,)
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
        Visibility(
          visible: widget.userPage?true:false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0,top: 16),
                child: Text('Plays',style: kProfileTextMiniature,),
              ),
              RawMaterialButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaysPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right:8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.verified_user,size: 24,color: Colors.grey,),
                          ),
                          SizedBox(width: 15,),
                          Expanded(child: Text('Plays i have made',style: kProfileTextMiniature,)),
                          Icon(Icons.keyboard_arrow_right_sharp,color: Colors.grey,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.userPage?false:true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0,top: 16),
                child: Text('Items',style: kProfileTextMiniature,),
              ),
              RawMaterialButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemsPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0,right:8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.verified_user,size: 24,color: Colors.grey,),
                          ),
                          SizedBox(width: 15,),
                          Expanded(child: Text('Items Made',style: kProfileTextMiniature,)),
                          Icon(Icons.keyboard_arrow_right_sharp,color: Colors.grey,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


