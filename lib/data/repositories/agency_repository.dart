import '../models/agency.dart';
import '../services/agency_service.dart';

/// 代理公司数据仓库
class AgencyRepository {
  final AgencyService _agencyService;

  AgencyRepository(this._agencyService);

  Future<AgencyListResponse> getAgencies({
    int? districtId,
    double? minRating,
    bool? isVerified,
    String? keyword,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int pageSize = 20,
  }) {
    return _agencyService.getAgencies(
      districtId: districtId,
      minRating: minRating,
      isVerified: isVerified,
      keyword: keyword,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<Agency> getAgencyDetail(int id) {
    return _agencyService.getAgencyDetail(id);
  }

  Future<AgencyListResponse> searchAgencies({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) {
    return _agencyService.searchAgencies(
      keyword: keyword,
      page: page,
      pageSize: pageSize,
    );
  }
}
