import '../services/serviced_apartment_service.dart';
import '../models/serviced_apartment.dart';

/// 服务式公寓仓库
class ServicedApartmentRepository {
  final ServicedApartmentService _service;

  ServicedApartmentRepository(this._service);

  /// 获取服务式公寓列表
  Future<ServicedApartmentListResponse> getServicedApartments({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? status,
    bool? isFeatured,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _service.getServicedApartments(
      districtId: districtId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      status: status,
      isFeatured: isFeatured,
      page: page,
      pageSize: pageSize,
    );
  }

  /// 获取服务式公寓详情
  Future<ServicedApartment> getServicedApartmentDetail(int id) async {
    return await _service.getServicedApartmentDetail(id);
  }

  /// 获取服务式公寓房型列表
  Future<List<ServicedApartmentUnit>> getServicedApartmentUnits(int id) async {
    return await _service.getServicedApartmentUnits(id);
  }

  /// 获取服务式公寓图片列表
  Future<List<ServicedApartmentImage>> getServicedApartmentImages(int id) async {
    return await _service.getServicedApartmentImages(id);
  }
}
