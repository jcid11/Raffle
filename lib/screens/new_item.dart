import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:raffle_project/constant.dart';
import 'package:raffle_project/screens/profile_page.dart';


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
  File? image;


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

  Future pickImage(ImageSource source)async{
    try{
      final image = await ImagePicker().pickImage(source: source);
      if(image==null) return ;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;

      });
    }catch (e){
      throw Exception('exception error $e');
    }
  }
  Future uploadImageToFirebase(BuildContext context,String itemName,String itemPrice,String companyEmail) async {
    String dateTime = DateFormat("dd/MM/yy hh:mm aa").format(DateTime.now());
    var map = new Map<String, dynamic>();
    String fileName = basename(image!.path);
    var firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    var uploadTask = firebaseStorageRef.putFile(image!);
    var taskSnapshot = await uploadTask;
    taskSnapshot.ref.getDownloadURL().then(
          (value) async{
            map['ItemName'] = itemName;
            map['ItemPrice'] = itemPrice;
            map['CompanyEmail'] = companyEmail;
            map['date'] = dateTime;
            map['image'] = value;
            await _firestore
                .collection('Company')
                .doc(companyEmail)
                .collection('Products')
                .add(map);
          }
    );
  }

  Future testMethod()async{
    final ref = await FirebaseStorage.instance.ref().child('uploads/${image!.path}');
    var url = ref.getDownloadURL();
    print(url);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () {
            pickImage(ImageSource.gallery);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: image!=null?Image.file(image!,width: 160,height: 160,):Icon(
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


              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  ProfilePage(email: _auth.currentUser!.email.toString())), (Route<dynamic> route) => false);
              uploadImageToFirebase(context,txtItemName.text,txtPrice.text,_auth.currentUser!.email.toString());
              txtItemName.clear();
              txtPrice.clear();
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
