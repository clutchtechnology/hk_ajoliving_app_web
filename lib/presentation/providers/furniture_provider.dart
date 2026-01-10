import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/furniture_repository.dart';
import '../../data/models/furniture.dart';
import '../../data/services/furniture_service.dart';
import '../../core/network/api_client.dart';

// ==================== 依赖注入 ====================

final apiClientProviderForFurniture = Provider<ApiClient>((ref) => ApiClient());

final furnitureServiceProvider = Provider<FurnitureService>((ref) {
  return FurnitureService(ref.watch(apiClientProviderForFurniture));
});

final furnitureRepositoryProvider = Provider<FurnitureRepository>((ref) {
  return FurnitureRepository(ref.watch(furnitureServiceProvider));
});

// ==================== 家具分类 Provider ====================

final furnitureCategoriesProvider = FutureProvider<List<FurnitureCategory>>((ref) async {
  final repository = ref.watch(furnitureRepositoryProvider);
  return repository.getFurnitureCategories();
});

// ==================== 筛选条件 ====================

/// 家具筛选条件
class FurnitureFilter {
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? brand;
  final String? condition;
  final int? deliveryDistrictId;
  final String? deliveryMethod;
  final String? status;
  final String? keyword;
  final String? sortBy; // price, published_at, view_count
  final String? sortOrder; // asc, desc

  FurnitureFilter({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.brand,
    this.condition,
    this.deliveryDistrictId,
    this.deliveryMethod,
    this.status = 'available', // 默认只显示可用的
    this.keyword,
    this.sortBy,
    this.sortOrder,
  });

  FurnitureFilter copyWith({
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
  }) {
    return FurnitureFilter(
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      brand: brand ?? this.brand,
      condition: condition ?? this.condition,
      deliveryDistrictId: deliveryDistrictId ?? this.deliveryDistrictId,
      deliveryMethod: deliveryMethod ?? this.deliveryMethod,
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  FurnitureFilter clearFilter() {
    return FurnitureFilter(status: 'available');
  }
}

// ==================== 状态类 ====================

class FurnitureState {
  final List<Furniture> furniture;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final FurnitureFilter filter;

  FurnitureState({
    this.furniture = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 0,
    FurnitureFilter? filter,
  }) : filter = filter ?? FurnitureFilter();

  FurnitureState copyWith({
    List<Furniture>? furniture,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    FurnitureFilter? filter,
  }) {
    return FurnitureState(
      furniture: furniture ?? this.furniture,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      filter: filter ?? this.filter,
    );
  }
}

// ==================== 状态管理 ====================

class FurnitureNotifier extends StateNotifier<FurnitureState> {
  final FurnitureRepository _repository;

  FurnitureNotifier(this._repository) : super(FurnitureState());

  /// 加载家具列表
  Future<void> loadFurniture({int? page}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final currentPage = page ?? state.currentPage;
      final response = await _repository.getFurniture(
        categoryId: state.filter.categoryId,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        brand: state.filter.brand,
        condition: state.filter.condition,
        deliveryDistrictId: state.filter.deliveryDistrictId,
        deliveryMethod: state.filter.deliveryMethod,
        status: state.filter.status,
        keyword: state.filter.keyword,
        sortBy: state.filter.sortBy,
        sortOrder: state.filter.sortOrder,
        page: currentPage,
        pageSize: 20,
      );

      state = state.copyWith(
        furniture: response.furniture,
        isLoading: false,
        currentPage: response.page,
        totalPages: response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 搜索家具
  Future<void> search(String keyword) async {
    state = state.copyWith(
      filter: state.filter.copyWith(keyword: keyword),
    );
    await loadFurniture(page: 1);
  }

  /// 更新筛选条件
  void updateFilter(FurnitureFilter filter) {
    state = state.copyWith(filter: filter);
    loadFurniture(page: 1);
  }

  /// 更新分类
  void updateCategory(int? categoryId) {
    state = state.copyWith(filter: state.filter.copyWith(categoryId: categoryId));
    loadFurniture(page: 1);
  }

  /// 更新价格范围
  void updatePriceRange(double? minPrice, double? maxPrice) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        minPrice: minPrice,
        maxPrice: maxPrice,
      ),
    );
    loadFurniture(page: 1);
  }

  /// 更新新旧程度
  void updateCondition(String? condition) {
    state = state.copyWith(
      filter: state.filter.copyWith(condition: condition),
    );
    loadFurniture(page: 1);
  }

  /// 更新交收方式
  void updateDeliveryMethod(String? deliveryMethod) {
    state = state.copyWith(
      filter: state.filter.copyWith(deliveryMethod: deliveryMethod),
    );
    loadFurniture(page: 1);
  }

  /// 更新交收地区
  void updateDeliveryDistrict(int? districtId) {
    state = state.copyWith(
      filter: state.filter.copyWith(deliveryDistrictId: districtId),
    );
    loadFurniture(page: 1);
  }

  /// 更新排序
  void updateSort(String sortBy, String sortOrder) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );
    loadFurniture(page: 1);
  }

  /// 清除筛选
  void clearFilter() {
    state = state.copyWith(filter: FurnitureFilter());
    loadFurniture(page: 1);
  }

  /// 切换页码
  void changePage(int page) {
    loadFurniture(page: page);
  }

  /// 下一页
  void nextPage() {
    if (state.currentPage < state.totalPages) {
      loadFurniture(page: state.currentPage + 1);
    }
  }

  /// 上一页
  void previousPage() {
    if (state.currentPage > 1) {
      loadFurniture(page: state.currentPage - 1);
    }
  }
}

// ==================== Provider ====================

final furnitureProvider = StateNotifierProvider<FurnitureNotifier, FurnitureState>((ref) {
  return FurnitureNotifier(ref.watch(furnitureRepositoryProvider));
});
