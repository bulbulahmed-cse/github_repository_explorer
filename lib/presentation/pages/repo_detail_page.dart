import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repository_explorer/presentation/bloc/theme_cubit.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../data/models/repo_model.dart';

class RepoDetailPage extends StatelessWidget {
  final Object? repo;

  const RepoDetailPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final r = repo as RepoModel;
    final themeCubit = context.read<ThemeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Switch(
                value: state.mode == ThemeMode.dark,
                onChanged: (_) => themeCubit.toggle(),
                inactiveThumbColor: Colors.green,
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.green,
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(r.name, style: Theme.of(context).textTheme.titleLarge)),
                Row(
                  children: [
                    const Icon(Icons.star_border),
                    const SizedBox(width: 4),
                    Text('${r.stargazersCount}'),
                    const SizedBox(width: 16),
                    const Icon(Icons.fork_right),
                    const SizedBox(width: 4),
                    Text('${r.forksCount}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: CachedNetworkImageProvider(r.ownerAvatarUrl),
                    ),
                    const SizedBox(height: 12),
                    Text('@${r.ownerLogin}'),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () => launchUrlString(r.htmlUrl, mode: LaunchMode.externalApplication),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Open in GitHub'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (r.description.isNotEmpty) Text(r.description),

          ],
        ),
      ),
    );
  }
}
