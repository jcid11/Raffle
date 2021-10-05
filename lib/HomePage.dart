import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/screens/plays_made.dart';
import 'package:raffle_project/screens/profile_page.dart';
import 'package:raffle_project/screens/raffle_items.dart';
import 'package:raffle_project/service/homepagemodel.dart';
import 'package:raffle_project/service/user_service.dart';

import 'constants.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePageDesign(),
    );
  }
}

class HomePageDesign extends StatefulWidget {
  @override
  State<HomePageDesign> createState() => _HomePageDesignState();
}

class _HomePageDesignState extends State<HomePageDesign> {
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: UserService().getUserPersonalInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            }
            return Text('Bienvenido, ${snapshot.data.name ?? ''}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0xFF81d1dd),
                Color(0xFF73cbde),
                // Color(0xFFaeb6c8),
                Color(0xFF5fc2e0),
                Color(0xFF4abae4),
                Color(0xFF3ab4e4),
                Color(0xFF2B9ED2),
              ]
            )
          ),
        ),
        actions: [
          RawMaterialButton(
            onPressed: () {},
            child: Icon(
              Icons.login,
              color: Colors.red,
              size: 30,
            ),
          )
        ],
      ),
      drawer: Drawer(),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            homePageStream(),
            Container(
              color: Colors.red,
            ),
            ProfilePage(email: _auth.currentUser!.email.toString()),
            PlaysPage()
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text(
                'Home',
                style: TextStyle(color: kBottomNavigationBarColor),
              ),
              icon: Icon(
                Icons.home,
                color: kBottomNavigationBarColor,
              )),
          BottomNavyBarItem(
              title: Text(
                'Forma de pago',
                style: TextStyle(color: kBottomNavigationBarColor),
              ),
              icon: Icon(
                Icons.credit_card,
                color: kBottomNavigationBarColor,
              )),
          BottomNavyBarItem(
              title: Text(
                'Perfil',
                style: (TextStyle(color: kBottomNavigationBarColor)),
              ),
              icon: Icon(
                Icons.person,
                color: kBottomNavigationBarColor,
              )),
          BottomNavyBarItem(
              title: Text(
                'Historial',
                style: (TextStyle(color: kBottomNavigationBarColor)),
              ),
              icon: Icon(
                Icons.notes,
                color: kBottomNavigationBarColor,
              )),
        ],
      ),
    );
  }
}

class homePageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('user')
                  .where('typeOfAccount', isEqualTo: 1)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('No data has been implemented yet');
                }
                List<HomeModel> homeContent = [];
                final items = snapshot.data!.docs;
                for (var item in items) {
                  final companyName = item.get('name');
                  final companyEmail = item.get('email');
                  final companyCategory = item.get('category');

                  homeContent.add(HomeModel(
                      name: companyName,
                      email: companyEmail,
                      category: companyCategory));
                }
                return Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius:BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                        child: Container(
                          color: Colors.grey[100],
                          child: ListView.builder(
                            itemCount: homeContent.length,
                            itemBuilder: (BuildContext context, int index) {
                              return homePageContent(
                                  homeModel: homeContent[index], index: index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            top: 84,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Icon(Icons.notes,size: 16,),
                      ),
                      SizedBox(width: 10,),
                      Text('Order By'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class homePageContent extends StatelessWidget {
  final HomeModel homeModel;
  final int index;

  homePageContent({required this.homeModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: RawMaterialButton(
        padding: EdgeInsets.all(5),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RaffleItemPage(
                        company: homeModel.email,
                      )));
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Card(
            color: Colors.grey[200],
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://pbs.twimg.com/profile_images/1009159188549808130/XCxcD7eS.jpg'),
              ),
              title: Text(homeModel.name),
              subtitle: Text(homeModel.email),
              trailing: Text(
                homeModel.category,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
