import 'package:equatable/equatable.dart';

class RepoModel extends Equatable {
  final int id;
  final String name;
  final String fullName;
  final String ownerLogin;
  final String ownerAvatarUrl;
  final String description;
  final int stargazersCount;
  final int forksCount;
  final String htmlUrl;

  const RepoModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.ownerLogin,
    required this.ownerAvatarUrl,
    required this.description,
    required this.stargazersCount,
    required this.forksCount,
    required this.htmlUrl,
  });

  factory RepoModel.fromJson(Map<String, dynamic> json) => RepoModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        fullName: json['full_name'] ?? '',
        ownerLogin: json['owner']?['login'] ?? '',
        ownerAvatarUrl: json['owner']?['avatar_url'] ?? '',
        description: json['description'] ?? '',
        stargazersCount: json['stargazers_count'] ?? 0,
        forksCount: json['forks_count'] ?? 0,
        htmlUrl: json['html_url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'full_name': fullName,
        'owner': {
          'login': ownerLogin,
          'avatar_url': ownerAvatarUrl,
        },
        'description': description,
        'stargazers_count': stargazersCount,
        'forks_count': forksCount,
        'html_url': htmlUrl,
      };

  @override
  List<Object?> get props => [id, name, fullName];
}
