import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  GoogleMapController? controller;
  late final SharedPreferences _prefs;

  ThemeCubit() : super(const ThemeLight());

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('isDark') != null && _prefs.getBool('isDark')!) {
      emit(const ThemeDark());
    }
  }

  Future<void> toggleTheme() async {
    if (state is ThemeDark) {
      await _prefs.setBool('isDark', false);
      await setMapTheme('light');
      emit(const ThemeLight());
    } else {
      await _prefs.setBool('isDark', true);
      await setMapTheme('dark');
      emit(const ThemeDark());
    }
  }

  Future<void> setMapTheme(String theme) async {
    if (theme == 'dark') {
      final String mapStyle =
          await rootBundle.loadString('assets/map_dark.json');
      controller?.setMapStyle(mapStyle);
    } else {
      controller?.setMapStyle('[]');
    }
  }
}
