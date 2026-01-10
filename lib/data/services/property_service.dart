import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/property.dart';

/// 房产服务
class PropertyService {
  final ApiClient _apiClient = ApiClient();

  /// 获取房产列表（通用方法）
  /// 
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<PropertyListResponse> getProperties({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.properties,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return PropertyListResponse.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 获取买房房源列表
  /// 
  /// [districtId] 地区 ID
  /// [minPrice] 最低价格
  /// [maxPrice] 最高价格
  /// [minArea] 最小面积
  /// [maxArea] 最大面积
  /// [bedrooms] 房间数
  /// [propertyType] 物业类型
  /// [buildingName] 大厦名称
  /// [sortBy] 排序方式: price_asc, price_desc, area_asc, area_desc, created_at_desc
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<PropertyListResponse> getBuyProperties({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? bedrooms,
    String? propertyType,
    String? buildingName,
    String sortBy = 'created_at_desc',
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.buyProperties,
      queryParameters: {
        if (districtId != null) 'district_id': districtId,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minArea != null) 'min_area': minArea,
        if (maxArea != null) 'max_area': maxArea,
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (propertyType != null) 'property_type': propertyType,
        if (buildingName != null) 'building_name': buildingName,
        'sort_by': sortBy,
        'page': page,
        'page_size': pageSize,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return PropertyListResponse.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 获取租房房源列表
  Future<PropertyListResponse> getRentProperties({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? bedrooms,
    String? propertyType,
    String? buildingName,
    String sortBy = 'created_at_desc',
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.rentProperties,
      queryParameters: {
        if (districtId != null) 'district_id': districtId,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minArea != null) 'min_area': minArea,
        if (maxArea != null) 'max_area': maxArea,
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (propertyType != null) 'property_type': propertyType,
        if (buildingName != null) 'building_name': buildingName,
        'sort_by': sortBy,
        'page': page,
        'page_size': pageSize,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return PropertyListResponse.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 获取房产详情
  Future<Property> getPropertyDetail(int id) async {
    final response = await _apiClient.get(
      ApiEndpoints.propertyDetail(id),
    );

    final data = response.data as Map<String, dynamic>;
    return Property.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 获取精选房源
  Future<List<Property>> getFeaturedProperties({int limit = 12}) async {
    final response = await _apiClient.get(
      ApiEndpoints.featuredProperties,
      queryParameters: {'limit': limit},
    );

    final responseData = response.data as Map<String, dynamic>;
    final properties = responseData['data'] as List;
    return properties
        .map((item) => Property.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
