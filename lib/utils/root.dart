import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart' show BuildContext, Widget;
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';
import '../screens/home_screen.dart';
import '../screens/login.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (c,snapshot){
          if (snapshot.hasData) {
            return  ElectChain();
          } else {
            return  Login();
          }
        }
    ); /* GetX(
      initState: (_) {
        Get.put(UserController());
      },
      builder: (_) {
        if (Get.find<UserController>().user.name != null) {
          return ElectChain();
        } else {
          return Login();
        }
      },
    );*/
  }
}
