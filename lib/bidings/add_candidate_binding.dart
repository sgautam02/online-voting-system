import 'package:get/get.dart';
import 'package:vote_secure/controllers/user_controller.dart';

import '../controllers/election_controller.dart';
import '../services/database.dart';


class AddCandidateBinding extends Bindings {
  @override
  void dependencies() {
    getData() async {
      var data;
      await DataBase()
          .candidatesStream(Get.find<UserController>().user.id!,
              Get.arguments[0].id.toString())
          .then((election) {
        data = election['options'];
        Get.find<ElectionController>().currentElection.options = data;
      });
    }
  }
}
