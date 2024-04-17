import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../controllers/election_controller.dart';
import '../controllers/user_controller.dart';
import '../models/election_model.dart';
import '../models/user.dart';
import '../screens/add_candidate.dart';

class DataBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uid = Get.find<UserController>().user.id;
  List<UserModel> allUsers =[];
  List<ElectionModel> allElections = [];
  ElectionModel indexedElection = ElectionModel();
  ElectionController electionController = Get.put(ElectionController());

  Future<bool> createNewUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        "name": user.name,
        "phonenumber": user.phoneNumber,
        "email": user.email,
        "owned_elections": [],
        "avatar": user.avatar
      });
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return Get.find<UserController>().fromDocumentSnapshot(doc);
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future createElection(ElectionModel election) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('elections')
          .add({
        'options': [],
        'name': election.name,
        'description': election.description,
        'startDate': election.startDate,
        'endDate': election.endDate,
        'accessCode': election.accessCode,
        'voted': [],
        'owner': election.owner
      }).then((reference) {
        _firestore.collection('users').doc(_uid).update({
          "owned_elections": FieldValue.arrayUnion([reference.id])
        });

        Get.to(AddCandidate(), arguments: [reference, election]);
      });

    } catch (err) {
      print('The error of election creation is $err');
    }
  }

  Future<bool> addCandidate(_electionId, _candidateImgUrl, _candidateName,
      _candidateDescription) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('elections')
          .doc(_electionId)
          .update({
        "options": FieldValue.arrayUnion([
          {
            'avatar': _candidateImgUrl,
            'name': _candidateName,
            'description': _candidateDescription,
            'count': 1
          }
        ])
      });
      return true;
    } catch (err) {
      print(err.toString());
      Get.snackbar('ERROR',
          'Unexpected error occured while adding the candidate, Please try again');
      return false;
    }
  }

  Future<DocumentSnapshot> candidatesStream(
      String _uid, String _electionId) async {
    var data = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('elections')
        .doc(_electionId)
        .get();
    return data;
  }

  Future<ElectionModel> getElection(String _uid, String _electionID) async {
    var data = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('elections')
        .doc(_electionID)
        .get();
    return Get.find<ElectionController>().fromDocumentSnapshot(data);
  }

  // Future<ElectionModel> getElectionByAccessCode(String _electionID) async {
  //   return indexedElection;
  // }

  Stream<ElectionModel> getElections(userID) {
    var snaps;
    _firestore.collection("users").doc(userID).snapshots().map((user) {
      snaps = user['owned_elections'].map((electionOwned) {
        return _firestore
            .collection("users")
            .doc(userID)
            .collection("elections")
            .doc(electionOwned)
            .snapshots();
      });
      print(snaps);
    });
    print("Snaaaaaaaaaps oooooooh $snaps");
    return snaps;
  }
}
