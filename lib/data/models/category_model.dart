import 'user_model.dart';

class CategoryModel {
  final String? id;
  final String complaintItem;
  final String description;
  final DateTime? createdAt;

  CategoryModel({
    this.id,
    required this.complaintItem,
    required this.description,
    this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? json['id'],
      complaintItem: json['complaintItem'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'complaintItem': complaintItem,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  CategoryModel copyWith({
    String? id,
    String? complaintItem,
    String? description,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      complaintItem: complaintItem ?? this.complaintItem,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CategoriesResponse {
  final List<CategoryModel> categories;
  final PaginationModel pagination;

  CategoriesResponse({
    required this.categories,
    required this.pagination,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e))
          .toList() ?? [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class CategoryStatistics {
  final int totalCategories;

  CategoryStatistics({required this.totalCategories});

  factory CategoryStatistics.fromJson(Map<String, dynamic> json) {
    return CategoryStatistics(
      totalCategories: json['totalCategories'] ?? 0,
    );
  }
}

class CreateCategoryRequest {
  final String complaintItem;
  final String description;

  CreateCategoryRequest({
    required this.complaintItem,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'complaintItem': complaintItem,
      'description': description,
    };
  }
}

class UpdateCategoryRequest {
  final String? complaintItem;
  final String? description;

  UpdateCategoryRequest({
    this.complaintItem,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (complaintItem != null) data['complaintItem'] = complaintItem;
    if (description != null) data['description'] = description;
    return data;
  }
}