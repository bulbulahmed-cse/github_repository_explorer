import '../../data/models/repo_model.dart';
import '../repositories/repo_repository.dart';

class SearchRepos {
  final RepoRepository repository;
  SearchRepos(this.repository);

  Future<(List<RepoModel>, bool)> call(String query, int page) {
    return repository.search(query, page);
  }
}
