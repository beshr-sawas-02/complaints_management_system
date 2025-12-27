import 'package:get/get.dart';
import '../data/providers/api_client.dart';
import '../controllers/auth_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize API Client
    ApiClient().init();

    // Auth Controller - permanent
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}