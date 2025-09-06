import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/network/connectivity_cubit.dart';
import '../../data/models/repo_model.dart';
import '../bloc/repo_list_bloc.dart';
import '../bloc/theme_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final RepoListBloc bloc;
  final _scrollCtrl = ScrollController();
  final _searchCtrl = TextEditingController(text: 'flutter');

  @override
  void initState() {
    super.initState();
    bloc = GetIt.I<RepoListBloc>()..add(RepoQueryChanged('flutter'));
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels > _scrollCtrl.position.maxScrollExtent - 320) {
        bloc.add(RepoLoadMore());
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Repositories'),
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
      body: Column(
        children: [
          BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
            builder: (context, status) {
              if (status == ConnectivityStatus.offline) {
                return Container(
                  width: double.infinity,
                  color: Colors.amber.withOpacity(0.2),
                  padding: const EdgeInsets.all(8),
                  child: const Text('You are offline. Showing cached data if available.'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by tag (e.g., flutter, swiftui)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onChanged: (v) => bloc.add(RepoQueryChanged(v.trim())),
            ),
          ),
          Expanded(
            child: BlocProvider.value(
              value: bloc,
              child: BlocConsumer<RepoListBloc, RepoListState>(
                listener: (context, state) {
                  if (state.error != null && state.error!.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error!), behavior: SnackBarBehavior.floating),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.loading && state.items.isEmpty) {
                    return _SkeletonList();
                  }
                  if (state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.inbox_outlined, size: 64),
                          const SizedBox(height: 8),
                          const Text('No repositories found'),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => bloc.add(RepoRefresh()),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => bloc.add(RepoRefresh()),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      controller: _scrollCtrl,
                      itemBuilder: (context, index) {
                        if (index == state.items.length) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: state.hasMore
                                ? const Center(child: CircularProgressIndicator())
                                : const Center(child: Text('No more results')),
                          );
                        }
                        final repo = state.items[index];
                        return _RepoTile(repo: repo, isCache: state.isCache);
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemCount: state.items.length + 1,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoTile extends StatelessWidget {
  final RepoModel repo;
  final bool isCache;

  const _RepoTile({required this.repo, required this.isCache});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () => GoRouter.of(context).push('/detail', extra: repo),
        // leading: CircleAvatar(
        //   backgroundImage: CachedNetworkImageProvider(repo.ownerAvatarUrl),
        // ),
        title: Row(
          children: [
            Expanded(child: Text(repo.name, style: const TextStyle(fontWeight: FontWeight.bold))),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_border),
                const SizedBox(width: 4),
                Text('${repo.stargazersCount}'),
              ],
            )
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(repo.ownerLogin),
            const SizedBox(height: 4),
            if (repo.description.isNotEmpty) Text(repo.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            if (isCache) const Text('Cached', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          highlightColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.1),
          child: const ListTile(
            leading: CircleAvatar(radius: 20),
            title: SizedBox(height: 16, width: 120),
            subtitle: SizedBox(height: 12, width: 240),
          ),
        );
      },
    );
  }
}
