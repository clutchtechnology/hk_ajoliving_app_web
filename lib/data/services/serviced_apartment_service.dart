import 'package:dio/dio.dart';
import '../models/serviced_apartment.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';

/// 服务式公寓服务
class ServicedApartmentService {
  final ApiClient _apiClient;

  ServicedApartmentService(this._apiClient);

  /// 获取服务式公寓列表
  Future<ServicedApartmentListResponse> getServicedApartments({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? status,
    bool? isFeatured,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };

      if (districtId != null) queryParams['district_id'] = districtId;
      if (minPrice != null) queryParams['min_price'] = minPrice;
      if (maxPrice != null) queryParams['max_price'] = maxPrice;
      if (minRating != null) queryParams['min_rating'] = minRating;
      if (status != null) queryParams['status'] = status;
      if (isFeatured != null) queryParams['is_featured'] = isFeatured;

      final response = await _apiClient.get(
        ApiEndpoints.servicedApartments,
        queryParameters: queryParams,
      );

      final data = response.data as Map<String, dynamic>;
      return ServicedApartmentListResponse.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('获取服务式公寓列表失败: ${e.message}');
    }
  }

  /// 获取服务式公寓详情
  Future<ServicedApartment> getServicedApartmentDetail(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.servicedApartmentDetail(id),
      );

      return ServicedApartment.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception('获取服务式公寓详情失败: ${e.message}');
    }
  }

  /// 获取服务式公寓房型列表
  Future<List<ServicedApartmentUnit>> getServicedApartmentUnits(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.servicedApartmentUnits(id),
      );

      final data = response.data['data'] as List;
      return data.map((item) => ServicedApartmentUnit.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('获取房型列表失败: ${e.message}');
    }
  }

  /// 获取服务式公寓图片列表
  Future<List<ServicedApartmentImage>> getServicedApartmentImages(int id) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.servicedApartmentImages(id),
      );

      final data = response.data['data'] as List;
      return data.map((item) => ServicedApartmentImage.fromJson(item)).toList();
    } on DioException catch (e) {
      throw Exception('获取图片列表失败: ${e.message}');
    }
  }
}
