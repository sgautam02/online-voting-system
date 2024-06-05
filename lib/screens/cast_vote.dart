import 'package:vote_secure/screens/realtime_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/election_controller.dart';
import '../controllers/user_controller.dart';
import '../models/election_model.dart';

class CastVote extends StatefulWidget {
  @override
  _CastVoteState createState() => _CastVoteState();
}

class _CastVoteState extends State<CastVote> {
  @override
  Widget build(BuildContext context) {

    ElectionModel electionModel = Get.arguments;
    List options = electionModel.options!;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            "CAST YOUR VOTE",
            style: GoogleFonts.yanoneKaffeesatz(
                fontSize: 25.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () => print("Display something")),
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () => print("Display something")),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/logo.png'),
                height: 80.0,
                width: 300.0,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Divider(),
        ),
        SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
                child: Center(
              child: Text(
                Get.arguments.name.toString().toUpperCase(),
                style: GoogleFonts.yanoneKaffeesatz(
                    fontSize: 28.0,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold),
              ),
            ))),
        SliverToBoxAdapter(
            child: Center(
          child: Text(
            Get.arguments.description.toString(),
            style: GoogleFonts.yanoneKaffeesatz(
                fontSize: 20.0,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
        )),
        SliverToBoxAdapter(
          child: SizedBox(height: 40.0),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Container(
                      height: 70.0,
                      margin: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          gradient: LinearGradient(
                            end: Alignment.bottomRight,
                            colors: [Colors.indigo[200]!, Colors.blue[200]!],
                          )),
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                              !options[index]["avatar"]
                                      .toString()
                                      .startsWith('http')
                                  ? 'https://ps.w.org/user-avatar-reloaded/assets/icon-256x256.png'
                                  : options[index]["avatar"],
                            )),
                        trailing: Text(
                          "${options[index]["count"].toString()} Votes",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        title: Text(
                            options[index]["name"].toString().toUpperCase()),
                        subtitle: Text(options[index]["description"]),
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: ListTile(
                                leading: Icon(
                                  Icons.warning,
                                  size: 36.0,
                                  color: Colors.yellow,
                                ),
                                title: Text("CONFIRM YOUR CHOICE PLEASE"),
                                subtitle: Text(
                                    "Notice that you cannot change after confirmation"),
                              ),
                              content: Container(
                                // height: 230.0,
                                // width: 250.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.indigo[300]!,
                                          Colors.blue
                                        ])),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                          ),
                                          child: CircleAvatar(
                                              radius: 60.0,
                                              backgroundImage: NetworkImage(
                                                  !options[index]["avatar"]
                                                          .toString()
                                                          .startsWith('http')
                                                      ? 'https://ps.w.org/user-avatar-reloaded/assets/icon-256x256.png'
                                                      : options[index]
                                                          ["avatar"])),
                                        ),
                                      ),
                                      SizedBox(height: 15.0),
                                      Text(options[index]["name"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 5.0),
                                      Text(
                                        options[index]["description"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        "${options[index]["count"].toString()} VOTES COUNT",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      FirebaseFirestore _firestore =
                                          FirebaseFirestore.instance;
                                      var currentElection=

                                      _firestore
                                          .collection('users')
                                          .doc(electionModel.owner)
                                          .collection('elections')
                                          .doc(electionModel.id)
                                          .get()
                                          .then((DocumentSnapshot document) {

                                        if(document.exists){
                                          var voted = List.from(document['voted']);
                                          if(!voted.contains(Get.find<UserController>().user!.id)){
                                            if(document['accessCode'] == electionModel.accessCode){
                                              var options = List.from(document['options']);
                                              if (options != null && options.length > index){
                                                var currentCount = options[index]['count'];
                                                options[index]['count'] = currentCount + 1;
                                              }
                                              _firestore
                                                  .collection("users")
                                                  .doc(electionModel.owner)
                                                  .collection("elections")
                                                  .doc(electionModel.id)
                                                  .update({
                                                "options":options,
                                                'voted':FieldValue.arrayUnion([Get.find<UserController>().user.id])

                                              }).then((value) {
                                                Get.off(RealtimeResult(),
                                                    arguments: {
                                                      'owner_uid':electionModel.owner,
                                                      'election_id':electionModel.id
                                                    });
                                              });
                                            }
                                          }else{
                                            Get.back();
                                            Get.snackbar(
                                                'Election', 'Already voted'
                                            );
                                          }
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.how_to_vote),
                                    label: Text("Confirm"))
                              ],
                            ),
                            barrierDismissible: true,
                            arguments: Get.arguments,
                          );
                        },
                      )));
            },
            childCount: options.length,
          ),
        ),
      ],
    ));
  }
}
