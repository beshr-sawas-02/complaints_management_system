import 'package:dio/dio.dart';
import '../models/rating_model.dart';
import '../providers/rating_provider.dart';

class RatingRepository {
  final RatingProvider _provider = RatingProvider();

  Future<RatingsResponse> getRatings({
    String? search,
    String? complaintId,
    String? userId,
    int? rating,
    int? minRating,
    int? maxRating,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _provider.getRatings(
        search: search,
        complaintId: complaintId,
        userId: userId,
        rating: rating,
        minRating: minRating,
        maxRating: maxRating,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return RatingsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RatingModel> getRatingById(String id) async {
    try {
      final response = await _provider.getRatingById(id);
      return RatingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RatingModel?> getRatingByComplaint(String complaintId) async {
    try {
      final response = await _provider.getRatingByComplaint(complaintId);
      if (response.data == null) return null;
      return RatingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<double> getAverageRating(String complaintId) async {
    try {
      final response = await _provider.getAverageRating(complaintId);
      return (response.data as num?)?.toDouble() ?? 0.0;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> checkUserRated(String complaintId) async {
    try {
      final response = await _provider.checkUserRated(complaintId);
      return response.data ?? false;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RatingsResponse> getMyRatings({
    int? rating,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _provider.getMyRatings(
        rating: rating,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return RatingsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RatingsResponse> getRatingsWithFeedback({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    try {
      final response = await _provider.getRatingsWithFeedback(
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return RatingsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RatingModel> createRating(CreateRatingRequest request) async {
    try {
      final response = await _provider.createRating(request);
      return RatingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RatingModel> updateRating(String id, UpdateRatingRequest request) async {
    try {
      final response = await _provider.updateRating(id, request);
      return RatingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> deleteRating(String id) async {
    try {
      final response = await _provider.deleteRating(id);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RatingStatistics> getStatistics() async {
    try {
      final response = await _provider.getStatistics();
      return RatingStatistics.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}