import 'package:dio/dio.dart';
import '../models/estate.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 屋苑服务
class EstateService {
  final ApiClient _apiClient;

  EstateService(this._apiClient);

  /// 获取屋苑列表
  Future<EstateListResponse> getEstates({
    int? districtId,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    String? developer,
    double? minAvgPrice,
    double? maxAvgPrice,
    bool? isFeatured,
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

      if (districtId != null) queryParams['district_id'] = districtId;
      if (primarySchoolNet != null) queryParams['primary_school_net'] = primarySchoolNet;
      if (secondarySchoolNet != null) queryParams['secondary_school_net'] = secondarySchoolNet;
      if (developer != null) queryParams['developer'] = developer;
      if (minAvgPrice != null) queryParams['min_avg_price'] = minAvgPrice;
      if (maxAvgPrice != null) queryParams['max_avg_price'] = maxAvgPrice;
      if (isFeatured != null) queryParams['is_featured'] = isFeatured;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;

      final response = await _apiClient.get(
        ApiEndpoints.estates,
        queryParameters: queryParams,
      );

      // API 返回格式: {code, message, data: {data: [], total, page, page_size}}
      final data = response.data['data'];
      return EstateListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('获取屋苑列表失败: ${e.message}');
    }
  }

  /// 获取屋苑详情
  Future<Estate> getEstateDetail(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.estateDetail(id),
      );

      return Estate.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception('获取屋苑详情失败: ${e.message}');
    }
  }

  /// 获取屋苑统计数据
  Future<Map<String, dynamic>> getEstateStatistics(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.estateStatistics(id),
      );

      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('获取屋苑统计数据失败: ${e.message}');
    }
  }

  /// 获取屋苑成交记录
  Future<List<dynamic>> getEstateTransactions(int id, {int page = 1, int pageSize = 20}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.estateTransactions(id),
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      return response.data['data'] as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('获取屋苑成交记录失败: ${e.message}');
    }
  }

  /// 获取精选屋苑
  Future<List<Estate>> getFeaturedEstates() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.featuredEstates,
      );

      final data = response.data['data'] as List;
      return data.map((item) => Estate.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('获取精选屋苑失败: ${e.message}');
    }
  }
}
