import 'package:get/get.dart';
import '../data/models/complaint_model.dart';
import '../data/models/user_model.dart';
import '../data/models/category_model.dart';
import '../data/models/rating_model.dart';
import '../data/repositories/complaint_repository.dart';
import '../data/repositories/user_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/rating_repository.dart';
import '../utils/helpers.dart';

class DashboardController extends GetxController {
  final ComplaintRepository _complaintRepo = ComplaintRepository();
  final UserRepository _userRepo = UserRepository();
  final CategoryRepository _categoryRepo = CategoryRepository();
  final RatingRepository _ratingRepo = RatingRepository();

  // Statistics
  final Rx<ComplaintStatistics?> complaintStats = Rx<ComplaintStatistics?>(null);
  final Rx<UserStatistics?> userStats = Rx<UserStatistics?>(null);
  final Rx<CategoryStatistics?> categoryStats = Rx<CategoryStatistics?>(null);
  final Rx<RatingStatistics?> ratingStats = Rx<RatingStatistics?>(null);

  // Recent Data
  final RxList<ComplaintModel> recentComplaints = <ComplaintModel>[].obs;

  // Loading States
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        _loadComplaintStatistics(),
        _loadUserStatistics(),
        _loadCategoryStatistics(),
        _loadRatingStatistics(),
        _loadRecentComplaints(),
      ]);
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ في تحميل البيانات');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    try {
      isRefreshing.value = true;
      await loadDashboardData();
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<void> _loadComplaintStatistics() async {
    try {
      complaintStats.value = await _complaintRepo.getStatistics();
    } catch (e) {
      print('Error loading complaint stats: $e');
    }
  }

  Future<void> _loadUserStatistics() async {
    try {
      userStats.value = await _userRepo.getStatistics();
    } catch (e) {
      print('Error loading user stats: $e');
    }
  }

  Future<void> _loadCategoryStatistics() async {
    try {
      categoryStats.value = await _categoryRepo.getStatistics();
    } catch (e) {
      print('Error loading category stats: $e');
    }
  }

  Future<void> _loadRatingStatistics() async {
    try {
      ratingStats.value = await _ratingRepo.getStatistics();
    } catch (e) {
      print('Error loading rating stats: $e');
    }
  }

  Future<void> _loadRecentComplaints() async {
    try {
      final response = await _complaintRepo.getComplaints(
        limit: 5,
        sortBy: 'createdAt',
        sortOrder: 'desc',
      );
      recentComplaints.value = response.complaints;
    } catch (e) {
      print('Error loading recent complaints: $e');
    }
  }

  // Getters for dashboard statistics
  int get totalComplaints => complaintStats.value?.totalComplaints ?? 0;
  int get pendingComplaints => complaintStats.value?.pendingCount ?? 0;
  int get inProgressComplaints => complaintStats.value?.inProgressCount ?? 0;
  int get resolvedComplaints => complaintStats.value?.resolvedCount ?? 0;
  int get closedComplaints => complaintStats.value?.closedCount ?? 0;
  int get unreadComplaints => complaintStats.value?.unreadCount ?? 0;

  int get totalUsers => userStats.value?.totalUsers ?? 0;
  int get activeUsers => userStats.value?.activeUsers ?? 0;
  int get citizensCount => userStats.value?.citizensCount ?? 0;
  int get adminsCount => userStats.value?.adminsCount ?? 0;

  int get totalCategories => categoryStats.value?.totalCategories ?? 0;

  int get totalRatings => ratingStats.value?.totalRatings ?? 0;
  double get averageRating => ratingStats.value?.averageRating ?? 0.0;

  // Chart data
  List<Map<String, dynamic>> get complaintStatusData {
    return [
      {'status': 'قيد الانتظار', 'count': pendingComplaints, 'color': 0xFFF59E0B},
      {'status': 'قيد المعالجة', 'count': inProgressComplaints, 'color': 0xFF3B82F6},
      {'status': 'تم الحل', 'count': resolvedComplaints, 'color': 0xFF10B981},
      {'status': 'مغلقة', 'count': closedComplaints, 'color': 0xFF6B7280},
    ];
  }
}