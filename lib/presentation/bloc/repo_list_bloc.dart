import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/repo_model.dart';
import '../../domain/usecases/search_repos.dart';
import '../../core/network/connectivity_cubit.dart';

part 'repo_list_event.dart';
part 'repo_list_state.dart';

class RepoListBloc extends Bloc<RepoListEvent, RepoListState> {
  final SearchRepos _searchRepos;
  final ConnectivityCubit _connectivity;
  Timer? _debounce;

  RepoListBloc(this._searchRepos, this._connectivity) : super(const RepoListState.initial()) {
    on<RepoQueryChanged>(_onQueryChanged);
    on<RepoLoadMore>(_onLoadMore);
    on<RepoRefresh>(_onRefresh);
    on<_RepoFetchInternal>(_onFetch);
  }

  void _onQueryChanged(RepoQueryChanged event, Emitter<RepoListState> emit) {
    // Debounce
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      add(_RepoFetchInternal(query: event.query, reset: true));
    });
  }

  Future<void> _onRefresh(RepoRefresh event, Emitter<RepoListState> emit) async {
    add(_RepoFetchInternal(query: state.query, reset: true, force: true));
  }

  Future<void> _onLoadMore(RepoLoadMore event, Emitter<RepoListState> emit) async {
    if (!state.hasMore || state.loading) return;
    add(_RepoFetchInternal(query: state.query, reset: false));
  }

  Future<void> _onFetch(_RepoFetchInternal event, Emitter<RepoListState> emit) async {
    final nextPage = event.reset ? 1 : state.page + 1;
    emit(state.copyWith(loading: true, error: null, isCache: false, page: event.reset ? 0 : state.page));
    try {
      final (items, isCache) = await _searchRepos(event.query, nextPage);
      final list = event.reset ? items : [...state.items, ...items];
      final hasMore = items.isNotEmpty;
      final isOffline = _connectivity.state == ConnectivityStatus.offline;
      emit(state.copyWith(
        items: list,
        page: nextPage,
        hasMore: hasMore,
        loading: false,
        isCache: isCache || isOffline,
        query: event.query,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
