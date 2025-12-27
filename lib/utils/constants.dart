class Constants {
  Constants._();

  // App Info
  static const String appName = 'لوحة تحكم الشكاوى';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://complaints-app-swart.vercel.app';
  static const String uploadsUrl = 'https://complaints-app-swart.vercel.app/uploads';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Storage Keys
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String isFirstTimeKey = 'is_first_time';
  static const String rememberMeKey = 'remember_me';

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String displayDateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Image Configuration
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  static const int maxImagesPerComplaint = 5;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int phoneLength = 10;
  static const int rationalIdLength = 12;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Debounce Duration
  static const Duration debounceDuration = Duration(milliseconds: 500);

  // Refresh Intervals
  static const Duration refreshInterval = Duration(minutes: 5);
  static const Duration notificationRefreshInterval = Duration(minutes: 1);
}

class ApiEndpoints {
  ApiEndpoints._();

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/auth/me';

  // Users Endpoints
  static const String users = '/users';
  static const String userStatistics = '/users/statistics';
  static const String currentUser = '/users/me';
  static const String updateCurrentUser = '/users/me/update';
  static const String uploadProfileImage = '/users/me/upload-image';
  static const String deleteProfileImage = '/users/me/profile-image';
  static const String changePassword = '/users/me/change-password';

  static String userById(String id) => '/users/$id';

  static String userByRationalId(String rationalId) =>
      '/users/rational/$rationalId';

  static String toggleUserActive(String id) => '/users/$id/toggle-active';

  static String hardDeleteUser(String id) => '/users/$id/hard';

  static String uploadUserImage(String id) => '/users/$id/upload-image';

  // Complaints Endpoints
  static const String complaints = '/complaints';
  static const String complaintsStatistics = '/complaints/statistics';
  static const String myComplaints = '/complaints/my-complaints';

  static String complaintById(String id) => '/complaints/$id';

  static String updateComplaintStatus(String id) => '/complaints/$id/status';

  static String assignComplaint(String id) => '/complaints/$id/assign';

  static String uploadComplaintImages(String id) =>
      '/complaints/$id/upload-images';

  static String deleteComplaintImage(String id, String filename) =>
      '/complaints/$id/images/$filename';

  static String markComplaintAsRead(String id) => '/complaints/$id/mark-read';

  // Complaint Categories Endpoints
  static const String categories = '/complaint-categories';
  static const String categoriesList = '/complaint-categories/list';
  static const String categoriesStatistics = '/complaint-categories/statistics';

  static String categoryById(String id) => '/complaint-categories/$id';

  static String categoryByName(String name) =>
      '/complaint-categories/name/$name';

  static String categoryExists(String name) =>
      '/complaint-categories/exists/$name';
  static const String bulkCategories = '/complaint-categories/bulk';

  // Complaint Logs Endpoints
  static const String complaintLogs = '/complaint-logs';
  static const String logsStatistics = '/complaint-logs/statistics';

  static String logById(String id) => '/complaint-logs/$id';

  static String logsByComplaint(String complaintId) =>
      '/complaint-logs/complaint/$complaintId';

  static String logsTimeline(String complaintId) =>
      '/complaint-logs/timeline/$complaintId';

  static String logsByUser(String userId) => '/complaint-logs/user/$userId';

  static String deleteLogsByComplaint(String complaintId) =>
      '/complaint-logs/complaint/$complaintId';

  // Notifications Endpoints
  static const String notifications = '/notifications';
  static const String notificationsStatistics = '/notifications/statistics';
  static const String myNotifications = '/notifications/my-notifications';
  static const String recentNotifications = '/notifications/recent';

  static String notificationById(String id) => '/notifications/$id';

  static String notificationsByComplaint(String complaintId) =>
      '/notifications/complaint/$complaintId';

  static String notificationsByAssigned(String userId) =>
      '/notifications/assigned/$userId';

  static String deleteNotificationsByComplaint(String complaintId) =>
      '/notifications/complaint/$complaintId';

  // Ratings Endpoints
  static const String ratings = '/ratings';
  static const String ratingsStatistics = '/ratings/statistics';
  static const String ratingsWithFeedback = '/ratings/with-feedback';
  static const String myRatings = '/ratings/my-ratings';

  static String ratingById(String id) => '/ratings/$id';

  static String ratingByComplaint(String complaintId) =>
      '/ratings/complaint/$complaintId';

  static String averageRating(String complaintId) =>
      '/ratings/average/$complaintId';

  static String checkRated(String complaintId) => '/ratings/check/$complaintId';
}
