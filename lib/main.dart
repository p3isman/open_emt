import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:open_emt/data/repositories/emt_repository.dart';
import 'package:open_emt/data/repositories/favorites_repository.dart';
import 'package:open_emt/domain/cubit/theme_cubit/theme_cubit.dart';
import 'package:open_emt/domain/bloc/favorite_stops_bloc/favorite_stops_bloc.dart';
import 'package:open_emt/domain/bloc/stop_info_bloc/stop_info_bloc.dart';
import 'package:open_emt/views/screens/detail_screen/detail_screen.dart';
import 'package:open_emt/views/screens/home_screen/home_screen.dart';
import 'package:open_emt/views/theme/theme.dart';

final GetIt locator = GetIt.instance;

Future<void> _setup() async {
  locator
      .registerLazySingleton<FavoritesRepository>(() => FavoritesRepository());
  locator.registerLazySingleton<EMTRepository>(() => EMTRepository());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setup();
  runApp(const OpenEMT());
}

class OpenEMT extends StatelessWidget {
  const OpenEMT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit()..init(),
        ),
        BlocProvider(
          create: (context) => FavoriteStopsBloc(
              favoritesRepository: locator.get<FavoritesRepository>())
            ..add(const InitializeFavorites()),
        ),
        BlocProvider(
          create: (context) =>
              StopInfoBloc(emtRepository: locator.get<EMTRepository>()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'OpenEMT',
            debugShowCheckedModeBanner: false,
            initialRoute: HomeScreen.route,
            routes: {
              HomeScreen.route: (context) => const HomeScreen(),
              DetailScreen.route: (context) => const DetailScreen(),
            },
            theme:
                state is ThemeDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          );
        },
      ),
    );
  }
}
