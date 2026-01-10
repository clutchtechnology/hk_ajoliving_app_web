import 'package:dio/dio.dart';
import '../models/furniture.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 家具服务
class FurnitureService {
  final ApiClient _apiClient;

  FurnitureService(this._apiClient);

  /// 获取家具列表
  Future<FurnitureListResponse> getFurniture({
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? brand,
    String? condition,
    int? deliveryDistrictId,
    String? deliveryMethod,
    String? status,
    String? keyword,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };

      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (minPrice != null) queryParams['min_price'] = minPrice;
      if (maxPrice != null) queryParams['max_price'] = maxPrice;
      if (brand != null) queryParams['brand'] = brand;
      if (condition != null) queryParams['condition'] = condition;
      if (deliveryDistrictId != null) queryParams['delivery_district_id'] = deliveryDistrictId;
      if (deliveryMethod != null) queryParams['delivery_method'] = deliveryMethod;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;

      final response = await _apiClient.get(
        ApiEndpoints.furniture,
        queryParameters: queryParams,
      );

      // API 返回格式: {code, message, data: {data: [], total, page, page_size}}
      final data = response.data['data'];
      return FurnitureListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('获取家具列表失败: ${e.message}');
    }
  }

  /// 获取家具分类
  Future<List<FurnitureCategory>> getFurnitureCategories() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.furnitureCategories,
      );

      final data = response.data['data'] as List;
      return data.map((item) => FurnitureCategory.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('获取家具分类失败: ${e.message}');
    }
  }

  /// 获取家具详情
  Future<Furniture> getFurnitureDetail(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.furnitureDetail(id),
      );

      return Furniture.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception('获取家具详情失败: ${e.message}');
    }
  }

  /// 获取家具图片
  Future<List<FurnitureImage>> getFurnitureImages(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.furnitureImages(id),
      );

      final data = response.data['data'] as List;
      return data.map((item) => FurnitureImage.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('获取家具图片失败: ${e.message}');
    }
  }

  /// 获取精选家具
  Future<List<Furniture>> getFeaturedFurniture() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.featuredFurniture,
      );

      final data = response.data['data'] as List;
      return data.map((item) => Furniture.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('获取精选家具失败: ${e.message}');
    }
  }
}
