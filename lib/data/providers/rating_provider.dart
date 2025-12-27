import 'package:dio/dio.dart';
import '../../utils/constants.dart';
import '../models/rating_model.dart';
import 'api_client.dart';

class RatingProvider {
  final ApiClient _apiClient = ApiClient();

  // Get all ratings with pagination and filters
  Future<Response> getRatings({
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
    return await _apiClient.get(
      ApiEndpoints.ratings,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (complaintId != null) 'complaintId': complaintId,
        if (userId != null) 'userId': userId,
        if (rating != null) 'rating': rating,
        if (minRating != null) 'minRating': minRating,
        if (maxRating != null) 'maxRating': maxRating,
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Get rating by ID
  Future<Response> getRatingById(String id) async {
    return await _apiClient.get(ApiEndpoints.ratingById(id));
  }

  // Get rating by complaint
  Future<Response> getRatingByComplaint(String complaintId) async {
    return await _apiClient.get(ApiEndpoints.ratingByComplaint(complaintId));
  }

  // Get average rating by complaint
  Future<Response> getAverageRating(String complaintId) async {
    return await _apiClient.get(ApiEndpoints.averageRating(complaintId));
  }

  // Check if user rated complaint
  Future<Response> checkUserRated(String complaintId) async {
    return await _apiClient.get(ApiEndpoints.checkRated(complaintId));
  }

  // Get my ratings
  Future<Response> getMyRatings({
    int? rating,
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    return await _apiClient.get(
      ApiEndpoints.myRatings,
      queryParameters: {
        if (rating != null) 'rating': rating,
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Get ratings with feedback
  Future<Response> getRatingsWithFeedback({
    int page = 1,
    int limit = 10,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
  }) async {
    return await _apiClient.get(
      ApiEndpoints.ratingsWithFeedback,
      queryParameters: {
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // Create rating
  Future<Response> createRating(CreateRatingRequest request) async {
    return await _apiClient.post(
      ApiEndpoints.ratings,
      data: request.toJson(),
    );
  }

  // Update rating
  Future<Response> updateRating(String id, UpdateRatingRequest request) async {
    return await _apiClient.patch(
      ApiEndpoints.ratingById(id),
      data: request.toJson(),
    );
  }

  // Delete rating
  Future<Response> deleteRating(String id) async {
    return await _apiClient.delete(ApiEndpoints.ratingById(id));
  }

  // Get statistics
  Future<Response> getStatistics() async {
    return await _apiClient.get(ApiEndpoints.ratingsStatistics);
  }
}