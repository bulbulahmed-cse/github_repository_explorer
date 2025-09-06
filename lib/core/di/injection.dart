import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';
import '../../data/datasources/github_remote_datasource.dart';
import '../../data/datasources/github_local_datasource.dart';
import '../../data/repositories/repo_repository_impl.dart';
import '../../domain/repositories/repo_repository.dart';
import '../../domain/usecases/search_repos.dart';
import '../../presentation/bloc/repo_list_bloc.dart';
import '../../presentation/bloc/theme_cubit.dart';
import '../network/network_client.dart';
import '../network/connectivity_cubit.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() async {
  getIt.registerLazySingleton<NetworkClient>(() => NetworkClient());
  getIt.registerLazySingleton<GithubRemoteDataSource>(() => GithubRemoteDataSource(getIt()));
  getIt.registerLazySingleton<GithubLocalDataSource>(() => GithubLocalDataSource());
  getIt.registerLazySingleton<RepoRepository>(
      () => RepoRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton<SearchRepos>(() => SearchRepos(getIt()));
  getIt.registerFactory<RepoListBloc>(() => RepoListBloc(getIt(), getIt()));
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getIt.registerLazySingleton<ConnectivityCubit>(() => ConnectivityCubit());
}
