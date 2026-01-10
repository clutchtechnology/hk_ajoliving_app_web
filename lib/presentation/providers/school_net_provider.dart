import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/school_net_repository.dart';
import '../../data/models/school_net.dart';
import '../../data/services/school_net_service.dart';
import '../../core/network/api_client.dart';

// ==================== 依赖注入 ====================

final apiClientProviderForSchoolNet = Provider<ApiClient>((ref) => ApiClient());

final schoolNetServiceProvider = Provider<SchoolNetService>((ref) {
  return SchoolNetService(ref.watch(apiClientProviderForSchoolNet));
});

final schoolNetRepositoryProvider = Provider<SchoolNetRepository>((ref) {
  return SchoolNetRepository(ref.watch(schoolNetServiceProvider));
});

// ==================== 筛选条件 ====================

/// 校网筛选条件
class SchoolNetFilter {
  final String? type; // primary, secondary
  final int? districtId;
  final String? keyword;

  SchoolNetFilter({
    this.type,
    this.districtId,
    this.keyword,
  });

  SchoolNetFilter copyWith({
    String? type,
    int? districtId,
    String? keyword,
  }) {
    return SchoolNetFilter(
      type: type ?? this.type,
      districtId: districtId ?? this.districtId,
      keyword: keyword ?? this.keyword,
    );
  }

  SchoolNetFilter clearFilter() {
    return SchoolNetFilter();
  }
}

// ==================== 状态类 ====================

class SchoolNetState {
  final List<SchoolNet> schoolNets;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final SchoolNetFilter filter;

  SchoolNetState({
    this.schoolNets = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 0,
    SchoolNetFilter? filter,
  }) : filter = filter ?? SchoolNetFilter();

  SchoolNetState copyWith({
    List<SchoolNet>? schoolNets,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    SchoolNetFilter? filter,
  }) {
    return SchoolNetState(
      schoolNets: schoolNets ?? this.schoolNets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      filter: filter ?? this.filter,
    );
  }
}

// ==================== 状态管理 ====================

class SchoolNetNotifier extends StateNotifier<SchoolNetState> {
  final SchoolNetRepository _repository;

  SchoolNetNotifier(this._repository) : super(SchoolNetState());

  /// 加载校网列表
  Future<void> loadSchoolNets({int? page}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final currentPage = page ?? state.currentPage;
      final response = await _repository.getSchoolNets(
        type: state.filter.type,
        districtId: state.filter.districtId,
        keyword: state.filter.keyword,
        page: currentPage,
        pageSize: 20,
      );

      state = state.copyWith(
        schoolNets: response.schoolNets,
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

  /// 搜索校网
  Future<void> search(String keyword) async {
    state = state.copyWith(
      filter: state.filter.copyWith(keyword: keyword),
    );
    await loadSchoolNets(page: 1);
  }

  /// 更新筛选条件
  void updateFilter(SchoolNetFilter filter) {
    state = state.copyWith(filter: filter);
    loadSchoolNets(page: 1);
  }

  /// 更新类型
  void updateType(String? type) {
    state = state.copyWith(filter: state.filter.copyWith(type: type));
    loadSchoolNets(page: 1);
  }

  /// 更新地区
  void updateDistrict(int? districtId) {
    state = state.copyWith(filter: state.filter.copyWith(districtId: districtId));
    loadSchoolNets(page: 1);
  }

  /// 清除筛选
  void clearFilter() {
    state = state.copyWith(filter: SchoolNetFilter());
    loadSchoolNets(page: 1);
  }

  /// 切换页码
  void changePage(int page) {
    loadSchoolNets(page: page);
  }

  /// 下一页
  void nextPage() {
    if (state.currentPage < state.totalPages) {
      loadSchoolNets(page: state.currentPage + 1);
    }
  }

  /// 上一页
  void previousPage() {
    if (state.currentPage > 1) {
      loadSchoolNets(page: state.currentPage - 1);
    }
  }
}

// ==================== Provider ====================

final schoolNetProvider = StateNotifierProvider<SchoolNetNotifier, SchoolNetState>((ref) {
  return SchoolNetNotifier(ref.watch(schoolNetRepositoryProvider));
});
