import '../services/new_property_service.dart';
import '../models/new_property.dart';

/// 新盘 Repository
class NewPropertyRepository {
  final NewPropertyService _service = NewPropertyService();

  /// 获取新盘列表
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
    return await _service.getNewProperties(
      districtId: districtId,
      status: status,
      developer: developer,
      minPrice: minPrice,
      maxPrice: maxPrice,
      primarySchoolNet: primarySchoolNet,
      secondarySchoolNet: secondarySchoolNet,
      isFeatured: isFeatured,
      page: page,
      pageSize: pageSize,
    );
  }

  /// 获取新盘详情
  Future<NewProperty> getNewPropertyDetail(int id) async {
    return await _service.getNewPropertyDetail(id);
  }

  /// 获取新盘户型列表
  Future<List<NewPropertyLayout>> getNewPropertyLayouts(int id) async {
    return await _service.getNewPropertyLayouts(id);
  }
}
