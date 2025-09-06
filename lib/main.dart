import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injection.dart';
import 'presentation/bloc/theme_cubit.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/repo_detail_page.dart';
import 'core/network/connectivity_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await configureDependencies();
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) {
                final repo = state.extra;
                return RepoDetailPage(repo: repo);
              },
            ),
          ],
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.I<ThemeCubit>()..loadTheme()),
        BlocProvider(create: (_) => GetIt.I<ConnectivityCubit>()..monitor()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'GitHub Repository Explorer',
            themeMode: state.mode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.blue,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.blue,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
