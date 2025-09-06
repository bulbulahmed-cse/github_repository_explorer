part of 'repo_list_bloc.dart';

class RepoListState extends Equatable {
  final List<RepoModel> items;
  final bool loading;
  final bool hasMore;
  final int page;
  final String query;
  final String? error;
  final bool isCache;

  const RepoListState({
    required this.items,
    required this.loading,
    required this.hasMore,
    required this.page,
    required this.query,
    required this.error,
    required this.isCache,
  });

  const RepoListState.initial()
      : items = const [],
        loading = false,
        hasMore = true,
        page = 0,
        query = 'flutter',
        error = null,
        isCache = false;

  RepoListState copyWith({
    List<RepoModel>? items,
    bool? loading,
    bool? hasMore,
    int? page,
    String? query,
    String? error,
    bool? isCache,
  }) =>
      RepoListState(
        items: items ?? this.items,
        loading: loading ?? this.loading,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        query: query ?? this.query,
        error: error,
        isCache: isCache ?? this.isCache,
      );

  @override
  List<Object?> get props => [items, loading, hasMore, page, query, error, isCache];
}
