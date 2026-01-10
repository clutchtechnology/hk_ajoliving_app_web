import '../models/school_net.dart';
import '../services/school_net_service.dart';

/// 校网数据仓库
class SchoolNetRepository {
  final SchoolNetService _schoolNetService;

  SchoolNetRepository(this._schoolNetService);

  Future<SchoolNetListResponse> getSchoolNets({
    String? type,
    int? districtId,
    String? keyword,
    int page = 1,
    int pageSize = 20,
  }) {
    return _schoolNetService.getSchoolNets(
      type: type,
      districtId: districtId,
      keyword: keyword,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<SchoolNet> getSchoolNetDetail(int id) {
    return _schoolNetService.getSchoolNetDetail(id);
  }

  Future<SchoolListResponse> getSchoolsInNet({
    required int schoolNetId,
    int page = 1,
    int pageSize = 20,
  }) {
    return _schoolNetService.getSchoolsInNet(
      schoolNetId: schoolNetId,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<SchoolNetListResponse> searchSchoolNets({
    required String keyword,
    int page = 1,
    int pageSize = 20,
  }) {
    return _schoolNetService.searchSchoolNets(
      keyword: keyword,
      page: page,
      pageSize: pageSize,
    );
  }
}
