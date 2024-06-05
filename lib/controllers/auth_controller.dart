
import 'package:vote_secure/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import '../services/database.dart';
import '../utils/root.dart';


class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User>? _firebaseUser ;
  var usercontroller = Get.put(UserController());

  String? get user => _firebaseUser?.value.email;

  @override
  // ignore: must_call_supe

  Future<void> createUser(imgURL, name, phoneNumber, email, password,image,faceFeature) async {
    try {
      var _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      UserModel _user = UserModel(
          id: _authResult.user!.uid,
          avatar: imgURL,
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          image: image,
        faceFeatures: faceFeature
      );
      if (await DataBase().createNewUser(_user)) {
        Get.find<UserController>().user = _user;
        Get.to(Root());
      }
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      var _authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      Get.find<UserController>().user =
          await DataBase().getUser(_authResult.user!.uid);
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }

  void signOut() {
    try {
      _auth.signOut();
      Get.find<UserController>().clear();
    } catch (err) {
      Get.snackbar('Processing Error', err.toString());
    }
  }
}
