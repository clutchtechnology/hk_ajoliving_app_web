import '../models/property.dart';
import '../services/property_service.dart';

/// 房产 Repository
class PropertyRepository {
  final PropertyService _propertyService = PropertyService();

  /// 获取房产列表（通用方法）
  Future<PropertyListResponse> getProperties({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _propertyService.getProperties(
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('获取房产列表失败: $e');
    }
  }

  /// 获取买房房源列表
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
    try {
      return await _propertyService.getBuyProperties(
        districtId: districtId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minArea: minArea,
        maxArea: maxArea,
        bedrooms: bedrooms,
        propertyType: propertyType,
        buildingName: buildingName,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('获取买房房源失败: $e');
    }
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
    try {
      return await _propertyService.getRentProperties(
        districtId: districtId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minArea: minArea,
        maxArea: maxArea,
        bedrooms: bedrooms,
        propertyType: propertyType,
        buildingName: buildingName,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('获取租房房源失败: $e');
    }
  }

  /// 获取房产详情
  Future<Property> getPropertyDetail(int id) async {
    try {
      return await _propertyService.getPropertyDetail(id);
    } catch (e) {
      throw Exception('获取房产详情失败: $e');
    }
  }

  /// 获取精选房源
  Future<List<Property>> getFeaturedProperties({int limit = 12}) async {
    try {
      return await _propertyService.getFeaturedProperties(limit: limit);
    } catch (e) {
      throw Exception('获取精选房源失败: $e');
    }
  }
}
