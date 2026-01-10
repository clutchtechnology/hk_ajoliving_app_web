import '../services/estate_service.dart';
import '../models/estate.dart';

/// 屋苑仓库
class EstateRepository {
  final EstateService _service;

  EstateRepository(this._service);

  /// 获取屋苑列表
  Future<EstateListResponse> getEstates({
    int? districtId,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    String? developer,
    double? minAvgPrice,
    double? maxAvgPrice,
    bool? isFeatured,
    String? keyword,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _service.getEstates(
      districtId: districtId,
      primarySchoolNet: primarySchoolNet,
      secondarySchoolNet: secondarySchoolNet,
      developer: developer,
      minAvgPrice: minAvgPrice,
      maxAvgPrice: maxAvgPrice,
      isFeatured: isFeatured,
      keyword: keyword,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: page,
      pageSize: pageSize,
    );
  }

  /// 获取屋苑详情
  Future<Estate> getEstateDetail(int id) async {
    return await _service.getEstateDetail(id);
  }

  /// 获取屋苑统计数据
  Future<Map<String, dynamic>> getEstateStatistics(int id) async {
    return await _service.getEstateStatistics(id);
  }

  /// 获取屋苑成交记录
  Future<List<dynamic>> getEstateTransactions(int id, {int page = 1, int pageSize = 20}) async {
    return await _service.getEstateTransactions(id, page: page, pageSize: pageSize);
  }

  /// 获取精选屋苑
  Future<List<Estate>> getFeaturedEstates() async {
    return await _service.getFeaturedEstates();
  }
}
