import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/repo_model.dart';

class GithubLocalDataSource {
  static const String boxName = 'repo_cache_box';

  Future<void> cacheRepos(String key, List<RepoModel> repos) async {
    final box = await Hive.openBox<String>(boxName);
    final jsonStr = jsonEncode(repos.map((e) => e.toJson()).toList());
    await box.put(key, jsonStr);
  }

  Future<List<RepoModel>> getCachedRepos(String key) async {
    final box = await Hive.openBox<String>(boxName);
    final jsonStr = box.get(key);
    if (jsonStr == null) return [];
    final list = (jsonDecode(jsonStr) as List).cast<Map<String, dynamic>>();
    return list.map((e) => RepoModel.fromJson(e)).toList();
  }
}
