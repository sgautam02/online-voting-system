import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vote_secure/face_auth/register_face/register_face_view.dart';

class RegisterFace extends StatelessWidget {
  const RegisterFace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo[100],
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Image(
                      height: 80.0,
                      image: AssetImage('assets/icons/logo.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text('AUTHENTICATION | FACE REGISTRATION',
                      style: GoogleFonts.yanoneKaffeesatz(
                          fontSize: 30.0,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 10.0,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                GestureDetector(
                  onTap: ()=>Get.to(RegisterFaceView()),
                  child: CircleAvatar(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.account_circle,
                              size: 84.0,
                            ),
                          ),
                          Center(
                            child: Text("Add Image"),
                          )
                        ],
                      ),
                    ),
                    radius: 80.0,
                  ),
                )
              ],
            ),
          ),
        ));
    ;
  }
}
