import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserController extends GetxController {
  Rx<UserModel> _userModel = UserModel().obs;

  User ? currentUser = FirebaseAuth.instance.currentUser;

  UserModel get user => _userModel.value;

  set user(UserModel value) => this._userModel.value = value;

  void clear() {
    _userModel.value = UserModel();
  }

  @override
  onInit() async {
    super.onInit();
    // _userModel.value = await getUCurrentUser();
  }

  Future<UserModel> getUCurrentUser() async {
    var userdata = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserModel user = fromDocumentSnapshot(userdata);
    return user;
  }

  UserModel fromDocumentSnapshot(DocumentSnapshot doc) {
    UserModel _user = UserModel();
    _user.id = doc.id;
    _user.email = doc['email'];
    _user.name = doc['name'];
    _user.phoneNumber = doc['phoneNumber'];
    _user.ownedElections = doc['owned_elections'];
    _user.avatar = doc['avatar'];
    return _user;
  }
}
