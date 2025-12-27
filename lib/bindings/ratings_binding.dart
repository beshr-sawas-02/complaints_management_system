import 'package:get/get.dart';
import '../controllers/ratings_controller.dart';

class RatingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingsController>(() => RatingsController());
  }
}