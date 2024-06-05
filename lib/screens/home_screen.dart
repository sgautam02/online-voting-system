import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:vote_secure/face_auth/auth_face/authenticate_face_view.dart';
import 'package:vote_secure/screens/add_candidate.dart';
import 'package:vote_secure/screens/user_elections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/styles.dart';
import '../controllers/election_controller.dart';
import '../controllers/user_controller.dart';
import '../models/election_model.dart';
import '../models/user.dart';
import '../widgets/action_box.dart';
import '../widgets/drawer.dart';
import 'cast_vote.dart';
import 'create_vote.dart';

class ElectChain extends StatefulWidget {
  @override
  _ElectChainState createState() => _ElectChainState();
}

class _ElectChainState extends State<ElectChain> {
  final GlobalKey _scafflofKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      key: _scafflofKey,
      appBar: AppBar(
        //  leading: IconButton(
        //   icon: Icon(Icons.dashboard),
        //  onPressed: () {
        //     Scaffold.of(context).openDrawer();
        // }),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.indigo, Colors.blue])),
        ),
        elevation: 0.0,
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'ELECT',
                style: GoogleFonts.gugi(
                    color: Colors.pink[300],
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
            TextSpan(
                text: 'CHAIN',
                style: GoogleFonts.gugi(
                    fontSize: 18.0, fontWeight: FontWeight.bold))
          ]),
        ),
        actions: [
          // ignore: missing_required_param

          IconButton(
              color: Colors.white,
              icon: Icon(Icons.how_to_vote_rounded),
              onPressed: () {
              }),
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: IconButton(
                color: Colors.white,
                icon: Icon(Icons.info_outline_rounded),
                onPressed: () {
                  showAboutDialog(
                      context: context,
                      applicationVersion: '^1.0.0',
                      applicationIcon: CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('assets/icons/icon.png'),
                      ),
                      applicationName: 'ElectChain',
                      applicationLegalese: 'SignumCode IT Solutions');
                }),
          ),
        ],
      ),
      body: HomeScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(NewVote()),
        child: Container(
          decoration: BoxStyles.gradientBox,
          child: IconButton(
              icon: Icon(Icons.how_to_vote_rounded),
              onPressed: (){} /*=> Get.to(AuthenticateFaceView())*/
          ),
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _electionAccessCodeController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var electionController = Get.put(ElectionController());
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(height: 30.0),
            Text(
              "ENTER A ELECTION CODE",
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: 50.0,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(18.0)),
                    child: Form(
                      key: GlobalKey<FormState>(),
                      child: TextFormField(
                        controller: _electionAccessCodeController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          hintText: "Enter the election code",
                          hintStyle: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.normal),
                          prefixIcon: Icon(
                            Icons.lock,
                          ),
                        ),
                      ),
                    )),
                GestureDetector(
                  onTap: () async {
                    FirebaseFirestore _firestore = FirebaseFirestore.instance;
                    List<UserModel> allUsers = [];
                    List<ElectionModel> allElections = [];
                    var usersQuerySnap = _firestore.collection("users").get();
                    usersQuerySnap.then((usersQuery) {
                      var _allUsers = usersQuery.docs
                          .map((_user) => Get.find<UserController>()
                              .fromDocumentSnapshot(_user))
                          .toList();

                      _allUsers.forEach((user) {
                        print(user.email);
                        _firestore
                            .collection("users")
                            .doc(user.id)
                            .collection("elections")
                            .get()
                            .then((_userElectionsSnap) {
                          var userElections = _userElectionsSnap.docs
                              .map((_election) => electionController
                                  .fromDocumentSnapshot(_election))
                              .toList();
                          userElections.forEach((element) {
                            allElections.add(element);
                          });
                          allElections.forEach((election) {
                            if (election.accessCode ==
                                _electionAccessCodeController.text) {
                              print("Election found ${election.accessCode}");
                              Get.to(CastVote(), arguments: election);
                            } else {
                              print(
                                  'election not found ${election.accessCode}');
                            }
                          });
                        });
                      });
                      //print("All elections $allElections");
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.indigo, Colors.blue])),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          Text(
                            "Validate",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          )
                        ],
                      ).paddingSymmetric(horizontal: 10)),
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            FutureBuilder(
                future: firestore
                    .collection('users')
                    .doc(auth.currentUser!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var userData = snapshot.data!.data();
                    return userData!['role'] == 'ADMIN'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(NewVote());
                                },
                                child: ActionBox(
                                  action: "Create Election",
                                  description: "Create a new vote",
                                  image: Icons.how_to_vote,
                                ),
                              ),
                              InkWell(
                                onTap: () => Get.to(UserElections()),
                                child: ActionBox(
                                  action: "My Elections",
                                  description: "Create a new vote",
                                  image: Icons.ballot,
                                ),
                              ),
                            ],
                          )
                        : Container();
                  }
                })
          ],
        ),
      ),
    );
  }
}
