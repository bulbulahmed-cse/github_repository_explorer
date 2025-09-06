import '../datasources/github_local_datasource.dart';
import '../datasources/github_remote_datasource.dart';
import '../models/repo_model.dart';
import '../../domain/repositories/repo_repository.dart';

class RepoRepositoryImpl implements RepoRepository {
  final GithubRemoteDataSource remote;
  final GithubLocalDataSource local;
  RepoRepositoryImpl(this.remote, this.local);

  @override
  Future<(List<RepoModel>, bool)> search(String query, int page) async {
    final cacheKey = '${query.isEmpty ? 'flutter' : query}_$page';
    try {
      final items = await remote.searchRepos(query: query, page: page);
      await local.cacheRepos(cacheKey, items);
      return (items, false);
    } catch (_) {
      final cached = await local.getCachedRepos(cacheKey);
      return (cached, true);
    }
  }
}
