import 'package:vote_secure/screens/vote_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../bidings/vote_dashboard_binding.dart';
import '../controllers/user_controller.dart';
import '../widgets/candidate_box.dart';
import 'add_vote_option_screen.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AddCandidate extends StatefulWidget {
  @override
  _AddCandidateState createState() => _AddCandidateState();
}

class _AddCandidateState extends State<AddCandidate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD VOTE OPTIONS',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.yanoneKaffeesatz(
                fontSize: 30.0,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: Image(
                      height: 80.0,
                      image: AssetImage('assets/icons/logo.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                        'VOTE ${Get.arguments[1].name.toString().toUpperCase()}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.yanoneKaffeesatz(
                            fontSize: 30.0,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                  child: Divider(),
                ),
              ],
            ),
            StreamBuilder(
              stream: _firestore
                  .collection("users")
                  .doc(Get.find<UserController>().currentUser!.uid)
                  .collection("elections")
                  .doc(Get.arguments[0].id.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data?['options'];
                  return data.length < 1
                      ? Column(children: [
                        Icon(
                          Icons.wifi_off,
                          size: 100.0,
                        ),
                        Text('NO CANDIDATE ADDED YET',
                            style: TextStyle(
                              fontSize: 20.0,
                            )),
                        Text(
                          'Add candidates or options to your vote to finalise the process',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ])
                      : Container(
                    height: 400,
                        child: GridView.count(
                                            crossAxisCount: 2, // Adjust 200 according to your needs
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 10.0,
                                            childAspectRatio: 1.0,
                                            children: List.generate(data.length, (index) {
                        return CandidateBox(
                          candidateImgURL: data[index]['avatar'],
                          candidateName: data[index]['name'],
                          candidateDesc: data[index]['description'],
                          onTap: () {},
                        );
                                            }),
                                          ),
                      );


                } else {
                  return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 45.0, right: 75.0, top: 40.0, bottom: 20.0),
              child: GestureDetector(
                onTap:  () {
                  Get.to(VoteDashboard(),
                      arguments: Get.arguments,
                      binding: VoteDashboardBinding());
                },
                child: Container(
                  height: 50.0,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check, color: Colors.white),
                        Text(
                          'Run Election',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
         ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Candidates',
        backgroundColor: Colors.green,
        onPressed: () {
          Get.to(AddVoteOptionWidget(), arguments: Get.arguments);
        },
        child: Icon(
          Icons.group_add,
        ),
      ),
    );
  }
}
