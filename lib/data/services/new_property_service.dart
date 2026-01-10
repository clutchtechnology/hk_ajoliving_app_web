import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/new_property.dart';

/// 新盘服务
class NewPropertyService {
  final ApiClient _apiClient = ApiClient();

  /// 获取新盘列表
  /// 
  /// [districtId] 地区 ID
  /// [status] 状态: upcoming, presale, selling, completed
  /// [developer] 开发商名称
  /// [minPrice] 最低价格
  /// [maxPrice] 最高价格
  /// [primarySchoolNet] 小学校网
  /// [secondarySchoolNet] 中学校网
  /// [isFeatured] 是否精选
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<NewPropertyListResponse> getNewProperties({
    int? districtId,
    String? status,
    String? developer,
    double? minPrice,
    double? maxPrice,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    bool? isFeatured,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.newProperties,
      queryParameters: {
        if (districtId != null) 'district_id': districtId,
        if (status != null) 'status': status,
        if (developer != null) 'developer': developer,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (primarySchoolNet != null) 'primary_school_net': primarySchoolNet,
        if (secondarySchoolNet != null) 'secondary_school_net': secondarySchoolNet,
        if (isFeatured != null) 'is_featured': isFeatured,
        'page': page,
        'page_size': pageSize,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return NewPropertyListResponse.fromJson(data['data'] as Map<String, dynamic>);
  }

  /// 获取新盘详情
  Future<NewProperty> getNewPropertyDetail(int id) async {
    final response = await _apiClient.get(
      ApiEndpoints.newPropertyDetail(id),
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return NewProperty.fromJson(data);
  }

  /// 获取新盘户型列表
  Future<List<NewPropertyLayout>> getNewPropertyLayouts(int id) async {
    final response = await _apiClient.get(
      ApiEndpoints.newPropertyLayouts(id),
    );

    final data = response.data['data'] as List;
    return data
        .map((item) => NewPropertyLayout.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
