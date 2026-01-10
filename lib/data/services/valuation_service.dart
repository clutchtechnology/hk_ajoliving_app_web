import 'package:dio/dio.dart';
import '../models/valuation.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 估价服务
class ValuationService {
  final ApiClient _apiClient;

  ValuationService(this._apiClient);

  /// 获取估价列表
  Future<ValuationListResponse> getValuations({
    int? districtId,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    double? minAvgPrice,
    double? maxAvgPrice,
    double? minRentalYield,
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
      if (minAvgPrice != null) queryParams['min_avg_price'] = minAvgPrice;
      if (maxAvgPrice != null) queryParams['max_avg_price'] = maxAvgPrice;
      if (minRentalYield != null) queryParams['min_rental_yield'] = minRentalYield;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;
      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;

      final response = await _apiClient.get(
        ApiEndpoints.valuations,
        queryParameters: queryParams,
      );

      // API 返回格式: {code, message, data: {data: [], total, page, page_size}}
      final data = response.data['data'];
      return ValuationListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('获取估价列表失败: ${e.message}');
    }
  }

  /// 搜索估价
  Future<ValuationListResponse> searchValuations({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchValuations,
        queryParameters: {
          'keyword': keyword,
          'page': page,
          'page_size': pageSize,
        },
      );

      final data = response.data['data'];
      return ValuationListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('搜索估价失败: ${e.message}');
    }
  }

  /// 获取屋苑估价详情
  Future<Map<String, dynamic>> getEstateValuation(int estateId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.estateValuation(estateId),
      );

      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('获取屋苑估价详情失败: ${e.message}');
    }
  }

  /// 获取地区估价汇总
  Future<Map<String, dynamic>> getDistrictValuations(int districtId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.districtValuations(districtId),
      );

      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception('获取地区估价汇总失败: ${e.message}');
    }
  }
}
