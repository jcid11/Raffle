import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffle_project/service/user_model.dart';

class UserService {
  final _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  Future createUserOnFirebase({required String name, required String email,required String password,required int typeofaccount,required String identification,required int phoneNumber,required String category})async{
    if(checkIfUserIsLogged()){
      await _firestore.collection('user').doc(auth.currentUser!.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'typeOfAccount': typeofaccount,
        'identification': identification,
        'phoneNumber': phoneNumber,
        'category' : category
      });
    }
  }

  Future <UserServiceModel> getUserPersonalInfo()async{
    DocumentSnapshot documentSnapshot = await _firestore.collection('user').doc(getUserUid()).get();
    if(documentSnapshot.data()!=null){
      return UserServiceModel(name: documentSnapshot.get('name'));
    }else{
      return UserServiceModel(name: 'yup');
    }
  }

  Future <userServicePhoneModel> getUserPhone()async{
    DocumentSnapshot documentSnapshot = await _firestore.collection('user').doc(getUserUid()).get();
    if(documentSnapshot.data()!=null){
      return userServicePhoneModel(documentSnapshot.get('phoneNumber'));
    }else{
      return userServicePhoneModel(0);
    }
  }

  Future<int> getUserInfo()async{
    String userId=getUserUid();
    DocumentSnapshot documentSnapshot = await _firestore.collection('user').doc(userId).get();
    if(documentSnapshot.data()!=null){
      return documentSnapshot.get('typeOfAccount')??0;
    }
    return 0;
  }

  static String getUserUid() {
    if (checkIfUserIsLogged()) {
      return auth.currentUser!.uid;
    }
    return '';
  }

  static Future logOut() async {
    await auth.signOut();
  }

  static bool checkIfUserIsLogged(){
    return auth.currentUser!=null;
  }
}
