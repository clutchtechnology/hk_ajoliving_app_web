import 'package:dio/dio.dart';
import '../models/agency.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 代理公司服务
class AgencyService {
  final ApiClient _apiClient;

  AgencyService(this._apiClient);

  /// 获取代理公司列表
  Future<AgencyListResponse> getAgencies({
    int? districtId,
    double? minRating,
    bool? isVerified,
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
      if (minRating != null) queryParams['min_rating'] = minRating;
      if (isVerified != null) queryParams['is_verified'] = isVerified;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;

      final response = await _apiClient.get(
        ApiEndpoints.agencies,
        queryParameters: queryParams,
      );

      // API 返回格式: {code, message, data: {agencies: [], total, page, page_size}}
      final data = response.data['data'];
      return AgencyListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('获取代理公司列表失败: ${e.message}');
    }
  }

  /// 获取代理公司详情
  Future<Agency> getAgencyDetail(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.agencyDetail(id),
      );

      return Agency.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception('获取代理公司详情失败: ${e.message}');
    }
  }

  /// 搜索代理公司
  Future<AgencyListResponse> searchAgencies({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchAgencies,
        queryParameters: {
          'keyword': keyword,
          'page': page,
          'page_size': pageSize,
        },
      );

      final data = response.data['data'];
      return AgencyListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('搜索代理公司失败: ${e.message}');
    }
  }
}
