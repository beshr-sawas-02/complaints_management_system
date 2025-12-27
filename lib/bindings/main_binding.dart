import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/complaints_controller.dart';
import '../controllers/users_controller.dart';
import '../controllers/categories_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // MainController should be permanent since it controls navigation
    Get.put<MainController>(MainController(), permanent: true);
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ComplaintsController>(() => ComplaintsController());
    Get.lazyPut<UsersController>(() => UsersController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
  }
}