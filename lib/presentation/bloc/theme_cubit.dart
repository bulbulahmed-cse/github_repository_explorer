import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeState {
  final ThemeMode mode;
  const ThemeState(this.mode);
}

class ThemeCubit extends Cubit<ThemeState> {
  static const _box = 'settings_box';
  static const _key = 'theme_mode';
  ThemeCubit() : super(const ThemeState(ThemeMode.system));

  Future<void> loadTheme() async {
    final box = await Hive.openBox<String>(_box);
    final raw = box.get(_key);
    if (raw == 'dark') emit(const ThemeState(ThemeMode.dark));
    else if (raw == 'light') emit(const ThemeState(ThemeMode.light));
    else emit(const ThemeState(ThemeMode.system));
  }

  Future<void> toggle() async {
    final box = await Hive.openBox<String>(_box);
    final next = state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await box.put(_key, next == ThemeMode.dark ? 'dark' : 'light');
    emit(ThemeState(next));
  }
}
