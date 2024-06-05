import 'package:vote_secure/utils/root.dart';
import 'package:flutter/material.dart';
import 'bidings/auth_binding.dart';
import 'screens/screens.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,
      title: 'ElectChain',
      theme: ThemeData(
        textTheme:
            GoogleFonts.yanoneKaffeesatzTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Root(),
      initialRoute: '/',
      routes: {
        // 'auth': (context) => AuthScreen(),
        'settings': (context) => ElectChain(),
        'profile': (context) => ElectChain(),
        'create_vote': (context) => NewVote(),
      },
    );
  }
}
