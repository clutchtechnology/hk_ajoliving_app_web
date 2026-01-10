import '../models/furniture.dart';
import '../services/furniture_service.dart';

/// 家具数据仓库
class FurnitureRepository {
  final FurnitureService _furnitureService;

  FurnitureRepository(this._furnitureService);

  Future<FurnitureListResponse> getFurniture({
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    String? brand,
    String? condition,
    int? deliveryDistrictId,
    String? deliveryMethod,
    String? status,
    String? keyword,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int pageSize = 20,
  }) {
    return _furnitureService.getFurniture(
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      brand: brand,
      condition: condition,
      deliveryDistrictId: deliveryDistrictId,
      deliveryMethod: deliveryMethod,
      status: status,
      keyword: keyword,
      sortBy: sortBy,
      sortOrder: sortOrder,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<List<FurnitureCategory>> getFurnitureCategories() {
    return _furnitureService.getFurnitureCategories();
  }

  Future<Furniture> getFurnitureDetail(int id) {
    return _furnitureService.getFurnitureDetail(id);
  }

  Future<List<FurnitureImage>> getFurnitureImages(int id) {
    return _furnitureService.getFurnitureImages(id);
  }

  Future<List<Furniture>> getFeaturedFurniture() {
    return _furnitureService.getFeaturedFurniture();
  }
}
