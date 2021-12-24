import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raffle_project/screens/items_made.dart';
import 'package:raffle_project/screens/plays_made.dart';
import 'package:raffle_project/service/profile_model.dart';
import 'package:raffle_project/service/user_service.dart';
import '../constants.dart';
import 'login_screen.dart';
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
  bool categoryProfile = false;

  @override
  void initState() {
    // TODO: implement initState

    getAccountType();
    super.initState();
  }

  Future<void> getAccountType() async {
    int type = await UserService().getUserInfo();
    if (type == 1) {
      categoryProfile = true;
      setState(() {});
    } else {
      print('category false');
    }
  }

  @override
  Widget build(BuildContext context) {
    return categoryProfile
        ? Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              centerTitle: true,
              actions: [
                RawMaterialButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LogInScreen()));
                  },
                  child: Icon(Icons.clear),
                )
              ],
            ),
            backgroundColor: Colors.grey[200],
            body: Column(
              children: [
                Container(
                  color: Colors.lightBlue,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: RawMaterialButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://uifaces.co/our-content/donated/rSuiu_Hr.jpg'),
                              radius: 60,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12.0, right: 12.0, bottom: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: UserService().getUserPhone(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox();
                                }
                                return Text(
                                    '+${snapshot.data.phoneNumber ?? ''}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('user')
                        .where('email', isEqualTo: widget.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('has no data');
                      }
                      List<ProfilelowerModel> lowermodelList = [];
                      final items = snapshot.data!.docs;

                      for (var item in items) {
                        final profileName = item.get('name');
                        final profileEmail = item.get('email');
                        final profileIdentification =
                            item.get('identification');
                        final profileCategory = item.get('category');
                        lowermodelList.add(ProfilelowerModel(
                            name: profileName,
                            email: profileEmail,
                            identification: profileIdentification,
                            category: profileCategory));
                      }
                      return ListView.builder(
                        itemCount: lowermodelList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return lowerProfileContent(
                            userPage: categoryProfile,
                            profilelowerModel: lowermodelList[index],
                            index: index,
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[200],
            body: Column(
              children: [
                Container(
                  color: Colors.lightBlue,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: RawMaterialButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://uifaces.co/our-content/donated/rSuiu_Hr.jpg'),
                              radius: 60,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, left: 12.0, right: 12.0, bottom: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FutureBuilder(
                              future: UserService().getUserPhone(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox();
                                }
                                return Text(
                                    '+${snapshot.data.phoneNumber ?? ''}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('user')
                        .where('email', isEqualTo: widget.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('has no data');
                      }
                      List<ProfilelowerModel> lowermodelList = [];
                      final items = snapshot.data!.docs;

                      for (var item in items) {
                        final profileName = item.get('name');
                        final profileEmail = item.get('email');
                        final profileIdentification =
                            item.get('identification');
                        final profileCategory = item.get('category');
                        lowermodelList.add(ProfilelowerModel(
                            name: profileName,
                            email: profileEmail,
                            identification: profileIdentification,
                            category: profileCategory));
                      }
                      return ListView.builder(
                        itemCount: lowermodelList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return lowerProfileContent(
                            profilelowerModel: lowermodelList[index],
                            index: index,
                            userPage: categoryProfile,
                          );
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
  final bool userPage;
  final ProfilelowerModel profilelowerModel;
  final int index;

  lowerProfileContent({required this.profilelowerModel, required this.index, required this.userPage});

  @override
  _lowerProfileContentState createState() => _lowerProfileContentState();
}

class _lowerProfileContentState extends State<lowerProfileContent> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.userPage ? true : false,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewItem()));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text('Register new item'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 8.0, top: 8),
              child: Text(
                'Perfil',
                style: kProfileTextMiniature,
              ),
            ),
            RawMaterialButton(
              onPressed: () {},
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://uifaces.co/our-content/donated/rSuiu_Hr.jpg'),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: Text(
                          'Cambiar foto de perfil',
                          style: kProfileTextMiniature,
                        )),
                        Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: Colors.grey,
                        )
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
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 8.0, top: 16),
              child: Text(
                'Información del usuario',
                style: kProfileTextMiniature,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.mail,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Text(
                        widget.profilelowerModel.email,
                        style: kProfileTextMiniature,
                      )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Text(
                        widget.profilelowerModel.name,
                        style: kProfileTextMiniature,
                      )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.credit_card,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Text(
                        widget.profilelowerModel.identification.toString(),
                        style: kProfileTextMiniature,
                      )),
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
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 8.0, top: 16),
              child: Text(
                'Contraseña',
                style: kProfileTextMiniature,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.lock,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Text(
                        'Cambiar contraseña',
                        style: kProfileTextMiniature,
                      )),
                      Icon(
                        Icons.keyboard_arrow_right_sharp,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.userPage ? false : true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0, top: 16),
                child: Text(
                  'Historial',
                  style: kProfileTextMiniature,
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaysPage()));
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Color(0XFF737373).withOpacity(0),
                    builder: (BuildContext context) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: Color(0XFFEEEEEE),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, left: 14, right: 14),
                              child: Text(
                                'Historial',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 14.0, left: 14),
                              child: Divider(
                                thickness: 2,
                              ),
                            ),
                            Expanded(child: playStream())
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.verified_user,
                              size: 24,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Text(
                            'Historial de Jugadas',
                            style: kProfileTextMiniature,
                          )),
                          Icon(
                            Icons.keyboard_arrow_right_sharp,
                            color: Colors.grey,
                          )
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
          visible: widget.userPage ? true : false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0, top: 16),
                child: Text(
                  'Items',
                  style: kProfileTextMiniature,
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ItemsPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Icon(
                              Icons.verified_user,
                              size: 24,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Text(
                            'Items Made',
                            style: kProfileTextMiniature,
                          )),
                          Icon(
                            Icons.keyboard_arrow_right_sharp,
                            color: Colors.grey,
                          )
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
