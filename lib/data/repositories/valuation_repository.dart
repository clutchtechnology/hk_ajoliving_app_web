import '../models/valuation.dart';
import '../services/valuation_service.dart';

/// 估价数据仓库
class ValuationRepository {
  final ValuationService _valuationService;

  ValuationRepository(this._valuationService);

  Future<ValuationListResponse> getValuations({
    int? districtId,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    double? minAvgPrice,
    double? maxAvgPrice,
    double? minRentalYield,
    String? keyword,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int pageSize = 20,
  }) {
    return _valuationService.getValuations(
      districtId: districtId,
      primarySchoolNet: primarySchoolNet,
      secondarySchoolNet: secondarySchoolNet,
      minAvgPrice: minAvgPrice,
      maxAvgPrice: maxAvgPrice,
      minRentalYield: minRentalYield,
      keyword: keyword,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<ValuationListResponse> searchValuations({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) {
    return _valuationService.searchValuations(
      keyword: keyword,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<Map<String, dynamic>> getEstateValuation(int estateId) {
    return _valuationService.getEstateValuation(estateId);
  }

  Future<Map<String, dynamic>> getDistrictValuations(int districtId) {
    return _valuationService.getDistrictValuations(districtId);
  }
}
