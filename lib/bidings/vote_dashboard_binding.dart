import 'package:get/get.dart';

import '../controllers/election_controller.dart';

class VoteDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ElectionController>(() => ElectionController());
  }
}
