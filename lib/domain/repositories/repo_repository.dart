import 'package:github_repository_explorer/data/models/repo_model.dart';

abstract class RepoRepository {
  Future<(List<RepoModel>, bool isFromCache)> search(String query, int page);
}
