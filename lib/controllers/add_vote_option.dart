import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/add_vote_option.dart';

class CandidateController extends GetxController {
  CandidateModel fromDocumentSnapshot(DocumentSnapshot doc) {
    CandidateModel _candidate = CandidateModel();
    _candidate.name = doc['name'];
    _candidate.description = doc['description'];
    return _candidate;
  }
}
