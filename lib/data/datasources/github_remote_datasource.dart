import 'package:dio/dio.dart';
import '../../core/network/network_client.dart';
import '../models/repo_model.dart';

class GithubRemoteDataSource {
  final NetworkClient client;
  GithubRemoteDataSource(this.client);

  Future<List<RepoModel>> searchRepos({
    required String query,
    required int page,
    int perPage = 20,
  }) async {
    // Ensure "flutter" default if user left blank
    final q = query.isEmpty ? 'flutter in:name' : '$query in:name';
    final Response response = await client.get('/search/repositories', query: {
      'q': q,
      'sort': 'stars',
      'order': 'desc',
      'per_page': perPage,
      'page': page,
    });
    final items = (response.data['items'] as List).cast<Map<String, dynamic>>();
    return items.map((e) => RepoModel.fromJson(e)).toList();
  }
}
