import 'package:dio/dio.dart';
import '../models/school_net.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 校网服务
class SchoolNetService {
  final ApiClient _apiClient;

  SchoolNetService(this._apiClient);

  /// 获取校网列表
  Future<SchoolNetListResponse> getSchoolNets({
    String? type,
    int? districtId,
    String? keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };

      if (type != null) queryParams['type'] = type;
      if (districtId != null) queryParams['district_id'] = districtId;
      if (keyword != null && keyword.isNotEmpty) queryParams['keyword'] = keyword;

      final response = await _apiClient.get(
        ApiEndpoints.schoolNets,
        queryParameters: queryParams,
      );

      // API 返回格式: {code, message, data: {items: [], total, page, page_size}}
      final data = response.data['data'];
      return SchoolNetListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('获取校网列表失败: ${e.message}');
    }
  }

  /// 获取校网详情
  Future<SchoolNet> getSchoolNetDetail(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.schoolNetDetail(id),
      );

      return SchoolNet.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception('获取校网详情失败: ${e.message}');
    }
  }

  /// 获取校网内学校列表
  Future<SchoolListResponse> getSchoolsInNet({
    required int schoolNetId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.schoolsInNet(schoolNetId),
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      final data = response.data['data'];
      return SchoolListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('获取校网内学校失败: ${e.message}');
    }
  }

  /// 搜索校网
  Future<SchoolNetListResponse> searchSchoolNets({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.searchSchoolNets,
        queryParameters: {
          'keyword': keyword,
          'page': page,
          'page_size': pageSize,
        },
      );

      final data = response.data['data'];
      return SchoolNetListResponse.fromJson(data);
    } on DioException catch (e) {
      throw Exception('搜索校网失败: ${e.message}');
    }
  }
}
