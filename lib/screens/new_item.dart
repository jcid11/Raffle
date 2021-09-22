import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:raffle_project/HomePage.dart';
import 'package:raffle_project/constant.dart';
import 'package:raffle_project/screens/profile_page.dart';
import 'package:raffle_project/screens/startingPage.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class NewItem extends StatelessWidget {
  NewItemColumn newItemColumn = NewItemColumn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Entrance page'),
        ),
        body: NewItemColumn());
  }
}

class NewItemColumn extends StatefulWidget {
  @override
  _NewItemColumnState createState() => _NewItemColumnState();
}

class _NewItemColumnState extends State<NewItemColumn> {
  var txtPrice = TextEditingController();
  var txtItemName = TextEditingController();

  addEntrance() async {
    String dateTime = DateFormat("dd/MM/yy hh:mm aa").format(DateTime.now());
    var map = new Map<String, dynamic>();
    map['ItemName'] = txtItemName.text;
    map['ItemPrice'] = txtPrice.text;
    map['CompanyEmail'] = _auth.currentUser!.email.toString();
    map['date'] = dateTime;
    await _firestore
        .collection('Company')
        .doc(_auth.currentUser!.email.toString())
        .collection('Products')
        .add(map);
  }

  // final picker = ImagePicker();
  // late File _image;
  // late PickedFile _pickedFile;

  // Future getImage(bool fromCamera) async {
  //   Navigator.pop(context);
  //   final image = await ImagePicker.platform.pickImage(
  //       source: !fromCamera ? ImageSource.gallery : ImageSource.camera);
  //   if (image != null) {
  //     setState(() {
  //       _image = File(image.path);
  //       _pickedFile = image;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () {

          },
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Icon(
              Icons.add,
              size: 72,
            ),
          ),
        ),
        Form(
            child: Column(
          children: [
            TextFormField(
              controller: txtItemName,
              decoration: kEnterDecoration.copyWith(hintText: 'Item Name'),
            ),
            TextFormField(
              controller: txtPrice,
              decoration: kEnterDecoration.copyWith(hintText: 'Item Price'),
            )
          ],
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RawMaterialButton(
            onPressed: () {
              addEntrance();
              txtItemName.clear();
              txtPrice.clear();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  ProfilePage(email: _auth.currentUser!.email.toString())), (Route<dynamic> route) => false);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Add new item',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
