import '../models/search.dart';
import '../services/search_service.dart';

/// 搜索 Repository
class SearchRepository {
  final SearchService _searchService = SearchService();

  /// 全局搜索
  Future<GlobalSearchResponse> globalSearch({
    required String query,
    String? type,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _searchService.globalSearch(
        query: query,
        type: type,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('搜索失败: $e');
    }
  }

  /// 搜索房产
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
    try {
      return await _searchService.searchProperties(
        query: query,
        districtId: districtId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        propertyType: propertyType,
        listingType: listingType,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        minArea: minArea,
        maxArea: maxArea,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('搜索房产失败: $e');
    }
  }

  /// 搜索屋苑
  Future<EstateSearchResponse> searchEstates({
    required String query,
    int? districtId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _searchService.searchEstates(
        query: query,
        districtId: districtId,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('搜索屋苑失败: $e');
    }
  }

  /// 搜索代理人
  Future<AgentSearchResponse> searchAgents({
    required String query,
    int? agencyId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _searchService.searchAgents(
        query: query,
        agencyId: agencyId,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('搜索代理人失败: $e');
    }
  }

  /// 获取搜索建议
  Future<List<SearchSuggestion>> getSearchSuggestions({
    required String query,
    String? type,
    int limit = 10,
  }) async {
    try {
      return await _searchService.getSearchSuggestions(
        query: query,
        type: type,
        limit: limit,
      );
    } catch (e) {
      throw Exception('获取搜索建议失败: $e');
    }
  }

  /// 获取搜索历史
  Future<List<SearchHistory>> getSearchHistory({
    int limit = 20,
  }) async {
    try {
      return await _searchService.getSearchHistory(limit: limit);
    } catch (e) {
      throw Exception('获取搜索历史失败: $e');
    }
  }

  /// 删除搜索历史
  Future<void> deleteSearchHistory({int? id}) async {
    try {
      await _searchService.deleteSearchHistory(id: id);
    } catch (e) {
      throw Exception('删除搜索历史失败: $e');
    }
  }
}
