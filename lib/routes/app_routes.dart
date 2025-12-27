import 'package:get/get.dart';
import '../views/splash/splash_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/main/main_view.dart';
import '../views/dashboard/dashboard_view.dart';
import '../views/complaints/complaints_view.dart';
import '../views/complaints/complaint_details_view.dart';
import '../views/users/users_view.dart';
import '../views/users/user_details_view.dart';
import '../views/users/user_form_view.dart';
import '../views/categories/categories_view.dart';
import '../views/categories/category_form_view.dart';
import '../views/ratings/ratings_view.dart';
import '../views/profile/profile_view.dart';
import '../views/profile/edit_profile_view.dart';
import '../views/settings/settings_view.dart';
import '../bindings/auth_binding.dart';
import '../bindings/main_binding.dart';
import '../bindings/dashboard_binding.dart';
import '../bindings/complaints_binding.dart';
import '../bindings/users_binding.dart';
import '../bindings/categories_binding.dart';
import '../bindings/ratings_binding.dart';

class AppRoutes {
  AppRoutes._();

  // Route Names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String dashboard = '/dashboard';
  static const String complaints = '/complaints';
  static const String complaintDetails = '/complaints/details';
  static const String users = '/users';
  static const String userDetails = '/users/details';
  static const String userForm = '/users/form';
  static const String categories = '/categories';
  static const String categoryForm = '/categories/form';
  static const String ratings = '/ratings';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';

  // Routes List
  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: main,
      page: () => const MainView(),
      binding: MainBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: complaints,
      page: () => const ComplaintsView(),
      binding: ComplaintsBinding(),
    ),
    GetPage(
      name: complaintDetails,
      page: () => const ComplaintDetailsView(),
      binding: ComplaintsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: users,
      page: () => const UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: userDetails,
      page: () => const UserDetailsView(),
      binding: UsersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: userForm,
      page: () => const UserFormView(),
      binding: UsersBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: categories,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: categoryForm,
      page: () => const CategoryFormView(),
      binding: CategoriesBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: ratings,
      page: () => const RatingsView(),
      binding: RatingsBinding(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    // GetPage(
    //   name: settings,
    //   page: () => const SettingsView(),
    //   transition: Transition.rightToLeft,
    // ),
  ];
}