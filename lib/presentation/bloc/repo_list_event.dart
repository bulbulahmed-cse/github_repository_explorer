part of 'repo_list_bloc.dart';

abstract class RepoListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RepoQueryChanged extends RepoListEvent {
  final String query;
  RepoQueryChanged(this.query);
}

class RepoLoadMore extends RepoListEvent {}

class RepoRefresh extends RepoListEvent {}

class _RepoFetchInternal extends RepoListEvent {
  final String query;
  final bool reset;
  final bool force;
  _RepoFetchInternal({required this.query, this.reset = false, this.force = false});
}
