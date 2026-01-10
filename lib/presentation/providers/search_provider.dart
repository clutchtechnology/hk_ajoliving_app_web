import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/search.dart';
import '../../data/repositories/search_repository.dart';

/// 搜索 Repository Provider
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository();
});

/// 搜索状态
class SearchState {
  final bool isLoading;
  final String? error;
  final GlobalSearchResponse? globalResults;
  final PropertySearchResponse? propertyResults;
  final EstateSearchResponse? estateResults;
  final AgentSearchResponse? agentResults;
  final List<SearchSuggestion> suggestions;
  final List<SearchHistory> history;

  SearchState({
    this.isLoading = false,
    this.error,
    this.globalResults,
    this.propertyResults,
    this.estateResults,
    this.agentResults,
    this.suggestions = const [],
    this.history = const [],
  });

  SearchState copyWith({
    bool? isLoading,
    String? error,
    GlobalSearchResponse? globalResults,
    PropertySearchResponse? propertyResults,
    EstateSearchResponse? estateResults,
    AgentSearchResponse? agentResults,
    List<SearchSuggestion>? suggestions,
    List<SearchHistory>? history,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      globalResults: globalResults ?? this.globalResults,
      propertyResults: propertyResults ?? this.propertyResults,
      estateResults: estateResults ?? this.estateResults,
      agentResults: agentResults ?? this.agentResults,
      suggestions: suggestions ?? this.suggestions,
      history: history ?? this.history,
    );
  }
}

/// 搜索 Notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository _repository;

  SearchNotifier(this._repository) : super(SearchState());

  /// 全局搜索
  Future<void> globalSearch({
    required String query,
    String? type,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (query.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _repository.globalSearch(
        query: query,
        type: type,
        page: page,
        pageSize: pageSize,
      );

      state = state.copyWith(
        isLoading: false,
        globalResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 搜索房产
  Future<void> searchProperties({
    required String query,
    int? districtId,
    double? minPrice,
    double? maxPrice,
    String? propertyType,
    String? listingType,
    int? bedrooms,
    int? bathrooms,
    double? minArea,
    double? maxArea,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (query.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _repository.searchProperties(
        query: query,
        districtId: districtId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        propertyType: propertyType,
        listingType: listingType,
        bedrooms: bedrooms,
        bathrooms: bathrooms,
        minArea: minArea,
        maxArea: maxArea,
        page: page,
        pageSize: pageSize,
      );

      state = state.copyWith(
        isLoading: false,
        propertyResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 搜索屋苑
  Future<void> searchEstates({
    required String query,
    int? districtId,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (query.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _repository.searchEstates(
        query: query,
        districtId: districtId,
        page: page,
        pageSize: pageSize,
      );

      state = state.copyWith(
        isLoading: false,
        estateResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 搜索代理人
  Future<void> searchAgents({
    required String query,
    int? agencyId,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (query.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _repository.searchAgents(
        query: query,
        agencyId: agencyId,
        page: page,
        pageSize: pageSize,
      );

      state = state.copyWith(
        isLoading: false,
        agentResults: results,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 获取搜索建议
  Future<void> getSearchSuggestions({
    required String query,
    String? type,
    int limit = 10,
  }) async {
    if (query.isEmpty) {
      state = state.copyWith(suggestions: []);
      return;
    }

    try {
      final suggestions = await _repository.getSearchSuggestions(
        query: query,
        type: type,
        limit: limit,
      );

      state = state.copyWith(suggestions: suggestions);
    } catch (e) {
      // 建议获取失败不影响主流程，静默处理
      state = state.copyWith(suggestions: []);
    }
  }

  /// 获取搜索历史
  Future<void> getSearchHistory({int limit = 20}) async {
    try {
      final history = await _repository.getSearchHistory(limit: limit);
      state = state.copyWith(history: history);
    } catch (e) {
      // 历史获取失败不影响主流程，静默处理
      state = state.copyWith(history: []);
    }
  }

  /// 删除搜索历史
  Future<void> deleteSearchHistory({int? id}) async {
    try {
      await _repository.deleteSearchHistory(id: id);
      // 重新加载历史
      await getSearchHistory();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 清空结果
  void clearResults() {
    state = SearchState();
  }
}

/// 搜索 Provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNotifier(repository);
});
