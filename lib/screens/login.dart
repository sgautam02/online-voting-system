import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../controllers/auth_controller.dart';
import '../widgets/input_field.dart';
import 'auth.dart';
import 'face/face_detector_view.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Image(
                    image: AssetImage('assets/icons/logo.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text('AUTHENTICATION | LOG IN IN',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 30.0,
              ),
              InputField(
                controller: _emailController,
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                type: TextInputType.emailAddress,
                obscure: false,
              ),
              InputField(
                controller: _passwordController,
                hintText: 'Enter your password',
                prefixIcon: Icons.lock,
                type: TextInputType.text,
                obscure: true,
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.find<AuthController>().loginUser(
                          _emailController.text, _passwordController.text);
                    },
                    label: Text('SIGN IN'),
                    icon: Icon(Icons.verified_user),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                onPressed: () => Get.to(AuthScreen()),
                child: Text(
                  'Dont have an account ? Sign up there',
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(()=>FaceDetectorView());
                    },
                    label: Text('Detect Face'),
                    icon: Icon(Icons.verified_user),
                  ),
                ),
              ),
            ]
        ),
      )),
    );
  }
}
