import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/search.dart';

/// 搜索服务
class SearchService {
  final ApiClient _apiClient = ApiClient();

  /// 全局搜索
  /// 
  /// [query] 搜索关键词
  /// [type] 搜索类型（可选）：property, estate, agent
  /// [page] 页码，默认 1
  /// [pageSize] 每页数量，默认 20
  Future<GlobalSearchResponse> globalSearch({
    required String query,
    String? type,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.globalSearch,
      queryParameters: {
        'keyword': query,
        if (type != null) 'type': type,
        'page': page,
        'page_size': pageSize,
      },
    );

    return GlobalSearchResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// 搜索房产
  /// 
  /// [query] 搜索关键词
  /// [districtId] 地区 ID（可选）
  /// [minPrice] 最低价格（可选）
  /// [maxPrice] 最高价格（可选）
  /// [propertyType] 房产类型（可选）
  /// [listingType] 挂牌类型（可选）：rent, sale
  /// [bedrooms] 卧室数量（可选）
  /// [bathrooms] 浴室数量（可选）
  /// [minArea] 最小面积（可选）
  /// [maxArea] 最大面积（可选）
  /// [page] 页码，默认 1
  /// [pageSize] 每页数量，默认 20
  Future<PropertySearchResponse> searchProperties({
    required String query,
    int? districtId,
    double? minPrice,
    double? maxPrice,
    String? propertyType,
    String? listingType,
    int? bedrooms,
    int? bathrooms,
    double? minArea,
    double? maxArea,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.searchProperties,
      queryParameters: {
        'keyword': query,
        if (districtId != null) 'district_id': districtId,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (propertyType != null) 'property_type': propertyType,
        if (listingType != null) 'listing_type': listingType,
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (minArea != null) 'min_area': minArea,
        if (maxArea != null) 'max_area': maxArea,
        'page': page,
        'page_size': pageSize,
      },
    );

    return PropertySearchResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// 搜索屋苑
  /// 
  /// [query] 搜索关键词
  /// [districtId] 地区 ID（可选）
  /// [page] 页码，默认 1
  /// [pageSize] 每页数量，默认 20
  Future<EstateSearchResponse> searchEstates({
    required String query,
    int? districtId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.searchEstates,
      queryParameters: {
        'keyword': query,
        if (districtId != null) 'district_id': districtId,
        'page': page,
        'page_size': pageSize,
      },
    );

    return EstateSearchResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// 搜索代理人
  /// 
  /// [query] 搜索关键词
  /// [agencyId] 代理公司 ID（可选）
  /// [page] 页码，默认 1
  /// [pageSize] 每页数量，默认 20
  Future<AgentSearchResponse> searchAgents({
    required String query,
    int? agencyId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.searchAgents,
      queryParameters: {
        'keyword': query,
        if (agencyId != null) 'agency_id': agencyId,
        'page': page,
        'page_size': pageSize,
      },
    );

    return AgentSearchResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// 获取搜索建议
  /// 
  /// [query] 搜索关键词前缀
  /// [type] 搜索类型（可选）：property, estate, agent
  /// [limit] 返回数量，默认 10
  Future<List<SearchSuggestion>> getSearchSuggestions({
    required String query,
    String? type,
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.searchSuggestions,
      queryParameters: {
        'keyword': query,
        if (type != null) 'type': type,
        'limit': limit,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final suggestions = data['data'] as List;
    return suggestions
        .map((item) => SearchSuggestion.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// 获取搜索历史
  /// 
  /// [limit] 返回数量，默认 20
  Future<List<SearchHistory>> getSearchHistory({
    int limit = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.searchHistory,
      queryParameters: {
        'limit': limit,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final history = data['data'] as List;
    return history
        .map((item) => SearchHistory.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// 删除搜索历史
  /// 
  /// [id] 历史记录 ID（可选，不传则删除全部）
  Future<void> deleteSearchHistory({int? id}) async {
    if (id != null) {
      await _apiClient.delete('${ApiEndpoints.searchHistory}/$id');
    } else {
      await _apiClient.delete(ApiEndpoints.searchHistory);
    }
  }
}
